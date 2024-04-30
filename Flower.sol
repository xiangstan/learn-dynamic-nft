// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";

contract Floer is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable, AutomationCompatibleInterface {
    uint256 private _nextTokenId;
    uint256 public interval;
    uint256 public lastTimeStamp;

    string[] IpfsUri = [
       "https://ipfs.io/ipfs/QmVCZ6hVENjkdCDLMoovNCR5S6bSisUQnBKPibb8XXSJqF/seed.json",
       "https://ipfs.io/ipfs/QmVCZ6hVENjkdCDLMoovNCR5S6bSisUQnBKPibb8XXSJqF/purple-sprout.json",
       "https://ipfs.io/ipfs/QmVCZ6hVENjkdCDLMoovNCR5S6bSisUQnBKPibb8XXSJqF/purple-blooms.json"
   ];


    constructor(address initialOwner, uint256 _interval)
        ERC721("Floer", "FLW")
        Ownable(initialOwner)
    {
        interval = _interval;
        lastTimeStamp = block.timestamp;
    }

    function safeMint() public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, IpfsUri[0]);
    }

    function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory /* performData */)
    {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
        // We don't use the checkData in this example. The checkData is defined when the Upkeep was registered.
    }

    function performUpkeep(bytes calldata /* performData */) external override {
        if ((block.timestamp - lastTimeStamp) > interval) {
            lastTimeStamp = block.timestamp;
            // for loop for all
            if (keccak256(abi.encodePacked(tokenURI(0))) == keccak256(abi.encodePacked(IpfsUri[0]))) {
                _setTokenURI(0, IpfsUri[1]);
                // case update 1 to 2
            } else if (keccak256(abi.encodePacked(tokenURI(1))) == keccak256(abi.encodePacked(IpfsUri[1]))) {
                _setTokenURI(0, IpfsUri[2]);
            } else {
                _setTokenURI(0, IpfsUri[1]);
            }
        }
        // We don't use the performData in this example. The performData is generated by the Automation Node's call to your checkUpkeep function
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
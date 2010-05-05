Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab0EEHn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 03:43:59 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:46369 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab0EEHn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 03:43:58 -0400
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 May 2010 03:43:58 EDT
Message-ID: <4BE11FA0.20703@parrot.com>
Date: Wed, 5 May 2010 09:34:56 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Reuben.Dowle@navico.com" <Reuben.Dowle@navico.com>
Subject: Re: [PATCHv2 1/2] mtd: nand: Extend NAND flash detection to new MLC
 chips
References: <17c88de31cd52bb3794569c28cd2ae51996e6260@localhost.localdomain> <10137ab89de6e6d229798d6f397688b0807024da@localhost.localdomain>
In-Reply-To: <10137ab89de6e6d229798d6f397688b0807024da@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kevin Cernekee a écrit :
> Some of the newer MLC devices have a 6-byte ID sequence in which
> several field definitions differ from older chips in a manner that is
> not backward compatible.  For instance:
> 
Doesn't these nand support ONFI "Read Parameter Page" (cmd 0xec) ?
If yes it will be a more generic way to detect new nand features.


Matthieu




> Samsung K9GAG08U0M (5-byte sequence): ec d5 14 b6 74
> 4th byte, bits 1:0 encode the page size: 0=1KiB, 1=2KiB, 2=4KiB, 3=8KiB
> 4th byte, bits 5:4 encode the block size: 0=64KiB, 1=128KiB, ...
> 4th byte, bit 6 encodes the OOB size: 0=8B/512B, 1=16B/512B
> 
> Samsung K9GAG08U0D (6-byte sequence): ec d5 94 29 34 41
> 4th byte, bits 1:0 encode the page size: 0=2KiB, 1=4KiB, 3=8KiB, 4=rsvd
> 4th byte, bits 7;5:4 encode the block size: 0=128KiB, 1=256KiB, ...
> 4th byte, bits 6;3:2 encode the OOB size: 1=128B/page, 2=218B/page
> 
> This patch uses the new 6-byte scheme if the following conditions are
> all true:
> 
> 1) The ID code wraps around after exactly 6 bytes
> 
> 2) Manufacturer is Samsung
> 
> 3) 6th byte is zero
> 
> The patch also extends the maximum OOB size from 128B to 256B.
> 



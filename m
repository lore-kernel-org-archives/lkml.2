Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab0ERBEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 21:04:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753255Ab0ERBEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 21:04:47 -0400
Date: Mon, 17 May 2010 18:02:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robert Hancock <hancockrwd@gmail.com>
cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Yuhong Bao <yuhongbao_386@hotmail.com>, venkatesh.pallipadi@intel.com,
       markh@compro.net, dmarkh@cfl.rr.com, andi@firstfloor.org,
       alain@knaff.lu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Disable HPET MSI on ATI SB700/SB800
In-Reply-To: <4BF1E5BE.9010000@gmail.com>
Message-ID: <alpine.LFD.2.00.1005171800050.4195@i5.linux-foundation.org>
References: <87bphpd4rt.fsf@basil.nowhere.org> <4B32565E.6000501@compro.net> <20091223191806.GA3336@linux-os.sc.intel.com> <4B3270FE.5090607@compro.net> <1261600243.16916.56.camel@localhost.localdomain> <4B476E8D.1030308@compro.net> <20100121190952.GA32523@linux-os.sc.intel.com>
 <SNT125-W12BC46C506A5BB777A06B5C3610@phx.gbl> <20100125171059.GB5041@alberich.amd.com> <20100517145943.GV5888@alberich.amd.com> <4BF1E5BE.9010000@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 May 2010, Robert Hancock wrote:
> 
> If one wanted, you could disable HPET MSI on this chipset only when a driver
> requests an ISA DMA channel. Then if there's no floppy or other LPC DMA device
> present, it can stay enabled. I don't know if it's worth the trouble, though.

Nope, that wouldn't work.

Imagine a driver that already loaded, and is already using MSI (say, 
network device). What happens now if you want to access the floppy and 
load the floppy module? Oh, you can't? Need to bring down the network 
interface, unload that module first? Not practical.

Sure, in theory we can do some crazy callback for "you now need to re-do 
your interrupt registration" for all devices. In practice, I can onyl say 
"not going to happen".

		Linus

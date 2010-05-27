Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab0E0RKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:10:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497Ab0E0RKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:10:16 -0400
Date: Thu, 27 May 2010 10:06:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robert Hancock <hancockrwd@gmail.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
In-Reply-To: <4BFE0FAB.9040009@gmail.com>
Message-ID: <alpine.LFD.2.00.1005270956380.3689@i5.linux-foundation.org>
References: <20100513075728.GF30110@core.coreip.homeip.net> <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org> <20100513160117.GB22238@core.coreip.homeip.net> <alpine.LFD.2.00.1005130943460.3711@i5.linux-foundation.org>
 <4BFE0FAB.9040009@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 May 2010, Robert Hancock wrote:
> 
> I don't think they did anything wrong in their BIOS, it's working exactly as
> the spec intended. There is no PS/2 controller, and the ACPI PnP tables do not
> list one.

You seem to be unable to read. 

First off, there _is_ a PS2 controller. You can't get any normal Intel 
chips without one, as far as I can tell. The lines may not be brought out, 
but that's immaterial.

Secondly, even if there wasn't any - or the controller is actively 
disabled, Linux handles that situation perfectly fine. The fact is, the 
low ports (< 0x100) are reserved for motherboard devices, and Linux probes 
the things fine.

Thirdly, the thing is, PnP tables are incomplete. Always. They don't prove 
a negative. Deal with it. It's a _fact_.

So Apple must have actively screwed things up. If you can't admit that, 
it's your problem.

> Long and the short of it is, it seems pretty safe to say that on any ACPI
> machine, if there's no PnP entry for PS/2 devices, the BIOS does not intend
> for the OS to use them. 

And your argument is pure and utter sh*t. I don't know why I even bother 
replying to it, but I'll try one more time:

 - BIOS writers are incompetent drug-addled morons. Your argument that 
   "the BIOS does not intend for the OS to use them" is a totally idiotic 
   argument, for the simple reason that it's not up to the BIOS writers, 
   and even if it _was_ up to them, they always screw things up.

The thing boils down to: we cannot trust the firmware anyway (this is a 
simple _fact_, not some random opinion), and no, the BIOS writers do not 
have some magic powers that allow them to determine how hardware should be 
used.

Should we always use PIO mode for IDE just because the BIOS may have set 
it up that way? Even if we know better? It's the exact same issue: 
firmware simply isn't the last word. It shouldn't be in the first place, 
but more importantly, it _cannot_ be, because the BIOS writers have shown 
themselves to be inevitably incompetent.

And Apple BIOS writers seem to be worse than average. The _average_ BIOS 
writer tends to still result in working keyboards (or properly disabled 
ones). The incompetent ones do bad things with SMM and actively break the 
keyboard. Apple is not alone in this, although I think this is the first 
time I hear of somebody breaking it quite _that_ badly (normally it's just 
"horribly bad latency due to SMM traps").

		Linus

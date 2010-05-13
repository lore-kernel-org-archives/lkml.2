Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab0EMPG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:06:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754179Ab0EMPG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:06:56 -0400
Date: Thu, 13 May 2010 08:04:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bastien Nocera <hadess@hadess.net>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.34-rc6
In-Reply-To: <1273762051.2308.4671.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1005130751300.3711@i5.linux-foundation.org>
References: <20100513075728.GF30110@core.coreip.homeip.net>  <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org> <1273762051.2308.4671.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 May 2010, Bastien Nocera wrote:
> 
> Maybe you didn't update to the latest firmwares on you Mac Mini, and
> didn't see the problem with the updated BIOSes, I don't know.

I can't update the firmware, since it's some random OS X program that does 
it (and I don't have OS X on the machine).

But where does it lock up? During the boot probing? Or does it probe as 
having a keyboard because Apple added some crazy SMM code to try to 
emulate one with USB? 

Afaik, the Apple hardware actually does _physically_ have a keyboard 
controller (it's on the regular intel southbridge silicon, afaik), it just 
isn't connected to anything. And I think it is turned off in some of the 
southbridge control registers. The control registers also allow trapping 
into SMI when accessing the keyboard control registers, and maybe Apple 
screwed up there somewhere.

On one of my Mac Mini's (didn't check the other), I get this:

	[    2.955087] PNP: No PS/2 controller found. Probing ports directly.
	[    2.958475] i8042.c: No controller found.
	[    2.960998] mice: PS/2 mouse device common for all mice

what do you get?

The thing is, there's a _lot_ of machines out there with no legacy 
keyboard support. They tend to work. We have timeouts for the i8042 
commands we do during init, but maybe we missed some case. And maybe we 
could easily add some extra tests too.

A few printk's in the i8042 init routines to show where it locks up would 
be good.. I assume you did that already if you and Dmitry already tried to 
debug this. Where's the original thread?

			Linus

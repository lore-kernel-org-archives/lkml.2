Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667Ab0J0I5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 04:57:41 -0400
Received: from c-67-162-90-113.hsd1.in.comcast.net ([67.162.90.113]:47967 "HELO
	kosh.dhis.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755642Ab0J0I5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 04:57:40 -0400
Message-ID: <20101027085738.1837.qmail@kosh.dhis.org>
From: pacman@kosh.dhis.org
Subject: Pegasos OHCI bug (was Re: PROBLEM: memory corrupting bug, bisected to 6dda9d55)
To: benh@kernel.crashing.org (Benjamin Herrenschmidt)
Date: Wed, 27 Oct 2010 03:57:38 -0500 (GMT+5)
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        matt@genesi-usa.com
In-Reply-To: <1287608215.2198.23.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt writes:
> 
> Ok so you'll have to make up a "workaround" in prom_init that looks for
> OHCI's in the device-tree and disable them.
> 
> Check if the OHCI node has some existing f-code words you can use for
> that with "dev /path-to-ohci words" in OF for example. If not, you may
> need to use the low level register accessors. Use OF client interface
> "interpret" to run forth code from C.

I responded with a long list of reasons that I'm not qualified to do that
work myself:
|Here are the major problems:
|
|1. How do I locate all usb nodes in the device tree?
|
|2. How do I know if a particular usb node is OHCI?
|
|3. Knowing that a node is OHCI, how do I know where its control registers
|are? I'm sure this is calculated from the "reg" property but I don't see how.
|
|4. Knowing where the control registers are, how do I access them? Do I need
|to request a virt-to-phys mapping or can I assume that it's already mapped,
|or that the "rl!" command will do the right thing with a physical address?
|
|5. Which control register should I use to tell the OHCI to be quiet? Just do
|a general reset, or is there something that specifically turns off the
|counter that's been causing the trouble?

Since then, the silence has been deafening.

My assumption now is that this is not ever getting fixed. I'm certainly not
able to fix it. I'm not a even kernel programmer! I got far enough to
diagnose the cause just with the "add more printk's and boot it again"
technique. Hundreds of reboots trying to figure it out. I was a conscientious
bug-reporter, I thought.

I could pull the PCI card and be done with it. I never used those USB ports
anyway. But after all the suffering I went through to find this bug... the
crashing e2fsck's and consequent filesystem corruption... I hate the idea of
surrendering to it. There are possibly other affected users who I'd be
abandoning to suffer similarly in the future.

For the last week I've studied OpenFirmware as hard as I can. I read the spec
cover to cover. And the USB annex, and the PCI annex. But I'm still lost in
all the different address formats.

I took my best guess on how to handle this problem, and ran with it, ending
up with a 97-line Forth script, and that was just to get a virtual address,
not to actually do anything with it, and it used a hardcoded device path. But
it didn't work, all I got was an "invalid pointer" error. I made another
guess at something that wasn't documented anywhere (the fact that this stuff
is insufficiently documented is the one thing I can state with complete
confidence!) and out came a successful translation to a virtual address: 0.

If I'm the only one fighting this bug, the bug wins.

-- 
Alan Curry

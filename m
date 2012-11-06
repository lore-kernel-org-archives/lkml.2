Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2KFAHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 19:07:17 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:49647 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab2KFAHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 19:07:14 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <6AE080B68D46FC4BA2D2769E68D765B708174B7D@039-SN2MPN1-023.039d.mgd.msft.net>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <6AE080B68D46FC4BA2D2769E68D765B708174B7D@039-SN2MPN1-023.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 06 Nov 2012 00:07:03 +0000
To: Tabi Timur-B04825 <B04825@freescale.com>
CC: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Message-ID: <f5e162ce-090e-4561-b27c-2b041ca0bee9@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Tabi Timur-B04825 <B04825@freescale.com> wrote:

>On Mon, Nov 5, 2012 at 2:40 PM, Grant Likely
><grant.likely@secretlab.ca> wrote:
>
>> Jane is building custom BeagleBone expansion boards called 'capes'.
>She
>> can boot the system with a stock BeagleBoard device tree, but
>additional
>> data is needed before a cape can be used. She could replace the FDT
>file
>> used by U-Boot with one that contains the extra data, but she uses
>the
>> same Linux system image regardless of the cape, and it is
>inconvenient
>> to have to select a different device tree at boot time depending on
>the
>> cape.
>
>What's wrong with having the boot loader detect the presence of the
>Cape and update the device tree accordingly?  We do this all the time
>in U-Boot.  Doing stuff like reading EEPROMs and testing for the
>presence of hardware is easier in U-Boot than in Linux.
>
>For configurations that can be determined by the boot loader, I'm not
>sure overlays are practical.

>From the discussion in the previous thread, I'm sufficiently convinced that it is an important use case. I certainly disagree with the assertion that it is always easier to do it in U-Boot. Sometimes the kernel is the better place.

>
>> Nigel is building a real-time video processing system around a MIPS
>SoC
>> and a Virtex FPGA. Video data is streamed through the FPGA for post
>> processing operations like motion tracking or compression. The FPGA
>is
>> configured via the SPI bus, and is also connected to GPIO lines and
>the
>> memory mapped peripheral bus. Nigel has designed several FPGA
>> configurations for different video processing tasks. The user will
>> choose which configuration to load which can even be reprogrammed at
>> runtime to switch tasks.
>
>Now this, on the other hand, makes more sense.  If the hardware
>configuration is literally user-configurable, then okay.  However, I'm
>not sure I see the need to update the device tree.  The device tree is
>generally for hardware that cannot be discovered/probed by the device
>driver.  If we're loading a configuration from user space, doesn't the
>driver already know what the hardware's capabilities are, since it's
>the one doing the uploading of a new FPGA code?

Not if the driver is only responsible for loading the bitstream. There is already a xilinx driver that does things this way.

> Why not skip the
>device tree update and just tell the driver what the new capabilities
>are?

How? What format will that data be in if not device tree?

g.

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.

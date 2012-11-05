Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286Ab2KEVly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 16:41:54 -0500
Received: from [216.32.180.188] ([216.32.180.188]:48093 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932162Ab2KEVlw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 16:41:52 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI9371Izz1de0h1202h1d1ah1d2ahzzz2dh2a8h668h839h8e2h8e3hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bhbe9i1155h)
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
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
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
Thread-Topic: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
Thread-Index: AQHNu54kuqdNMyRX6kaXWyq1/nNWiQ==
Date: Mon, 5 Nov 2012 21:40:16 +0000
Message-ID: <6AE080B68D46FC4BA2D2769E68D765B708174B7D@039-SN2MPN1-023.039d.mgd.msft.net>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
In-Reply-To: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.112.97.129]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <6932259F391B4F4AB9A0C0DF5FBDE793@mgd.freescale.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 2:40 PM, Grant Likely <grant.likely@secretlab.ca> wrote:

> Jane is building custom BeagleBone expansion boards called 'capes'. She
> can boot the system with a stock BeagleBoard device tree, but additional
> data is needed before a cape can be used. She could replace the FDT file
> used by U-Boot with one that contains the extra data, but she uses the
> same Linux system image regardless of the cape, and it is inconvenient
> to have to select a different device tree at boot time depending on the
> cape.

What's wrong with having the boot loader detect the presence of the
Cape and update the device tree accordingly?  We do this all the time
in U-Boot.  Doing stuff like reading EEPROMs and testing for the
presence of hardware is easier in U-Boot than in Linux.

For configurations that can be determined by the boot loader, I'm not
sure overlays are practical.

> Nigel is building a real-time video processing system around a MIPS SoC
> and a Virtex FPGA. Video data is streamed through the FPGA for post
> processing operations like motion tracking or compression. The FPGA is
> configured via the SPI bus, and is also connected to GPIO lines and the
> memory mapped peripheral bus. Nigel has designed several FPGA
> configurations for different video processing tasks. The user will
> choose which configuration to load which can even be reprogrammed at
> runtime to switch tasks.

Now this, on the other hand, makes more sense.  If the hardware
configuration is literally user-configurable, then okay.  However, I'm
not sure I see the need to update the device tree.  The device tree is
generally for hardware that cannot be discovered/probed by the device
driver.  If we're loading a configuration from user space, doesn't the
driver already know what the hardware's capabilities are, since it's
the one doing the uploading of a new FPGA code?  Why not skip the
device tree update and just tell the driver what the new capabilities
are?

-- 
Timur Tabi
Linux kernel developer at Freescale

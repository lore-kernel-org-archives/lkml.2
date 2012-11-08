Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2KHN2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:28:45 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38198 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab2KHN2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:28:43 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <509AE247.3000404@gmail.com>
Date: Thu, 8 Nov 2012 14:28:39 +0100
Cc: Tabi Timur-B04825 <B04825@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Matt Porter <mporter@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <356155A1-776B-4AA5-A912-14CE7D9AE42C@dominion.thruhere.net>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <6AE080B68D46FC4BA2D2769E68D765B708174B7D@039-SN2MPN1-023.039d.mgd.msft.net> <509AE247.3000404@gmail.com>
To: Ryan Mallon <rmallon@gmail.com>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 7 nov. 2012, om 23:35 heeft Ryan Mallon <rmallon@gmail.com> het volgende geschreven:

> On 06/11/12 08:40, Tabi Timur-B04825 wrote:
>> On Mon, Nov 5, 2012 at 2:40 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> 
>>> Jane is building custom BeagleBone expansion boards called 'capes'. She
>>> can boot the system with a stock BeagleBoard device tree, but additional
>>> data is needed before a cape can be used. She could replace the FDT file
>>> used by U-Boot with one that contains the extra data, but she uses the
>>> same Linux system image regardless of the cape, and it is inconvenient
>>> to have to select a different device tree at boot time depending on the
>>> cape.
>> 
>> What's wrong with having the boot loader detect the presence of the
>> Cape and update the device tree accordingly?  We do this all the time
>> in U-Boot.  Doing stuff like reading EEPROMs and testing for the
>> presence of hardware is easier in U-Boot than in Linux.
> 
> This is probably okay for some hardware, but doesn't work in the general
> case. Not all hardware is detectable, for example a cape which just adds
> a set of LEDs for GPIO pins. Also, some hardware might not easily be
> detectable without adding additional complexity to the boot loader.

And as Pantelis mentioned before, I really don't want my users to change the bootloader whenever they add a new LED. Touching the bootloader is just too accident prone, we had a ton of RMA requests for older versions of the beagleboard from people trying to upgrade u-boot.

Apart from the above I'd like to have fewer points of failure. Right now I need to keep uImage and foo.dtb in sync and I hate to add u-boot to that equasion as well.

regards,

Koen
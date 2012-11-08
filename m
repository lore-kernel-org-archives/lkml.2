Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab2KHRBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:01:48 -0500
Received: from rs130.luxsci.com ([72.32.115.17]:58816 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756426Ab2KHRBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:01:46 -0500
Message-ID: <509BE53F.4040609@firmworks.com>
Date: Thu, 08 Nov 2012 07:00:47 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Koen Kooi <koen@dominion.thruhere.net>
CC: Ryan Mallon <rmallon@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Wood Scott-B07421 <B07421@freescale.com>, Matt Porter <mporter@ti.com>,
        Tabi Timur-B04825 <B04825@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Russ Dill <Russ.Dill@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices
 to mach-omap2)
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <6AE080B68D46FC4BA2D2769E68D765B708174B7D@039-SN2MPN1-023.039d.mgd.msft.net> <509AE247.3000404@gmail.com> <356155A1-776B-4AA5-A912-14CE7D9AE42C@dominion.thruhere.net>
In-Reply-To: <356155A1-776B-4AA5-A912-14CE7D9AE42C@dominion.thruhere.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Lux-Comment: Message qA8H0nPc032252 sent by user #11875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/8/2012 3:28 AM, Koen Kooi wrote:
> 
> Op 7 nov. 2012, om 23:35 heeft Ryan Mallon <rmallon@gmail.com> het volgende geschreven:
> 
>> On 06/11/12 08:40, Tabi Timur-B04825 wrote:
>>> On Mon, Nov 5, 2012 at 2:40 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>>
>>>> Jane is building custom BeagleBone expansion boards called 'capes'. She
>>>> can boot the system with a stock BeagleBoard device tree, but additional
>>>> data is needed before a cape can be used. She could replace the FDT file
>>>> used by U-Boot with one that contains the extra data, but she uses the
>>>> same Linux system image regardless of the cape, and it is inconvenient
>>>> to have to select a different device tree at boot time depending on the
>>>> cape.
>>>
>>> What's wrong with having the boot loader detect the presence of the
>>> Cape and update the device tree accordingly?  We do this all the time
>>> in U-Boot.  Doing stuff like reading EEPROMs and testing for the
>>> presence of hardware is easier in U-Boot than in Linux.
>>
>> This is probably okay for some hardware, but doesn't work in the general
>> case. Not all hardware is detectable, for example a cape which just adds
>> a set of LEDs for GPIO pins. Also, some hardware might not easily be
>> detectable without adding additional complexity to the boot loader.
> 
> And as Pantelis mentioned before, I really don't want my users to change the bootloader whenever they add a new LED. Touching the bootloader is just too accident prone, we had a ton of RMA requests for older versions of the beagleboard from people trying to upgrade u-boot.

One possibility for dynamic device tree mods would be to run Open
Firmware from u-boot and have it generate the device tree and possibly
modify it either interactively or from a script loaded from a file or
the network.  OFW could then either load Linux directly or return to
u-boot, which would proceed with loading.

> 
> Apart from the above I'd like to have fewer points of failure. Right now I need to keep uImage and foo.dtb in sync and I hate to add u-boot to that equasion as well.
> 
> regards,
> 
> Koen
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab0JFSBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:01:00 -0400
Received: from mail.sdinet.de ([78.47.32.153]:53767 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759161Ab0JFSA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:00:59 -0400
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Oct 2010 14:00:58 EDT
Date: Wed, 6 Oct 2010 19:52:06 +0200 (CEST)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
cc: Marcel Holtmann <holtmann@linux.intel.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
Subject: Re: RFC: btusb firmware load help
In-Reply-To: <AANLkTik9w4_PdcEsbRHakLcxcD334_1Q8hGArxTXPCGF@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1010061948470.24463@aurora.sdinet.de>
References: <20100924230730.GB6566@tux> <1286266981.17473.33.camel@aeonflux> <20101005192814.GB11831@tux> <1286308731.2588.13.camel@aeonflux> <AANLkTimz7U52_qHaTutQDOFQde+GrWJRA0WpqY__FPgi@mail.gmail.com> <1286349552.6145.11.camel@aeonflux>
 <AANLkTimDvgFtoGLEjgWyYRrhQy6Num-rn_2WYO4Lf84b@mail.gmail.com> <1286380566.6145.42.camel@aeonflux> <20101006163816.GE7070@tux> <AANLkTik9w4_PdcEsbRHakLcxcD334_1Q8hGArxTXPCGF@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Oct 2010, Luis R. Rodriguez wrote:

> I just got this description from Sady:
> 
> -------------------------------------------------------------------------------------------------------------------
> With eeprom based AR3011 hardware, normally this device gets detected
> as a normal USB device with VID=0x0CF3, PID=0x3000.
> Ath3k DFU driver will download the firmware in to RAM.
> Due to firmware download in the RAM it is exposed as new device
> with VID=0x0CF3, PID=0x3002 to host Bluetooth sub system and btusb.ko
> driver probe routine gets called to bring up Bluetooth interface.
> This is the normal procedure we have done so far on Linux.
> 
> With sflash based AR3011 hardware, when we connect the device to USB
> port it gets detected as a Bluetooth device because of firmware in
> Flash (VID=0x0CF3, PID=0x3002). This triggers the Bluetooth sub
> system driver (btusb.ko) directly in the host instead of ath3k
> DFU driver. Therefore, there is no firmware downloaded in to the
> RAM to bring up Bluetooth at this point. This is the problem
> we're trying to "fix".
> -------------------------------------------------------------------------------------------------------------------
> 
> With the above patch we'd get ath3k to do the firmware uploading but
> I'm afraid that we'll go into a loop here unless we can figure out a
> way to get btusb to know the device is now ready.

Modify the firmware file so that after loading the firmware it gets for 
example VID=0x0CF3, PID=0x3003.

Blacklist VID=0x0CF3, PID=0x3002 in btusb and add it to ath3k.

>From then on VID=0x0CF3, PID=0x3000 and PID=0x3002 mean "need firmware" 
and PID=0x3003 is the operational state (like half of your PID=0x3002 
usage is now)

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.

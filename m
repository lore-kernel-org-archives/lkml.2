Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab0JGQmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 12:42:38 -0400
Received: from senator.holtmann.net ([87.106.208.187]:48292 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab0JGQmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 12:42:37 -0400
Subject: Re: RFC: btusb firmware load help
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Bala Shanmugam <sbalashanmugam@atheros.com>
Cc: Shanmugamkamatchi Balashanmugam 
	<Shanmugamkamatchi.Balashanmugam@atheros.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
In-Reply-To: <4CADF6BF.6070305@atheros.com>
References: <1286349552.6145.11.camel@aeonflux>
	 <AANLkTimDvgFtoGLEjgWyYRrhQy6Num-rn_2WYO4Lf84b@mail.gmail.com>
	 <1286380566.6145.42.camel@aeonflux> <20101006163816.GE7070@tux>
	 <AANLkTik9w4_PdcEsbRHakLcxcD334_1Q8hGArxTXPCGF@mail.gmail.com>
	 <20101006173949.GG7070@tux>
	 <1286387660.3655.382.camel@jlt3.sipsolutions.net>
	 <AANLkTikYRSQw-+Tcj4VS1qxi=OaeF9C5hjAMWVu+0M=v@mail.gmail.com>
	 <AANLkTi=o4Mc72NrNoALBdS3YHeY7RMyyAJPsCy=uW3+F@mail.gmail.com>
	 <1286389697.3655.401.camel@jlt3.sipsolutions.net>
	 ,<20101006183340.GI7070@tux>
	 <44EE5C37ADC36343B0625A05DD408C4850DAD2CA31@CHEXMB-01.global.atheros.com>
	 <1286465072.6145.151.camel@aeonflux>  <4CADF6BF.6070305@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 18:42:21 +0200
Message-ID: <1286469741.6145.165.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bala,

> >> Thanks Johannes.  This would be better option to change PID in firmware
> >> as blacklisting 3002 might create problems for 3011 chipsets.
> >> Will try and let you people know.
> > The misbehaving 3002 needs to be blacklisted in btusb.c anyway. However
> > after loading the firmware to 3002 device, it should change its PID to
> > something else.
> >
> > I am still trying to figure out if this is one stage firmware loading or
> > a two stage firmware loading. This is all pretty unclear and nobody has
> > answered this clearly so far.
>
> eeprom based 3011 chips comes up with PID 3000 giving control to DFU 
> driver [ath3k].  ath3k downloads the
> firmware changing PID to 3002.  Now btusb gets control.
> 
> In sflash based devices to reduce windows suspend/resume time we had a 
> small firmware in flash which
> enables the device to get detected as Generic Bluetooth USB device with 
> PID 3002.  So control reaches btusb when device is plugged in, leaving 
> no option for us to load the actual firmware.
> 
> Solution would be to blacklist 3002 in btusb, enable ath3k to get 
> control for both the devices, download the firmware and change PID to 
> 3003 so that control with come to btusb.

so here is the thing that needs to be done.

a) Get a firmware for PID 3000 devices that change the firmware to some
other PID. Since 3003 is already in use as well, using 3004 or later is
better approach.

b) Blacklist PID 3002 in btusb.c.

c) Handle special firmware loading case for PID 3002 sflash devices. If
firmware is loaded changed to 3005 or other.

And as a general note, I prefer that the PID after loading firmware is
different if you don't happen to actually load the same firmware.

So please sort out your USB PID assignment for Bluetooth in general.
This seems to be a mess that is not thought through properly.

Regards

Marcel



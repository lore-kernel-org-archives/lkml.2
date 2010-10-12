Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab0JLNi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:38:57 -0400
Received: from mail.atheros.com ([12.19.149.2]:63879 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220Ab0JLNiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:38:55 -0400
From: Kevin Hayes <kevin@Atheros.com>
To: Marcel Holtmann <holtmann@linux.intel.com>,
        Shanmugamkamatchi Balashanmugam 
	<Shanmugamkamatchi.Balashanmugam@Atheros.com>
CC: Shanmugamkamatchi Balashanmugam 
	<Shanmugamkamatchi.Balashanmugam@Atheros.com>,
        Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@Atheros.com>,
        Sree Durbha <Sree.Durbha@Atheros.com>
Date: Tue, 12 Oct 2010 06:38:51 -0700
Subject: RE: RFC: btusb firmware load help
Thread-Topic: RFC: btusb firmware load help
Thread-Index: ActmPqg4nKOGNfBPTLCwVHpgLoXrQAD0tRWg
Message-ID: <B7132A25476D334D9130FE7532F2A56314B58158FF@SC1EXMB-MBCL.global.atheros.com>
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
 <1286469741.6145.165.camel@aeonflux>
In-Reply-To: <1286469741.6145.165.camel@aeonflux>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9CDd6Pl021232

Hi Marcel, Bala,


> -----Original Message-----
> From: linux-bluetooth-owner@vger.kernel.org [mailto:linux-bluetooth-
> owner@vger.kernel.org] On Behalf Of Marcel Holtmann
> Sent: Thursday, October 07, 2010 9:42 AM
> To: Shanmugamkamatchi Balashanmugam
> Cc: Shanmugamkamatchi Balashanmugam; Luis Rodriguez; Johannes Berg;
> linux-bluetooth; linux-kernel@vger.kernel.org; linux-
> wireless@vger.kernel.org; Deepak Dhamdhere; Sree Durbha
> Subject: Re: RFC: btusb firmware load help
> 
> Hi Bala,
> 
> > >> Thanks Johannes.  This would be better option to change PID in
> firmware
> > >> as blacklisting 3002 might create problems for 3011 chipsets.
> > >> Will try and let you people know.
> > > The misbehaving 3002 needs to be blacklisted in btusb.c anyway.
> However
> > > after loading the firmware to 3002 device, it should change its PID
> to
> > > something else.
> > >
> > > I am still trying to figure out if this is one stage firmware
> loading or
> > > a two stage firmware loading. This is all pretty unclear and nobody
> has
> > > answered this clearly so far.
> >
> > eeprom based 3011 chips comes up with PID 3000 giving control to DFU
> > driver [ath3k].  ath3k downloads the
> > firmware changing PID to 3002.  Now btusb gets control.
> >
> > In sflash based devices to reduce windows suspend/resume time we had
> a
> > small firmware in flash which
> > enables the device to get detected as Generic Bluetooth USB device
> with
> > PID 3002.  So control reaches btusb when device is plugged in,
> leaving
> > no option for us to load the actual firmware.
> >
> > Solution would be to blacklist 3002 in btusb, enable ath3k to get
> > control for both the devices, download the firmware and change PID to
> > 3003 so that control with come to btusb.
> 
> so here is the thing that needs to be done.
> 
> a) Get a firmware for PID 3000 devices that change the firmware to some
> other PID. Since 3003 is already in use as well, using 3004 or later is
> better approach.
> 
> b) Blacklist PID 3002 in btusb.c.
> 
> c) Handle special firmware loading case for PID 3002 sflash devices. If
> firmware is loaded changed to 3005 or other.
> 
> And as a general note, I prefer that the PID after loading firmware is
> different if you don't happen to actually load the same firmware.
> 
> So please sort out your USB PID assignment for Bluetooth in general.
> This seems to be a mess that is not thought through properly.
> 
> Regards
> 
> Marcel
> 

Yes, it is a good idea to let the downloadable firmware set a new PID, along with the blacklist on the 3002 PID for the first go round.  I emphasize, it is the downloaded firmware that will be required to do the PID swizzling, not the sflash firmware.  And I agree we should have a map of the PIDs in use and what they are used for, once we get through this immediate fixing phase.

Thanks,

	K++



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

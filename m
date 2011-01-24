Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1AXDhe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 22:37:34 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:58397 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015Ab1AXDhd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 22:37:33 -0500
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Mattias WALLIN <mattias.wallin@stericsson.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Date: Mon, 24 Jan 2011 04:37:08 +0100
Subject: RE: [PATCH] mfd: ab8500-gpadc Add new GPADC driver
Thread-Topic: [PATCH] mfd: ab8500-gpadc Add new GPADC driver
Thread-Index: Acu5Y84XruP6Z4dJRK+VRFXY0+gZkwCEip1Q
Message-ID: <F45880696056844FA6A73F415B568C6953738FAC5D@EXDCVYMBSTM006.EQ1STM.local>
References: <1295519304-27062-1-git-send-email-arun.murthy@stericsson.com>
 <4D382C9F.6000108@stericsson.com>
  <F45880696056844FA6A73F415B568C69537384B9F3@EXDCVYMBSTM006.EQ1STM.local>
 <4D39770C.20208@stericsson.com>
In-Reply-To: <4D39770C.20208@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Henceforth in order to secure the usage of GPADC, and in order to
> > restrict it to only EM and AUDIO sub-module, the gpadc device struct
> > was added to ab8500 struct. Also that the exported function
> > ab8500_gpadc_convert has an argument struct ab8500_gpadc, which can
> > be obtained be dereferencing the struct ab8500. This is possible only
> > with the ab8500 and its clients, thereby securing the usage to
> > battery driver and audio acc detect.
> Yes and I would like to remove this restriction and have a simpler more
> open api.
> First I don't like that users needs to do a lot of pointer
> dereferencing in their call like ab8500_gpadc_convert(dev->parent-
> >ab8500->gpadc, USB_CHARGER) (an example).

It's very much simple. All clients of ab500 will have a pointer to the
struct ab8500. Pointer to GPADC struct is an element in ab8500.
Hence it is something like  ab8500_gpadc_convert(di->ab8500->gpadc,
BAT_CTRL); I don't find anything complicated in this.

> I prefer a get function that returns a handle that should be used as
> first argument in the convert calls.
> It also makes sense if this driver will be extended to use more
> channels.

This is not possible. This is the limitation/the feature of the hardware.
It's not the software that limits the channel.
In the GPADC hardware, there are dedicated channel and also dedicatedly
allocated to the clients which are nothing but the battery parameters(
voltage, current, battery resistance, ac voltage, usb voltage) and the
audio acc. Apart from these no other peripheral or channel can use this.
It's not the restriction because of this implementation, but are the features
supported by the GPPDC hardware. Even if implemented considering your
comments, none other apart from the above mentioned can use(No extra
channels can be added and the existing channel are already hardwired hence
can't be modified/changed)  

> Second this driver will be used by for example accessories which likely
> will be called by 3 party drivers
This is not at all the 3rd part driver. Acc is part of audio block which
is a module in AB8500. Hence Audio will be a client of ab8500 mfd.

> and to make their life easier I don't want to force them to this
> ab8500-core dependency.
Its not that software is forcing or limiting the use to only ab8500
clients, but it's more the hardware feature.
Please refer the ab8500 datasheet for further details.

> I agree however that the users must be in above list and most of them
> are ab8500 devices already.
In that case there comes no instance where others apart from the ab8500
clients using this drivers.

Thanks and Regards,
Arun R Murthy
-------------

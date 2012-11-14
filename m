Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423272Ab2KNTWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:22:16 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:43617 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161229Ab2KNTWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:22:14 -0500
X-RZG-AUTH: :OGUIeWCgeu1cUM8LNN+8Lq3lm9FM4/TJp2rwF68GSdnwlVUEFHkgOgH7Mw==
X-RZG-CLASS-ID: mo00
From: "till@harbaum.org" <till@harbaum.org>
Reply-To: "till@harbaum.org" <till@harbaum.org>
To: Alexander Holler <holler@ahsoftware.de>, Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: Add possibility for user-defined
	(i2c-)devices for bus-drivers.
X-Mailer: Modest 3.2
References: <1352829968-4908-1-git-send-email-holler@ahsoftware.de>
	 <20121113195533.6db71716@endymion.delvare> <50A2AC28.7050304@ahsoftware.de>
	 <20121113220835.111a178a@endymion.delvare> <50A2BAA2.6090009@ahsoftware.de>
	 <20121113224246.768bf734@endymion.delvare> <50A2DA0C.3090507@ahsoftware.de>
	 <20121114104050.79df8cd9@endymion.delvare>
	  <50A390CC.9000208@ahsoftware.de>
In-Reply-To: <50A390CC.9000208@ahsoftware.de>
Content-Type: text/plain; charset=utf-8
Content-ID: <1352920953.19432.1.camel@Nokia-N900>
Date: Wed, 14 Nov 2012 20:22:34 +0100
Message-Id: <1352920954.19432.2.camel@Nokia-N900>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i have seen i2c chips going nuts because some probing actually affected the chips state. So i fully agree with Jean here.

I2C just isn't meant to be used for hot plugging. And so isn't the i2c-tiny-usb. It's more a hacking and testing device and is e.g. very convenient to test i2c client drivers or to test some new i2c hardware. But i have never had a need for this before user land was available. And once it is you can really do any magic you want using e.g. udev and sysfs.

Also if you really need some chip to be available at boot time, then usb isn't for you. Usb can take pretty long to enumerate etc and you can never be sure when exactly a device shows up on the usb bus. You'd thus additionally need some means of blocking the entire boot process if you want to enforce that. E.g. the kernel can wait for boot disks to appear for exactly this reason. But it wouldn't make much sense to delay the boot for less cruicial things. Boot time is a critical thing and only the most important things are supposed to have a negative impact on that.

If you wan't an i2c device to be available at boot time, then you might consider to connect it to some non-volatile i2c bus. I am pretty sure the raspberry pi has one.

Regards,
  Till

-- 
Dr. Till Harbaum <till@harbaum.org>
----- Ursprüngliche Mitteilung -----
> Hello,
> 
> Am 14.11.2012 10:40, schrieb Jean Delvare:
> 
> > > It isn't possible to do such, because the only ID available for
> > > i2c-busses is given them at runtime. So people have to live with that
> > > imho artificially problem, if they use my patch. I don't have any
> > > other solution until the numbering is predictable. But I assume you
> > > already know all that, otherwise you wouldn't have mentioned it.
> > 
> > The problem is inherent to external, hot-plug I2C adapters. You can't
> > predict their bus number, and actually you can't even always predict
> > their name. In the case of usb-tiny-i2c, you may be able to look-up the
> > bus number from the adapter name, but you won't be able to always
> > differentiate between two adapters, if they are connected to paired USB
> > ports.
> > 
> > This is a design issue with the i2c-tiny-usb hardware in the first
> > place. If it is needed to differentiate between adapters, their would
> > need to be a locally unique ID in every adapter, which the kernel can
> > query. I suppose this was not deemed necessary at design time, as most
> > people will only connect one such adapter at a time to their system.
> 
> Actually many of the available USB devices (e.g. many usb-serials) don't 
> offer a unique ID by themself. That isn't just a problem of the 
> i2c-tiny-usb. But in contrast to other solutions, it shouldn't be very 
> hard to give those adapters a unique ID. As the whole SUB solution is 
> just software (and open source), one likely just would to write some 
> small piece of additional code.
> 
> > I have already experienced this and yes, it is a pain. But I would
> > think that a system designed without a RTC in the first place has
> > another way of getting its time correct at boot time, for example NTP.
> > As I understand it the RTC chip is only there to set the system time at
> > boot, right, the actual timekeeping during run-time is still done by
> > the CPU?
> 
> Whatever those people which want to us it decide. If I didn't want to 
> help other people by offering them some small documentation about how to 
> build such theirself, I wouldn't have taken the usual and almost 
> unavoidable pain trying feed some silly patches into the kernel. ;)
> 
> Anyway, maybe Till Harbaum will like that solution and won't get blocked 
> by you. And maybe in some years we will see how many other bus-drivers 
> have adopted the same solution. In fact the in-driver solution was my 
> first one and I've thought others might be interested too, so I've moved 
> the few lines from the driver itself into the i2c-core before I sent the 
> patches. Unfortunately a waste of time.
> 
> Regards,
> 
> Alexander
> 


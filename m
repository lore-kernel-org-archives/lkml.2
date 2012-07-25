Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab2GYI7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 04:59:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38120 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809Ab2GYI7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 04:59:00 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: RE: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
Thread-Topic: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
Thread-Index: AQHMwTM0PN2tPvWpKkmNhYqSj7+eyZYQT2HwgAGmA4CAAC3LgIAABpWAgAEaKKCAAHgJgIEnQadQ
Date: Wed, 25 Jul 2012 08:57:22 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13EA0319F@DBDE01.ent.ti.com>
References: <1324617892-14576-1-git-send-email-anilkumar@ti.com>
 <201201181711.15751.arnd@arndb.de>
 <331ABD5ECB02734CA317220B2BBEABC13177DFF6@DBDE01.ent.ti.com>
 <201201191710.45862.arnd@arndb.de>
In-Reply-To: <201201191710.45862.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6P8xBKN014131

Hi Arnd,

On Thu, Jan 19, 2012 at 22:40:45, Arnd Bergmann wrote:
> On Thursday 19 January 2012, AnilKumar, Chimata wrote:
> > Android userspace running on TI AM335x EVM is using the interface
> > provided by lis3lv02d. They were asking some more interfaces from
> > lis3lvo2d driver.
> > 
> > There are multiple ways we can interface accelerometer to Android layers,
> > which is implemented on hardware abstraction layer (HAL) in Andriod.
> > 
> > 1) Interrupt mode
> > 2) Polling mode
> >    2a) Kernel polling
> >    2b) Timer polling
> > 
> > Based on the interfaces provided by the lis3lv02d as well as
> > lis331dlh (H/W not supporting the interrupts) they were implementing
> > the kernel polling mechanism.
> > 
> > So implementation on HAL is like this if accelerometer interface is
> > opened then kernel will start polling this driver periodically and
> > pass events to input subsystem. (It's a little bit over head)
> > 
> > Generally the device should be open but kernel should only poll
> > when an app that uses accelerometer is started.
> > 
> > The biggest requirement for them (Andriod people) is to allow user to
> > enable / disable accelerometer from user space and to configure
> > the accelerometer polling frequency.
> > 
> > Today there is no option in lis3lvo2d driver to provide this kind
> > of functionalities
> 
> Hi AnilKumar,
> 
> This all sounds like the interface is not completely thought through.
> 
> I did not realize that the driver actually uses the input subsystem
> in addition to its own interfaces. This is definitely good, and it
> means that we can move the files from drivers/misc to drivers/input/misc
> or drivers/input/accelerometer, making it Dmitry's problem instead of
> mine ;-)
> 
> Having custom user interfaces inside an input driver however is very
> bad. I'm sure that other accelerometers will have the same requirements
> regarding polling frequency and enable/disable in android as well as
> anytwhere else and it should absolutely not be handled by a user space
> HAL but instead inside of the kernel, using a common method for all
> available drivers.
> 
> Based on that, I also doubt we should apply your patch to add the
> "range" attribute (adding support for lis33ldlh is fine though).
>
> Instead I would ask you to first fix what's there by moving the
> user space interfaces into the input core from the driver
> and documenting them.
>
> I don't know what the preferred way for doing things is there
> (joystick ioctl, sysfs attribute, ...) but Dmitry should
> be able to provide advice there. Then add interfaces for the
> additional stuff you need (range, disable, ...) in the same
> place and implement them as callbacks in the driver itself.

I will remove the range attribute and I will submit v2. The rest of
the patch deals with adding support for lis33ldlh and should be fairly
non-controversial. We can revisit the range attribute addition at a
later time.

Regards
AnilKumar
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

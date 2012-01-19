Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab2ASFb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 00:31:28 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56012 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab2ASFbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 00:31:17 -0500
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Arnd Bergmann <arnd@arndb.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
CC: "greg@kroah.com" <greg@kroah.com>,
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
Thread-Index: AQHMwTM0PN2tPvWpKkmNhYqSj7+eyZYQT2HwgAGmA4CAAC3LgIAABpWAgAEaKKA=
Date: Thu, 19 Jan 2012 05:30:52 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13177DFF6@DBDE01.ent.ti.com>
References: <1324617892-14576-1-git-send-email-anilkumar@ti.com>
 <201201181403.47806.arnd@arndb.de>
 <b659db7b-2ef1-49b8-9752-a0601226cc6e@email.android.com>
 <201201181711.15751.arnd@arndb.de>
In-Reply-To: <201201181711.15751.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.132.232]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0J5Vl5D028701

Hi Arnd,

On Wed, Jan 18, 2012 at 22:41:15, Arnd Bergmann wrote:
> On Wednesday 18 January 2012, Jonathan Cameron wrote:
> > Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > >Any opinions where they should live? input, iio or a new subsystem?
> > >
> > Personal thought is that straight 3d devices very directed at input
> > should go there. Iio has a few wrinkles left for the in kernel
> > interfaces needed for a bridge to input. For starters the pull 
> > and push data interfaces have not merged yet (in staging) and we
> > have not started on in kernel acess to non data events yet(thresholds).
> > Still happy to take them when we can support usecases fully. 
> 
> Ok, thanks for the information, sounds all reasonable. I think we
> can definitely say no to new accelerometer drivers in drivers/misc
> then and refer them to iio and input.
> 
> In case of lis33ldlh, I would like to see it move out at some point
> once the necessary parts of iio have graduated out of staging.
> Hopefully it won't be a large amount of work to convert it to
> a different internal API.
> 
> AnilKumar, what are the existing users of the driver? Is it still
> possible to convert them to use iio without causing problems for
> people that rely on this driver, or do we have to keep supporting the
> current interface?

Android userspace running on TI AM335x EVM is using the interface
provided by lis3lv02d. They were asking some more interfaces from
lis3lvo2d driver.

There are multiple ways we can interface accelerometer to Android layers,
which is implemented on hardware abstraction layer (HAL) in Andriod.

1) Interrupt mode
2) Polling mode
   2a) Kernel polling
   2b) Timer polling

Based on the interfaces provided by the lis3lv02d as well as
lis331dlh (H/W not supporting the interrupts) they were implementing
the kernel polling mechanism.

So implementation on HAL is like this if accelerometer interface is
opened then kernel will start polling this driver periodically and
pass events to input subsystem. (It's a little bit over head)

Generally the device should be open but kernel should only poll
when an app that uses accelerometer is started.

The biggest requirement for them (Andriod people) is to allow user to
enable / disable accelerometer from user space and to configure
the accelerometer polling frequency.

Today there is no option in lis3lvo2d driver to provide this kind
of functionalities

> 
> 	Arnd
> 

Regards
AnilKumar
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab2HTVm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 17:42:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308Ab2HTVmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 17:42:54 -0400
Message-ID: <5032AF55.5030208@redhat.com>
Date: Mon, 20 Aug 2012 18:42:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Steven Toth <stoth@kernellabs.com>
Subject: Re: linux-next: Tree for Aug 20 (media: saa7164)
References: <20120820192336.1be51b225ce2883bdcad5b15@canb.auug.org.au> <503260D9.4030208@xenotime.net>
In-Reply-To: <503260D9.4030208@xenotime.net>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 20-08-2012 13:07, Randy Dunlap escreveu:
> (part of/due to kconfig menu restructuring?)

Yes.

Probably, there was an implicit dependency with the old Kconfig arrangement.

Now that we're storing both analog and digital TV drivers at the same place,
those dependencies need to be explicit.

Thanks!
Mauro

> on i386:
> 
> drivers/built-in.o: In function `fops_open':
> saa7164-encoder.c:(.text+0x68ed6f): undefined reference to `video_devdata'
...

-

[media] saa7164: Add dependency for V4L2 core

From: Mauro Carvalho Chehab <mchehab@redhat.com>

As Reported by Randy:

> drivers/built-in.o: In function `fops_open':
> saa7164-encoder.c:(.text+0x68ed6f): undefined reference to `video_devdata'
> drivers/built-in.o: In function `fill_queryctrl.clone.4':
> saa7164-encoder.c:(.text+0x68f657): undefined reference to `v4l2_ctrl_query_fill'
> saa7164-encoder.c:(.text+0x68f6a9): undefined reference to `v4l2_ctrl_query_fill'
> saa7164-encoder.c:(.text+0x68f6e0): undefined reference to `v4l2_ctrl_query_fill'
> saa7164-encoder.c:(.text+0x68f71a): undefined reference to `v4l2_ctrl_query_fill'
> saa7164-encoder.c:(.text+0x68f73a): undefined reference to `v4l2_ctrl_query_fill'
> drivers/built-in.o:saa7164-encoder.c:(.text+0x68f757): more undefined references to `v4l2_ctrl_query_fill' follow
> drivers/built-in.o: In function `saa7164_encoder_register':
> (.text+0x68fff7): undefined reference to `video_device_alloc'
> drivers/built-in.o: In function `saa7164_encoder_register':
> (.text+0x690073): undefined reference to `video_device_release'
> drivers/built-in.o: In function `saa7164_encoder_register':
> (.text+0x6900a1): undefined reference to `__video_register_device'
> drivers/built-in.o: In function `saa7164_encoder_unregister':
> (.text+0x690243): undefined reference to `video_unregister_device'
> drivers/built-in.o: In function `saa7164_encoder_unregister':
> (.text+0x690269): undefined reference to `video_device_release'
> drivers/built-in.o: In function `fops_open':
> saa7164-vbi.c:(.text+0x69125f): undefined reference to `video_devdata'
> drivers/built-in.o: In function `fill_queryctrl.clone.4':
> saa7164-vbi.c:(.text+0x6919b4): undefined reference to `v4l2_ctrl_query_fill'
> saa7164-vbi.c:(.text+0x6919ee): undefined reference to `v4l2_ctrl_query_fill'
> saa7164-vbi.c:(.text+0x691a23): undefined reference to `v4l2_ctrl_query_fill'
> saa7164-vbi.c:(.text+0x691a47): undefined reference to `v4l2_ctrl_query_fill'
> saa7164-vbi.c:(.text+0x691a6a): undefined reference to `v4l2_ctrl_query_fill'
> drivers/built-in.o:saa7164-vbi.c:(.text+0x691a87): more undefined references to `v4l2_ctrl_query_fill' follow
> drivers/built-in.o: In function `saa7164_vbi_register':
> (.text+0x69220e): undefined reference to `video_device_alloc'
> drivers/built-in.o: In function `saa7164_vbi_register':
> (.text+0x69228a): undefined reference to `video_device_release'
> drivers/built-in.o: In function `saa7164_vbi_register':
> (.text+0x6922bb): undefined reference to `__video_register_device'
> drivers/built-in.o: In function `saa7164_vbi_unregister':
> (.text+0x6923de): undefined reference to `video_unregister_device'
> drivers/built-in.o: In function `saa7164_vbi_unregister':
> (.text+0x6923f9): undefined reference to `video_device_release'
> drivers/built-in.o:(.rodata+0xb1054): undefined reference to `video_ioctl2'
> drivers/built-in.o:(.rodata+0xb17d4): undefined reference to `video_ioctl2'

That's due to the lack of an explicit Kconfig dependency for the V4L2 core.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/pci/saa7164/Kconfig b/drivers/media/pci/saa7164/Kconfig
index 3532637..d0b92fe 100644
--- a/drivers/media/pci/saa7164/Kconfig
+++ b/drivers/media/pci/saa7164/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_SAA7164
 	tristate "NXP SAA7164 support"
-	depends on DVB_CORE && PCI && I2C
+	depends on DVB_CORE && VIDEO_DEV && PCI && I2C
 	select I2C_ALGOBIT
 	select FW_LOADER
 	select VIDEO_TUNER




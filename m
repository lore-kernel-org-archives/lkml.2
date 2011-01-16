Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1APNJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 08:09:19 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:38663 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab1APNJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:09:16 -0500
Date: Sun, 16 Jan 2011 14:09:13 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: radio-aimslab.c needs #include <linux/delay.h>
Message-ID: <alpine.DEB.2.00.1101161407480.24288@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e3c92215198cb6aa00ad38db2780faa6b72e0a3f ("[media] radio-aimslab.c: Fix
gcc 4.5+ bug") removed the include, but introduced new callers of msleep():

| drivers/media/radio/radio-aimslab.c: In function ¡rt_decvol¢:
| drivers/media/radio/radio-aimslab.c:76: error: implicit declaration of function ¡msleep¢

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/radio/radio-aimslab.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/radio/radio-aimslab.c b/drivers/media/radio/radio-aimslab.c
index 6cc5d13..4ce10db 100644
--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>	/* Modules 			*/
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
+#include <linux/delay.h>	/* msleep			*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/version.h>	/* for KERNEL_VERSION MACRO	*/
 #include <linux/io.h>		/* outb, outb_p			*/
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

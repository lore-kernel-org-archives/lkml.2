Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab1B1Qos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:44:48 -0500
Received: from kroah.org ([198.145.64.141]:48135 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576Ab1B1Qhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:10 2011
Message-Id: <20110228162410.053397393@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:23:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        dann frazier <dannf@debian.org>
Subject: [43/68] [media] radio-aimslab.c needs #include <linux/delay.h>
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 2400982a2e8a8e4e95f0a0e1517bbe63cc88038f upstream.

Commit e3c92215198cb6aa00ad38db2780faa6b72e0a3f ("[media] radio-aimslab.c: Fix
gcc 4.5+ bug") removed the include, but introduced new callers of msleep():

| drivers/media/radio/radio-aimslab.c: In function ‘rt_decvol’:
| drivers/media/radio/radio-aimslab.c:76: error: implicit declaration of function ‘msleep’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: dann frazier <dannf@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/radio/radio-aimslab.c |    1 +
 1 file changed, 1 insertion(+)

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



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1DYUYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:24:19 -0400
Received: from 1wt.eu ([62.212.114.60]:33971 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878Ab1DYUYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:16 -0400
Message-Id: <20110425200235.204433248@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        dann frazier <dannf@debian.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 051/173] [media] radio-aimslab.c needs #include <linux/delay.h>
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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

Index: longterm-2.6.27/drivers/media/radio/radio-aimslab.c
===================================================================
--- longterm-2.6.27.orig/drivers/media/radio/radio-aimslab.c	2011-04-25 11:58:08.000000000 +0200
+++ longterm-2.6.27/drivers/media/radio/radio-aimslab.c	2011-04-25 14:19:13.054281433 +0200
@@ -33,6 +33,7 @@
 #include <linux/ioport.h>	/* request_region		*/
 #include <asm/io.h>		/* outb, outb_p			*/
 #include <asm/uaccess.h>	/* copy to/from user		*/
+#include <linux/delay.h>	/* msleep			*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>



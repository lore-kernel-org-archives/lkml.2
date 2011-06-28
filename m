Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab1F1Qff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:35:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253Ab1F1QcN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:32:13 -0400
Date: Mon, 27 Jun 2011 23:17:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 10/13] [media] gspca: don't include linux/version.h
Message-ID: <20110627231734.6b68b99c@pedra>
In-Reply-To: <cover.1309226359.git.mchehab@redhat.com>
References: <cover.1309226359.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of handling a per-driver driver version, use the
per-subsystem one.

As reviewed by Jean-Francois Moine <moinejf@free.fr>:
	- the 'info' may be simplified:

Reviewed-by: Jean-Francois Moine <moinejf@free.fr>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 08ce994..d0b79a9 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -24,7 +24,6 @@
 #define MODULE_NAME "gspca"
 
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
 #include <linux/sched.h>
@@ -51,11 +50,12 @@
 #error "DEF_NURBS too big"
 #endif
 
+#define DRIVER_VERSION_NUMBER	"2.13.0"
+
 MODULE_AUTHOR("Jean-François Moine <http://moinejf.free.fr>");
 MODULE_DESCRIPTION("GSPCA USB Camera Driver");
 MODULE_LICENSE("GPL");
-
-#define DRIVER_VERSION_NUMBER	KERNEL_VERSION(2, 13, 0)
+MODULE_VERSION(DRIVER_VERSION_NUMBER);
 
 #ifdef GSPCA_DEBUG
 int gspca_debug = D_ERR | D_PROBE;
@@ -1291,7 +1291,6 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	}
 	usb_make_path(gspca_dev->dev, (char *) cap->bus_info,
 			sizeof(cap->bus_info));
-	cap->version = DRIVER_VERSION_NUMBER;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
 			  | V4L2_CAP_STREAMING
 			  | V4L2_CAP_READWRITE;
@@ -2478,10 +2477,7 @@ EXPORT_SYMBOL(gspca_auto_gain_n_exposure);
 /* -- module insert / remove -- */
 static int __init gspca_init(void)
 {
-	info("v%d.%d.%d registered",
-		(DRIVER_VERSION_NUMBER >> 16) & 0xff,
-		(DRIVER_VERSION_NUMBER >> 8) & 0xff,
-		DRIVER_VERSION_NUMBER & 0xff);
+	info("v" DRIVER_VERSION_NUMBER " registered");
 	return 0;
 }
 static void __exit gspca_exit(void)
-- 
1.7.1



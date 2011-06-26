Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1FZQHg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 12:07:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab1FZQHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 12:07:32 -0400
Date: Sun, 26 Jun 2011 13:06:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/14] [media] ivtv,cx18: Use default version control for
 VIDIOC_QUERYCAP
Message-ID: <20110626130611.219bb01d@pedra>
In-Reply-To: <cover.1309103285.git.mchehab@redhat.com>
References: <cover.1309103285.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After discussing with Andy Walls on irc, we've agreeded that this
is the best thing to do. No regressions will be introduced, as 3.x.y
is greater then the current versions for cx18 and ivtv.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx18/cx18-driver.h b/drivers/media/video/cx18/cx18-driver.h
index 0864272..1834207 100644
--- a/drivers/media/video/cx18/cx18-driver.h
+++ b/drivers/media/video/cx18/cx18-driver.h
@@ -25,7 +25,6 @@
 #ifndef CX18_DRIVER_H
 #define CX18_DRIVER_H
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
diff --git a/drivers/media/video/cx18/cx18-ioctl.c b/drivers/media/video/cx18/cx18-ioctl.c
index 1933d4d..6ec61c9 100644
--- a/drivers/media/video/cx18/cx18-ioctl.c
+++ b/drivers/media/video/cx18/cx18-ioctl.c
@@ -469,7 +469,6 @@ static int cx18_querycap(struct file *file, void *fh,
 	strlcpy(vcap->card, cx->card_name, sizeof(vcap->card));
 	snprintf(vcap->bus_info, sizeof(vcap->bus_info),
 		 "PCI:%s", pci_name(cx->pci_dev));
-	vcap->version = CX18_DRIVER_VERSION; 	    /* version */
 	vcap->capabilities = cx->v4l2_cap; 	    /* capabilities */
 	return 0;
 }
diff --git a/drivers/media/video/cx18/cx18-version.h b/drivers/media/video/cx18/cx18-version.h
index cd189b6..fed48b6 100644
--- a/drivers/media/video/cx18/cx18-version.h
+++ b/drivers/media/video/cx18/cx18-version.h
@@ -23,12 +23,6 @@
 #define CX18_VERSION_H
 
 #define CX18_DRIVER_NAME "cx18"
-#define CX18_DRIVER_VERSION_MAJOR 1
-#define CX18_DRIVER_VERSION_MINOR 5
-#define CX18_DRIVER_VERSION_PATCHLEVEL 0
-
-#define CX18_VERSION __stringify(CX18_DRIVER_VERSION_MAJOR) "." __stringify(CX18_DRIVER_VERSION_MINOR) "." __stringify(CX18_DRIVER_VERSION_PATCHLEVEL)
-#define CX18_DRIVER_VERSION KERNEL_VERSION(CX18_DRIVER_VERSION_MAJOR, \
-	CX18_DRIVER_VERSION_MINOR, CX18_DRIVER_VERSION_PATCHLEVEL)
+#define CX18_VERSION "1.5.1"
 
 #endif
diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
index 84bdf0f..8f9cc17 100644
--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -36,7 +36,6 @@
  *                using information provided by Jiun-Kuei Jung @ AVerMedia.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/delay.h>
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index f9e347d..ac210ac 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -757,7 +757,6 @@ static int ivtv_querycap(struct file *file, void *fh, struct v4l2_capability *vc
 	strlcpy(vcap->driver, IVTV_DRIVER_NAME, sizeof(vcap->driver));
 	strlcpy(vcap->card, itv->card_name, sizeof(vcap->card));
 	snprintf(vcap->bus_info, sizeof(vcap->bus_info), "PCI:%s", pci_name(itv->pdev));
-	vcap->version = IVTV_DRIVER_VERSION; 	    /* version */
 	vcap->capabilities = itv->v4l2_cap; 	    /* capabilities */
 	return 0;
 }
diff --git a/drivers/media/video/ivtv/ivtv-version.h b/drivers/media/video/ivtv/ivtv-version.h
index b67a404..a20f346 100644
--- a/drivers/media/video/ivtv/ivtv-version.h
+++ b/drivers/media/video/ivtv/ivtv-version.h
@@ -21,11 +21,6 @@
 #define IVTV_VERSION_H
 
 #define IVTV_DRIVER_NAME "ivtv"
-#define IVTV_DRIVER_VERSION_MAJOR 1
-#define IVTV_DRIVER_VERSION_MINOR 4
-#define IVTV_DRIVER_VERSION_PATCHLEVEL 2
-
-#define IVTV_VERSION __stringify(IVTV_DRIVER_VERSION_MAJOR) "." __stringify(IVTV_DRIVER_VERSION_MINOR) "." __stringify(IVTV_DRIVER_VERSION_PATCHLEVEL)
-#define IVTV_DRIVER_VERSION KERNEL_VERSION(IVTV_DRIVER_VERSION_MAJOR,IVTV_DRIVER_VERSION_MINOR,IVTV_DRIVER_VERSION_PATCHLEVEL)
+#define IVTV_VERSION "1.4.3"
 
 #endif
-- 
1.7.1



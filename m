Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1FBEv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 00:51:59 -0400
Received: from adelie.canonical.com ([91.189.90.139]:48414 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1FBEv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 00:51:58 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gregkh@suse.de
Subject: [PATCH] usb: gadget: include <linux/prefetch.h> to fix compiling error
Date: Thu,  2 Jun 2011 12:51:29 +0800
Message-Id: <1306990289-7431-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/usb/gadget/at91_udc.c: In function 'write_fifo':
drivers/usb/gadget/at91_udc.c:421:2: error: implicit declaration of function 'prefetch'
make[3]: *** [drivers/usb/gadget/at91_udc.o] Error 1
make[2]: *** [drivers/usb/gadget] Error 2
make[2]: *** Waiting for unfinished jobs....

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/usb/gadget/amd5536udc.c  |    1 +
 drivers/usb/gadget/at91_udc.c    |    1 +
 drivers/usb/gadget/net2280.c     |    1 +
 drivers/usb/gadget/s3c-hsudc.c   |    1 +
 drivers/usb/gadget/s3c2410_udc.c |    1 +
 5 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 6e42aab..95e8138 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -60,6 +60,7 @@
 #include <linux/device.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/prefetch.h>
 
 #include <asm/byteorder.h>
 #include <asm/system.h>
diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 41dc093..f4690ff 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -38,6 +38,7 @@
 #include <linux/clk.h>
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
+#include <linux/prefetch.h>
 
 #include <asm/byteorder.h>
 #include <mach/hardware.h>
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index 24696f7..476d88e 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -63,6 +63,7 @@
 #include <linux/device.h>
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
+#include <linux/prefetch.h>
 
 #include <asm/byteorder.h>
 #include <asm/io.h>
diff --git a/drivers/usb/gadget/s3c-hsudc.c b/drivers/usb/gadget/s3c-hsudc.c
index cfe3cf5..9a1b966 100644
--- a/drivers/usb/gadget/s3c-hsudc.c
+++ b/drivers/usb/gadget/s3c-hsudc.c
@@ -26,6 +26,7 @@
 #include <linux/clk.h>
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
+#include <linux/prefetch.h>
 
 #include <mach/regs-s3c2443-clock.h>
 #include <plat/udc.h>
diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index 6d8b040..100f263 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -36,6 +36,7 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/gpio.h>
+#include <linux/prefetch.h>
 
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
-- 
1.7.5


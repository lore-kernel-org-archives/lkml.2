Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab1GGLxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 07:53:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52923 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab1GGLxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 07:53:10 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 8/8] Staging: comedi: fix brace and printk coding style issue in serial2002.c
Date: Thu,  7 Jul 2011 17:35:27 +0530
Message-Id: <1310040327-22509-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 1/4]Staging: comedi: fix brace coding style and printk issues in serial2002.c>
References: <[PATCH 1/4]Staging: comedi: fix brace coding style and printk issues in serial2002.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the serial2002.c file that fixes up a brace and printk  warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/serial2002.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index ebfce33..8041d8f 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -38,7 +38,7 @@ Status: in development
 #include <linux/sched.h>
 #include <linux/slab.h>
 
-#include <asm/termios.h>
+#include <linux/termios.h>
 #include <asm/ioctls.h>
 #include <linux/serial.h>
 #include <linux/poll.h>
@@ -192,9 +192,8 @@ static int tty_read(struct file *f, int timeout)
 				elapsed =
 				    (1000000 * (now.tv_sec - start.tv_sec) +
 				     now.tv_usec - start.tv_usec);
-				if (elapsed > timeout) {
+				if (elapsed > timeout)
 					break;
-				}
 				set_current_state(TASK_INTERRUPTIBLE);
 				schedule_timeout(((timeout -
 						   elapsed) * HZ) / 10000);
@@ -204,9 +203,8 @@ static int tty_read(struct file *f, int timeout)
 				unsigned char ch;
 
 				f->f_pos = 0;
-				if (f->f_op->read(f, &ch, 1, &f->f_pos) == 1) {
+				if (f->f_op->read(f, &ch, 1, &f->f_pos) == 1)
 					result = ch;
-				}
 			}
 		} else {
 			/* Device does not support poll, busy wait */
@@ -215,9 +213,8 @@ static int tty_read(struct file *f, int timeout)
 				unsigned char ch;
 
 				retries++;
-				if (retries >= timeout) {
+				if (retries >= timeout)
 					break;
-				}
 
 				f->f_pos = 0;
 				if (f->f_op->read(f, &ch, 1, &f->f_pos) == 1) {
@@ -329,7 +326,7 @@ static struct serial_data serial_read(struct file *f, int timeout)
 
 		length++;
 		if (data < 0) {
-			printk("serial2002 error\n");
+			printk(KERN_ERR "serial2002 error\n");
 			break;
 		} else if (data & 0x80) {
 			result.value = (result.value << 7) | (data & 0x7f);
@@ -402,7 +399,7 @@ static int serial_2002_open(struct comedi_device *dev)
 	devpriv->tty = filp_open(port, O_RDWR, 0);
 	if (IS_ERR(devpriv->tty)) {
 		result = (int)PTR_ERR(devpriv->tty);
-		printk("serial_2002: file open error = %d\n", result);
+		printk(KERN_ERR "serial_2002: file open error = %d\n", result);
 	} else {
 		struct config_t {
 
-- 
1.6.5.2


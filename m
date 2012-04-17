Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab2DQLBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:01:04 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:46189 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2DQLBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:01:02 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org,
        tim.gardner@canonical.com
Subject: [PATCH 12/18] char: nwflash: remove old led event code
Date: Tue, 17 Apr 2012 18:53:39 +0800
Message-Id: <1334660025-20442-13-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334660025-20442-1-git-send-email-bryan.wu@canonical.com>
References: <1334660025-20442-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/char/nwflash.c |   34 ----------------------------------
 1 file changed, 34 deletions(-)

diff --git a/drivers/char/nwflash.c b/drivers/char/nwflash.c
index d45c334..a0e2f7d 100644
--- a/drivers/char/nwflash.c
+++ b/drivers/char/nwflash.c
@@ -30,7 +30,6 @@
 
 #include <asm/hardware/dec21285.h>
 #include <asm/io.h>
-#include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/uaccess.h>
 
@@ -179,9 +178,6 @@ static ssize_t flash_write(struct file *file, const char __user *buf,
 
 	written = 0;
 
-	leds_event(led_claim);
-	leds_event(led_green_on);
-
 	nBlock = (int) p >> 16;	//block # of 64K bytes
 
 	/*
@@ -258,11 +254,6 @@ static ssize_t flash_write(struct file *file, const char __user *buf,
 			printk(KERN_DEBUG "flash_write: written 0x%X bytes OK.\n", written);
 	}
 
-	/*
-	 * restore reg on exit
-	 */
-	leds_event(led_release);
-
 	mutex_unlock(&nwflash_mutex);
 
 	return written;
@@ -334,11 +325,6 @@ static int erase_block(int nBlock)
 	int temp, temp1;
 
 	/*
-	 * orange LED == erase
-	 */
-	leds_event(led_amber_on);
-
-	/*
 	 * reset footbridge to the correct offset 0 (...0..3)
 	 */
 	*CSR_ROMWRITEREG = 0;
@@ -446,12 +432,6 @@ static int write_block(unsigned long p, const char __user *buf, int count)
 	unsigned long timeout;
 	unsigned long timeout1;
 
-	/*
-	 * red LED == write
-	 */
-	leds_event(led_amber_off);
-	leds_event(led_red_on);
-
 	pWritePtr = (unsigned char *) ((unsigned int) (FLASH_BASE + p));
 
 	/*
@@ -558,17 +538,9 @@ static int write_block(unsigned long p, const char __user *buf, int count)
 					       pWritePtr - FLASH_BASE);
 
 				/*
-				 * no LED == waiting
-				 */
-				leds_event(led_amber_off);
-				/*
 				 * wait couple ms
 				 */
 				msleep(10);
-				/*
-				 * red LED == write
-				 */
-				leds_event(led_red_on);
 
 				goto WriteRetry;
 			} else {
@@ -583,12 +555,6 @@ static int write_block(unsigned long p, const char __user *buf, int count)
 		}
 	}
 
-	/*
-	 * green LED == read/verify
-	 */
-	leds_event(led_amber_off);
-	leds_event(led_green_on);
-
 	msleep(10);
 
 	pWritePtr = (unsigned char *) ((unsigned int) (FLASH_BASE + p));
-- 
1.7.9.5


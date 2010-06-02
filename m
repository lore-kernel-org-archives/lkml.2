Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856Ab0FBWYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:24:23 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:34344 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758807Ab0FBWYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:24:20 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>,
       dann frazier <dannf@hp.com>
Subject: [PATCH 1/3] hpwdt: Introduce SECS_TO_TICKS() macro
Date: Wed,  2 Jun 2010 16:23:39 -0600
Message-Id: <1275517421-10544-1-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a macro to convert from seconds to timer ticks.

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/watchdog/hpwdt.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 809e716..af61fb6 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -49,6 +49,8 @@
 #define ROM_SIZE			0x10000
 #define HPWDT_VERSION			"1.1.1"
 
+#define SECS_TO_TICKS(secs) ((secs) * 1000 / 128)
+
 struct bios32_service_dir {
 	u32 signature;
 	u32 entry_point;
@@ -420,7 +422,7 @@ static int __devinit detect_cru_service(void)
  */
 static void hpwdt_start(void)
 {
-	reload = (soft_margin * 1000) / 128;
+	reload = SECS_TO_TICKS(soft_margin);
 	iowrite16(reload, hpwdt_timer_reg);
 	iowrite16(0x85, hpwdt_timer_con);
 }
@@ -453,7 +455,7 @@ static int hpwdt_change_timer(int new_margin)
 	printk(KERN_DEBUG
 		"hpwdt: New timer passed in is %d seconds.\n",
 		new_margin);
-	reload = (soft_margin * 1000) / 128;
+	reload = SECS_TO_TICKS(soft_margin);
 
 	return 0;
 }
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab0FBWYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:24:33 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:47428 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758862Ab0FBWYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:24:30 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>,
       dann frazier <dannf@hp.com>
Subject: [PATCH 2/3] hpwdt: allow full range of timer values supported by hardware
Date: Wed,  2 Jun 2010 16:23:40 -0600
Message-Id: <1275517421-10544-2-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275517421-10544-1-git-send-email-dannf@hp.com>
References: <1275517421-10544-1-git-send-email-dannf@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hpwdt timer is a 16 bit value with 128ms resolution.
Let applications use this entire range.

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/watchdog/hpwdt.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index af61fb6..e3bf645 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -50,6 +50,8 @@
 #define HPWDT_VERSION			"1.1.1"
 
 #define SECS_TO_TICKS(secs) ((secs) * 1000 / 128)
+#define TICKS_TO_SECS(ticks) ((ticks) * 128 / 1000)
+#define HPWDT_MAX_TIMER	TICKS_TO_SECS(65535)
 
 struct bios32_service_dir {
 	u32 signature;
@@ -443,8 +445,7 @@ static void hpwdt_ping(void)
 
 static int hpwdt_change_timer(int new_margin)
 {
-	/* Arbitrary, can't find the card's limits */
-	if (new_margin < 5 || new_margin > 600) {
+	if (new_margin < 1 || new_margin > HPWDT_MAX_TIMER) {
 		printk(KERN_WARNING
 			"hpwdt: New value passed in is invalid: %d seconds.\n",
 			new_margin);
-- 
1.7.1


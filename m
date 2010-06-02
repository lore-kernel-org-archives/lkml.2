Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab0FBWYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:24:35 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:7341 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758863Ab0FBWYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:24:30 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>,
       dann frazier <dannf@hp.com>
Subject: [PATCH 3/3] hpwdt: implement WDIOC_GETTIMELEFT
Date: Wed,  2 Jun 2010 16:23:41 -0600
Message-Id: <1275517421-10544-3-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275517421-10544-1-git-send-email-dannf@hp.com>
References: <1275517421-10544-1-git-send-email-dannf@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let applications check the amount of time left before the watchdog will fire.

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/watchdog/hpwdt.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index e3bf645..dbe650e 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -443,6 +443,11 @@ static void hpwdt_ping(void)
 	iowrite16(reload, hpwdt_timer_reg);
 }
 
+static int hpwdt_time_left(void)
+{
+	return TICKS_TO_SECS(ioread16(hpwdt_timer_reg));
+}
+
 static int hpwdt_change_timer(int new_margin)
 {
 	if (new_margin < 1 || new_margin > HPWDT_MAX_TIMER) {
@@ -583,6 +588,10 @@ static long hpwdt_ioctl(struct file *file, unsigned int cmd,
 		ret = put_user(0, p);
 		break;
 
+	case WDIOC_GETTIMELEFT:
+		ret = put_user(hpwdt_time_left(), p);
+		break;
+
 	case WDIOC_KEEPALIVE:
 		hpwdt_ping();
 		ret = 0;
-- 
1.7.1


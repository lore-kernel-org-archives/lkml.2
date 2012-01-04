Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab2ADOPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 09:15:37 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46160 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848Ab2ADOPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 09:15:35 -0500
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-watchdog@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH RFC] OMAP : watchdog : fix the WDIOC_GETBOOTSTATUS ioctl if not implemented.
Date: Wed, 4 Jan 2012 19:45:28 +0530
Message-ID: <1325686528-26997-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WDIOC_GETBOOTSTATUS ioctl is imlemented for cpu_is_omap16xx and cpu_is_omap24xx
cpus only. For other cpus it falls through to WDIOC_KEEPALIVE.
This patch prevents the fall through.

Cc :  sricharan <r.sricharan@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
Untested!

 drivers/watchdog/omap_wdt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 2b4acb8..971179d 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -232,6 +232,7 @@ static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
 		if (cpu_is_omap24xx())
 			return put_user(omap_prcm_get_reset_sources(),
 					(int __user *)arg);
+		return 0;
 	case WDIOC_KEEPALIVE:
 		pm_runtime_get_sync(wdev->dev);
 		spin_lock(&wdt_lock);
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab1GVIgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 04:36:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36689 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab1GVIgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 04:36:39 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andrew Chew <achew@nvidia.com>
Cc: linux-rt-users@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, jkastner@redhat.com
Date: Fri, 22 Jul 2011 10:35:56 +0200
Message-Id: <1311323756-18013-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] rtc-tegra: properly initialize spinlock
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using __SPIN_LOCK_UNLOCKED for a dynamically allocated lock is wrong and
breaks with PREEMPT_RT_FULL.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/rtc/rtc-tegra.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index 2fc31aa..75259fe 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -343,7 +343,7 @@ static int __devinit tegra_rtc_probe(struct platform_device *pdev)
 
 	/* set context info. */
 	info->pdev = pdev;
-	info->tegra_rtc_lock = __SPIN_LOCK_UNLOCKED(info->tegra_rtc_lock);
+	spin_lock_init(&info->tegra_rtc_lock);
 
 	platform_set_drvdata(pdev, info);
 
-- 
1.7.5.4


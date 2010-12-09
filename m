Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab0LIUES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:04:18 -0500
Received: from mail.perches.com ([173.55.12.10]:2400 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757049Ab0LIUEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:04:12 -0500
From: Joe Perches <joe@perches.com>
To: Mike Frysinger <vapier.adi@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Cc: Jiri Kosina <trivial@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH 03/15] rtc: Remove duplicate unlikely from IS_ERR
Date: Thu,  9 Dec 2010 12:03:56 -0800
Message-Id: <29ab1782961e5d9b56972818f12eb7a2e5bd4329.1291923889.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
References: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
In-Reply-To: <cover.1291923888.git.joe@perches.com>
References: <cover.1291923888.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IS_ERR already uses unlikely, remove unlikely from the call sites.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/rtc/rtc-bfin.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index b4b6087..4ba3e33 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -383,7 +383,7 @@ static int __devinit bfin_rtc_probe(struct platform_device *pdev)
 	/* Register our RTC with the RTC framework */
 	rtc->rtc_dev = rtc_device_register(pdev->name, dev, &bfin_rtc_ops,
 						THIS_MODULE);
-	if (unlikely(IS_ERR(rtc->rtc_dev))) {
+	if (IS_ERR(rtc->rtc_dev)) {
 		ret = PTR_ERR(rtc->rtc_dev);
 		goto err;
 	}
-- 
1.7.3.3.464.gf80b6


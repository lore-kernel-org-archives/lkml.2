Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112Ab2GLKLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:11:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41489 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758987Ab2GLKJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:09:12 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>,
        =?UTF-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        Marc Reilly <marc@cpdesign.com.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com
Subject: [PATCH 3/7] rtc/mc13xxx: use MODULE_DEVICE_TABLE instead of MODULE_ALIAS
Date: Thu, 12 Jul 2012 11:57:49 +0200
Message-Id: <1342087073-3892-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows automatic driver loading for all supported device types.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: rtc-linux@googlegroups.com
---
 drivers/rtc/rtc-mc13xxx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index 546f685..0ce0602 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -405,8 +405,9 @@ static const struct platform_device_id mc13xxx_rtc_idtable[] = {
 	}, {
 		.name = "mc13892-rtc",
 	},
-	{ }
+	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(platform, mc13xxx_rtc_idtable);
 
 static struct platform_driver mc13xxx_rtc_driver = {
 	.id_table = mc13xxx_rtc_idtable,
@@ -432,4 +433,3 @@ module_exit(mc13xxx_rtc_exit);
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
 MODULE_DESCRIPTION("RTC driver for Freescale MC13XXX PMIC");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:" DRIVER_NAME);
-- 
1.7.10.4


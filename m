Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab2LAUz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 15:55:29 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:54691 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab2LAUz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 15:55:28 -0500
From: Philippe Reynes <tremyfr@yahoo.fr>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: a.zummo@towertech.it, julien.boibessot@free.fr, eric.jarrige@armadeus.org,
        Philippe Reynes <tremyfr@yahoo.fr>
Subject: [PATCH RESEND] ds1374: add support of device tree
Date: Sat,  1 Dec 2012 21:55:18 +0100
Message-Id: <1354395318-30057-1-git-send-email-tremyfr@yahoo.fr>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>
---
 drivers/rtc/rtc-ds1374.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index 9663160..174c532 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -49,6 +49,14 @@ static const struct i2c_device_id ds1374_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ds1374_id);
 
+#ifdef CONFIG_OF
+static const struct of_device_id ds1374_of_match[] __devinitconst = {
+	{ .compatible = "dallas,ds1374" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, ds1374_of_match);
+#endif
+
 struct ds1374 {
 	struct i2c_client *client;
 	struct rtc_device *rtc;
-- 
1.7.4.4


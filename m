Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2KYURn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 15:17:43 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:57785 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab2KYURl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 15:17:41 -0500
From: Philippe Reynes <tremyfr@yahoo.fr>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: s.hauer@pengutronix.de, julien.boibessot@armadeus.com,
        eric.jarrige@armadeus.org, Philippe Reynes <tremyfr@yahoo.fr>
Subject: [PATCH 2/4] ds1374: add support of device tree
Date: Sun, 25 Nov 2012 21:17:03 +0100
Message-Id: <1353874625-14754-3-git-send-email-tremyfr@yahoo.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1353874625-14754-1-git-send-email-tremyfr@yahoo.fr>
References: <1353874625-14754-1-git-send-email-tremyfr@yahoo.fr>
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


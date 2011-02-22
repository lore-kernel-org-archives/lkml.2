Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab1BVI4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:56:54 -0500
Received: from sputnik.urmx.de ([88.198.51.18]:42455 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab1BVI4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:56:53 -0500
From: Dirk Eibach <eibach@gdsys.de>
To: linux-kernel@vger.kernel.org
Cc: Dirk Eibach <eibach@gdsys.de>
Subject: [PATCH] gpio: Fix wrong pointer type in pca953x
Date: Tue, 22 Feb 2011 09:56:50 +0100
Message-Id: <1298365010-22951-1-git-send-email-eibach@gdsys.de>
X-SafeGuard_MailGateway: Version: 5.60.3.10058 SGMG Date: 20110222085653Z
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.4.170; VDF: 7.11.3.174; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pca953x_get_alt_pdata() uses uint16_t* as result type for
of_get_property(), but numeric of values are u32.

Signed-off-by: Dirk Eibach <eibach@gdsys.de>
---
 drivers/gpio/pca953x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index a261972..d79e031 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -448,7 +448,7 @@ pca953x_get_alt_pdata(struct i2c_client *client)
 {
 	struct pca953x_platform_data *pdata;
 	struct device_node *node;
-	const uint16_t *val;
+	const u32 *val;
 
 	node = client->dev.of_node;
 	if (node == NULL)
-- 
1.5.6.5


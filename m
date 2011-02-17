Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1BQMM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 07:12:26 -0500
Received: from smtp.nokia.com ([147.243.1.47]:41448 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab1BQMMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 07:12:24 -0500
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org, akpm@kernel.org
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH] NFC: PN544: Add missing regulator.
Date: Thu, 17 Feb 2011 14:09:52 +0200
Message-Id: <1297944592-21784-1-git-send-email-matti.j.aaltonen@nokia.com>
X-Mailer: git-send-email 1.6.1.3
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add regulator VSim to the regulator array.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 drivers/nfc/pn544.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/nfc/pn544.c b/drivers/nfc/pn544.c
index bae6472..724f65d 100644
--- a/drivers/nfc/pn544.c
+++ b/drivers/nfc/pn544.c
@@ -60,7 +60,7 @@ enum pn544_irq {
 struct pn544_info {
 	struct miscdevice miscdev;
 	struct i2c_client *i2c_dev;
-	struct regulator_bulk_data regs[2];
+	struct regulator_bulk_data regs[3];
 
 	enum pn544_state state;
 	wait_queue_head_t read_wait;
@@ -74,6 +74,7 @@ struct pn544_info {
 
 static const char reg_vdd_io[]	= "Vdd_IO";
 static const char reg_vbat[]	= "VBat";
+static const char reg_vsim[]	= "VSim";
 
 /* sysfs interface */
 static ssize_t pn544_test(struct device *dev,
@@ -740,6 +741,7 @@ static int __devinit pn544_probe(struct i2c_client *client,
 
 	info->regs[0].supply = reg_vdd_io;
 	info->regs[1].supply = reg_vbat;
+	info->regs[2].supply = reg_vsim;
 	r = regulator_bulk_get(&client->dev, ARRAY_SIZE(info->regs),
 				 info->regs);
 	if (r < 0)
-- 
1.6.1.3


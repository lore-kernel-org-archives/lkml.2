Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0IDQIE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 12:08:04 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55670 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab0IDQIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 12:08:02 -0400
From: Michael Williamson <michael.williamson@criticallink.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ben-linux@fluff.org, khilman@deeprootsystems.com, chaithrika@ti.com,
        pjohn@in.mvista.com, nageswari@ti.com, dirk.behme@gmail.com,
        Michael Williamson <michael.williamson@criticallink.com>
Subject: [PATCH] i2c-davinci: Fix use of default platform data if none supplied.
Date: Sat,  4 Sep 2010 12:07:48 -0400
Message-Id: <1283616468-6344-1-git-send-email-michael.williamson@criticallink.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bug in the i2c-davinci device init routine that attempts
to use default platform data if none is supplied (e.g., is NULL).
This patch fixes the bug.

Signed-off-by: Michael Williamson <michael.williamson@criticallink.com>
---
 drivers/i2c/busses/i2c-davinci.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 2222c87..6d4eeeb 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -235,10 +235,12 @@ static void i2c_davinci_calc_clk_dividers(struct davinci_i2c_dev *dev)
  */
 static int i2c_davinci_init(struct davinci_i2c_dev *dev)
 {
-	struct davinci_i2c_platform_data *pdata = dev->dev->platform_data;
+	struct davinci_i2c_platform_data *pdata;
 
-	if (!pdata)
-		pdata = &davinci_i2c_platform_data_default;
+	if (!dev->dev->platform_data)
+		dev->dev->platform_data = &davinci_i2c_platform_data_default;
+
+	pdata = dev->dev->platform_data;
 
 	/* put I2C into reset */
 	davinci_i2c_reset_ctrl(dev, 0);
-- 
1.7.0.4


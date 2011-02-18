Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab1BRDNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:13:49 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51805 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558Ab1BRDH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:07:57 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 05/29] ab3100: mfd_cell is now implicitly available to drivers (v2)
Date: Thu, 17 Feb 2011 19:07:12 -0800
Message-Id: <1297998456-7615-6-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cell's platform_data is now accessed with a helper function;
change clients to use that, and remove the now-unused data_size.

v2: add some missing mfd/core.h includes.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/ab3100-core.c  |    4 +---
 drivers/regulator/ab3100.c |    3 ++-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 4193af5..b44c3d9 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -949,10 +949,8 @@ static int __devinit ab3100_probe(struct i2c_client *client,
 		goto exit_no_ops;
 
 	/* Set up and register the platform devices. */
-	for (i = 0; i < ARRAY_SIZE(ab3100_devs); i++) {
+	for (i = 0; i < ARRAY_SIZE(ab3100_devs); i++)
 		ab3100_devs[i].platform_data = ab3100_plf_data;
-		ab3100_devs[i].data_size = sizeof(struct ab3100_platform_data);
-	}
 
 	err = mfd_add_devices(&client->dev, 0, ab3100_devs,
 		ARRAY_SIZE(ab3100_devs), NULL, 0);
diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index ed6feaf..2dec589 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/mfd/abx500.h>
+#include <linux/mfd/core.h>
 
 /* LDO registers and some handy masking definitions for AB3100 */
 #define AB3100_LDO_A		0x40
@@ -576,7 +577,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 
 static int __devinit ab3100_regulators_probe(struct platform_device *pdev)
 {
-	struct ab3100_platform_data *plfdata = pdev->dev.platform_data;
+	struct ab3100_platform_data *plfdata = mfd_get_data(pdev);
 	int err = 0;
 	u8 data;
 	int i;
-- 
1.7.2.3


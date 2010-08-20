Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab0HTI1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:27:20 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:38646 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320Ab0HTI1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:27:18 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 1/2] MFD: move AB3100 to __devinit
Date: Fri, 20 Aug 2010 10:26:56 +0200
Message-ID: <1282292816-4535-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there is no discardable probe() function in the I2C device
framework, let's just tag it __devinit and take the footprint hit
rather than seeing the compilation warnings every day.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/ab3100-core.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 66379b4..1be9fb6 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -665,7 +665,7 @@ struct ab3100_init_setting {
 	u8 setting;
 };
 
-static const struct ab3100_init_setting __initconst
+static const struct ab3100_init_setting __devinitconst
 ab3100_init_settings[] = {
 	{
 		.abreg = AB3100_MCA,
@@ -712,7 +712,7 @@ ab3100_init_settings[] = {
 	},
 };
 
-static int __init ab3100_setup(struct ab3100 *ab3100)
+static int __devinit ab3100_setup(struct ab3100 *ab3100)
 {
 	int err = 0;
 	int i;
@@ -795,7 +795,7 @@ struct ab_family_id {
 	char	*name;
 };
 
-static const struct ab_family_id ids[] __initdata = {
+static const struct ab_family_id ids[] __devinitdata = {
 	/* AB3100 */
 	{
 		.id = 0xc0,
@@ -849,8 +849,8 @@ static const struct ab_family_id ids[] __initdata = {
 	},
 };
 
-static int __init ab3100_probe(struct i2c_client *client,
-			const struct i2c_device_id *id)
+static int __devinit ab3100_probe(struct i2c_client *client,
+				  const struct i2c_device_id *id)
 {
 	struct ab3100 *ab3100;
 	struct ab3100_platform_data *ab3100_plf_data =
@@ -961,7 +961,7 @@ static int __init ab3100_probe(struct i2c_client *client,
 	return err;
 }
 
-static int __exit ab3100_remove(struct i2c_client *client)
+static int __devexit ab3100_remove(struct i2c_client *client)
 {
 	struct ab3100 *ab3100 = i2c_get_clientdata(client);
 	int i;
@@ -995,7 +995,7 @@ static struct i2c_driver ab3100_driver = {
 	},
 	.id_table	= ab3100_id,
 	.probe		= ab3100_probe,
-	.remove		= __exit_p(ab3100_remove),
+	.remove		= __devexit_p(ab3100_remove),
 };
 
 static int __init ab3100_i2c_init(void)
-- 
1.6.3.3


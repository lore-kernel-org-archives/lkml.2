Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab2DDKrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 06:47:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44721 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752913Ab2DDKrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 06:47:04 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] regulator: core: Constify the regulator_desc passed in when registering
Date: Wed,  4 Apr 2012 11:46:58 +0100
Message-Id: <1333536420-9639-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers should be able to declare their descriptors const and the framework
shouldn't ever be modifying the desciptor. Make the parameter and the
pointer in regulator_dev const to enforce this.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c         |    3 ++-
 include/linux/regulator/driver.h |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c056abd..c4b6267 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2829,7 +2829,8 @@ static void rdev_init_debugfs(struct regulator_dev *rdev)
  * Called by regulator drivers to register a regulator.
  * Returns 0 on success.
  */
-struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
+struct regulator_dev *
+regulator_register(const struct regulator_desc *regulator_desc,
 	struct device *dev, const struct regulator_init_data *init_data,
 	void *driver_data, struct device_node *of_node)
 {
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index fa8b55b..1dcdf00 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -184,7 +184,7 @@ struct regulator_desc {
  * no other direct access).
  */
 struct regulator_dev {
-	struct regulator_desc *desc;
+	const struct regulator_desc *desc;
 	int exclusive;
 	u32 use_count;
 	u32 open_count;
@@ -210,7 +210,8 @@ struct regulator_dev {
 	struct dentry *debugfs;
 };
 
-struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
+struct regulator_dev *
+regulator_register(const struct regulator_desc *regulator_desc,
 	struct device *dev, const struct regulator_init_data *init_data,
 	void *driver_data, struct device_node *of_node);
 void regulator_unregister(struct regulator_dev *rdev);
-- 
1.7.9.1


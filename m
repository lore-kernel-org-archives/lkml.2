Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab2F0Nlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:41:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48231 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab2F0Nle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:41:34 -0400
From: Fabio Estevam <festevam@gmail.com>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] regulator: core: Remove unused get_device_regulator
Date: Wed, 27 Jun 2012 10:40:28 -0300
Message-Id: <1340804428-17547-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 222cc7b1 (regulator: core: Allow multiple requests of a single supply mapping)
removed the usage of get_device_regulator().

Remove the function definition too amd get rid of the following warning:

drivers/regulator/core.c:112:26: warning: 'get_device_regulator' defined but not used [-Wunused-function]

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/core.c |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index da31b8a..34b76cc 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -108,28 +108,6 @@ static const char *rdev_get_name(struct regulator_dev *rdev)
 		return "";
 }
 
-/* gets the regulator for a given consumer device */
-static struct regulator *get_device_regulator(struct device *dev)
-{
-	struct regulator *regulator = NULL;
-	struct regulator_dev *rdev;
-
-	mutex_lock(&regulator_list_mutex);
-	list_for_each_entry(rdev, &regulator_list, list) {
-		mutex_lock(&rdev->mutex);
-		list_for_each_entry(regulator, &rdev->consumer_list, list) {
-			if (regulator->dev == dev) {
-				mutex_unlock(&rdev->mutex);
-				mutex_unlock(&regulator_list_mutex);
-				return regulator;
-			}
-		}
-		mutex_unlock(&rdev->mutex);
-	}
-	mutex_unlock(&regulator_list_mutex);
-	return NULL;
-}
-
 /**
  * of_get_regulator - get a regulator device node based on supply name
  * @dev: Device pointer for the consumer (of regulator) device
-- 
1.7.1


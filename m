Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2A2Jwt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 04:52:49 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40779 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2A2Jws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 04:52:48 -0500
Message-ID: <1327830757.16989.1.camel@phoenix>
Subject: [PATCH] regulator: Add devm_regulator_put in consumer.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sun, 29 Jan 2012 17:52:37 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d5ad34f7cb "regulator: Implement devm_regulator_free()"
actually implements devm_regulator_put.
Thus rename devm_regulator_free to devm_regulator_put.

Also add empty devm_regulator_put for !CONFIG_REGULATOR

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 include/linux/regulator/consumer.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index cef8f04..b6c8d71 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -137,7 +137,7 @@ struct regulator *__must_check devm_regulator_get(struct device *dev,
 struct regulator *__must_check regulator_get_exclusive(struct device *dev,
 						       const char *id);
 void regulator_put(struct regulator *regulator);
-void devm_regulator_free(struct regulator *regulator);
+void devm_regulator_put(struct regulator *regulator);
 
 /* regulator output control and status */
 int regulator_enable(struct regulator *regulator);
@@ -216,6 +216,10 @@ static inline void regulator_put(struct regulator *regulator)
 {
 }
 
+static inline void devm_regulator_put(struct regulator *regulator)
+{
+}
+
 static inline int regulator_enable(struct regulator *regulator)
 {
 	return 0;
-- 
1.7.5.4




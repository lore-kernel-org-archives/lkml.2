Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab2KNHri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:47:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43743 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932680Ab2KNHrg (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Wed, 14 Nov 2012 02:47:36 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Add regulator_is_supported_voltage_tol()
Date: Wed, 14 Nov 2012 16:47:29 +0900
Message-Id: <1352879249-6074-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If consumers wish to set voltages based on a tolerance it stands to reason
that they will also want to query for support in the same manner.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regulator/consumer.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 07838c9..528e32a 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -367,4 +367,12 @@ static inline int regulator_set_voltage_tol(struct regulator *regulator,
 				     new_uV - tol_uV, new_uV + tol_uV);
 }
 
+static inline int regulator_is_supported_voltage_tol(struct regulator *regulator,
+						     int target_uV, int tol_uV)
+{
+	return regulator_is_supported_voltage(regulator,
+					      target_uV - tol_uV,
+					      target_uV + tol_uV);
+}
+
 #endif
-- 
1.7.10.4


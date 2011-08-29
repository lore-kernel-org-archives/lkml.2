Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1H2Osk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:48:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62351 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab1H2Osa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:48:30 -0400
Subject: [PATCH 1/2 RESEND] regulator: aat2870: Fix the logic of checking
 if no id is matched in aat2870_get_regulator
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jin Park <jinyoungp@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 22:48:19 +0800
Message-ID: <1314629299.2753.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, the pointer ri is not NULL if no id is matched.
Fix it by checking i == ARRAY_SIZE(aat2870_regulators) if no id is matched.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/aat2870-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
index cd41045..11d1ab4 100644
--- a/drivers/regulator/aat2870-regulator.c
+++ b/drivers/regulator/aat2870-regulator.c
@@ -159,7 +159,7 @@ static struct aat2870_regulator *aat2870_get_regulator(int id)
 			break;
 	}
 
-	if (!ri)
+	if (i == ARRAY_SIZE(aat2870_regulators))
 		return NULL;
 
 	ri->enable_addr = AAT2870_LDO_EN;
-- 
1.7.4.1




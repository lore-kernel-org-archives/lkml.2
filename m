Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1K1GGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 01:06:43 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58544 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab1K1GGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 01:06:42 -0500
Message-ID: <1322460391.4954.1.camel@phoenix>
Subject: [PATCH RESEND 1/2] regulator: aat2870: Fix the logic of checking if
 no id is matched in aat2870_get_regulator
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jin Park <jinyoungp@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 28 Nov 2011 14:06:31 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, the pointer ri is not NULL if no id is matched.
Fix it by checking i == ARRAY_SIZE(aat2870_regulators) if no id is matched.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
It was sent on https://lkml.org/lkml/2011/7/5/559
and resent on https://lkml.org/lkml/2011/8/31/122.

Seems this patch is lost so I resend it again.

Axel
 drivers/regulator/aat2870-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
index 07e98ec..43b25cc 100644
--- a/drivers/regulator/aat2870-regulator.c
+++ b/drivers/regulator/aat2870-regulator.c
@@ -160,7 +160,7 @@ static struct aat2870_regulator *aat2870_get_regulator(int id)
 			break;
 	}
 
-	if (!ri)
+	if (i == ARRAY_SIZE(aat2870_regulators))
 		return NULL;
 
 	ri->enable_addr = AAT2870_LDO_EN;
-- 
1.7.5.4




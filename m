Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2CIH23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 02:28:29 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46282 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab2CIH21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 02:28:27 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-64-4f59b1099ac3
From: Sangbeom Kim <sbkim73@samsung.com>
To: linux-kernel@vger.kernel.org, lrg@ti.com,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: sbkim01@gmail.com
Subject: [PATCH] regulator: Fix s5m8767_set_voltage_time_sel calculation value
Date: Fri, 09 Mar 2012 16:28:10 +0900
Message-id: <06a501ccfdc6$2ded4c60$89c7e520$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acz9xi2GsqgIZuC5TNec9mkSfvYRUg==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the s5m8767_set_voltage_time_sel function, divisor unit is wrong.
ramp_delay is usec unit. So 1000 should be multiplied.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/regulator/s5m8767.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index e369d9e..3592ccb 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -457,7 +457,7 @@ static int s5m8767_set_voltage_time_sel(struct regulator_dev *rdev,
 
 	if (old_sel < new_sel)
 		return DIV_ROUND_UP(desc->step * (new_sel - old_sel),
-					s5m8767->ramp_delay);
+					s5m8767->ramp_delay * 1000);
 	return 0;
 }
 
-- 
1.7.1


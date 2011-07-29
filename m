Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab1G2XRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 19:17:00 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13871 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab1G2XQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 19:16:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 29 Jul 2011 16:16:57 -0700
From: riyer@nvidia.com
To: dmitry.torokhov@gmail.com
Cc: rydberg@euromail.se, olof@lixom.net, amartin@nvidia.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Rakesh Iyer <riyer@nvidia.com>
Subject: [PATCH v1] Input: tegra-kbc - fix computation of polling time
Date: Fri, 29 Jul 2011 16:16:57 -0700
Message-Id: <1311981417-31865-1-git-send-email-riyer@nvidia.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakesh Iyer <riyer@nvidia.com>

Fix a constant definition and computation of polling time.

Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
---
 drivers/input/keyboard/tegra-kbc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index da3828f..263f6fc 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -37,7 +37,7 @@
 #define KBC_ROW_SCAN_DLY	5
 
 /* KBC uses a 32KHz clock so a cycle = 1/32Khz */
-#define KBC_CYCLE_USEC	32
+#define KBC_CYCLE_MS	32
 
 /* KBC Registers */
 
@@ -647,7 +647,7 @@ static int __devinit tegra_kbc_probe(struct platform_device *pdev)
 	debounce_cnt = min(pdata->debounce_cnt, KBC_MAX_DEBOUNCE_CNT);
 	scan_time_rows = (KBC_ROW_SCAN_TIME + debounce_cnt) * num_rows;
 	kbc->repoll_dly = KBC_ROW_SCAN_DLY + scan_time_rows + pdata->repeat_cnt;
-	kbc->repoll_dly = ((kbc->repoll_dly * KBC_CYCLE_USEC) + 999) / 1000;
+	kbc->repoll_dly = (kbc->repoll_dly + KBC_CYCLE_MS - 1) / KBC_CYCLE_MS;
 
 	input_dev->name = pdev->name;
 	input_dev->id.bustype = BUS_HOST;
-- 
1.7.1


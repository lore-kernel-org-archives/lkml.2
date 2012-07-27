Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab2G0Mjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 08:39:33 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36246 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2G0MjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 08:39:08 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        sameo@linux.intel.com, alsa-devel@alsa-project.org,
        broonie@opensource.wolfsonmicro.com, lrg@ti.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/7] mfd: db8500-prcmu: Ensure AB8500 platform data is passed through MFD Core
Date: Fri, 27 Jul 2012 13:38:50 +0100
Message-Id: <1343392734-11805-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343392734-11805-1-git-send-email-lee.jones@linaro.org>
References: <1343392734-11805-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting via platform code the AB8500 platform data is now passed
in though the DB8500. However, if pdata_size is not set it will not be
subsequently passed onto subordinate devices. This patch correctly
populates pdata_size.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 4050a1e..7040a00 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -3002,6 +3002,7 @@ static int __devinit db8500_prcmu_probe(struct platform_device *pdev)
 	for (i = 0; i < ARRAY_SIZE(db8500_prcmu_devs); i++) {
 		if (!strcmp(db8500_prcmu_devs[i].name, "ab8500-core")) {
 			db8500_prcmu_devs[i].platform_data = ab8500_platdata;
+			db8500_prcmu_devs[i].pdata_size = sizeof(struct ab8500_platform_data);
 		}
 	}
 
-- 
1.7.9.5


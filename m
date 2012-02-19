Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab2BSHuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 02:50:21 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62593 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab2BSHuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 02:50:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.237.232 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1329637811.11495.1.camel@phoenix>
Subject: [PATCH] mfd: tps65912: Initialize irq platform data properly
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Sun, 19 Feb 2012 15:50:11 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_base of the tps65912 irq platform data should be
initialized with the board provided irq_base data.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tps65912-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65912-core.c b/drivers/mfd/tps65912-core.c
index 5fec23a..74fd8cb 100644
--- a/drivers/mfd/tps65912-core.c
+++ b/drivers/mfd/tps65912-core.c
@@ -151,7 +151,7 @@ int tps65912_device_init(struct tps65912 *tps65912)
 		goto err;
 
 	init_data->irq = pmic_plat_data->irq;
-	init_data->irq_base = pmic_plat_data->irq;
+	init_data->irq_base = pmic_plat_data->irq_base;
 	ret = tps65912_irq_init(tps65912, init_data->irq, init_data);
 	if (ret < 0)
 		goto err;
-- 
1.7.5.4




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab2IEKA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:00:29 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:39652 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591Ab2IEKA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:00:27 -0400
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.com>
Cc: Lee Jones <lee.jones@linaro.org>, Loic Pallardy <loic.pallardy@gmail.com>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>
Subject: [PATCH 17/17] mfd: db8500-prcmu: activate dbx540-prcmu driver
Date: Wed, 5 Sep 2012 11:59:13 +0200
Message-ID: <1346839153-6465-18-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

db8500-prcmu clean up, removing dbx540 definition from
db8500-prcmu file.

Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c | 30 ++----------------------------
 drivers/mfd/dbx500-prcmu.c |  6 ++++--
 2 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index b39441f..164c9d5 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2988,28 +2988,6 @@ static struct mfd_cell db8500_prcmu_devs[] = {
 	},
 };
 
-static struct mfd_cell db9540_prcmu_devs[] = {
-	{
-		.name = "dbx500-prcmu",
-		.platform_data = &db8500_probe_data,
-		.pdata_size = sizeof(db8500_probe_data),
-	},
-	{
-		.name = "db8500-prcmu-regulators",
-		.of_compatible = "stericsson,db8500-prcmu-regulator",
-		.platform_data = &db8500_regulators,
-		.pdata_size = sizeof(db8500_regulators),
-	},
-	{
-		.name = "ab9540-i2c",
-		.of_compatible = "stericsson,ab8500",
-		.num_resources = ARRAY_SIZE(ab8500_resources),
-		.resources = ab8500_resources,
-		.id = AB8500_VERSION_AB9540,
-	},
-};
-
-
 /**
  * prcmu_fw_init - arch init call for the Linux PRCMU fw init logic
  *
@@ -3052,14 +3030,10 @@ static int __devinit db8500_prcmu_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (cpu_is_u8500v20_or_later() && !cpu_is_u9540())
+	if (cpu_is_u8500v20_or_later())
 		db8500_prcmu_config_esram0_deep_sleep(ESRAM0_DEEP_SLEEP_STATE_RET);
 
-	if (cpu_is_u9540())
-			err = mfd_add_devices(&pdev->dev, 0, db9540_prcmu_devs,
-			ARRAY_SIZE(db9540_prcmu_devs), NULL, 0);
-	else
-		err = mfd_add_devices(&pdev->dev, 0, db8500_prcmu_devs,
+	err = mfd_add_devices(&pdev->dev, 0, db8500_prcmu_devs,
 			ARRAY_SIZE(db8500_prcmu_devs), NULL, 0);
 
 	if (err) {
diff --git a/drivers/mfd/dbx500-prcmu.c b/drivers/mfd/dbx500-prcmu.c
index 1823ab7..964804e 100644
--- a/drivers/mfd/dbx500-prcmu.c
+++ b/drivers/mfd/dbx500-prcmu.c
@@ -725,8 +725,10 @@ void __init prcmu_early_init(struct prcmu_tcdm_map *map)
 {
 	int i, ret = 0;
 	struct prcmu_fops_register_data *data;
-
-	data = db8500_prcmu_early_init(map);
+	if (cpu_is_ux540_family())
+		data =  dbx540_prcmu_early_init(map);
+	else
+		data = db8500_prcmu_early_init(map);
 
 	if (data == NULL)
 		return;
-- 
1.7.11.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2KFVzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 16:55:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56197 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab2KFVzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 16:55:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Will Newton <will.newton@imgtec.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 6/8] mmc: dw_mmc: constify dw_mci_idmac_ops in exynos back-end
Date: Tue,  6 Nov 2012 22:55:31 +0100
Message-Id: <1352238933-4886-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1352238933-4886-1-git-send-email-arnd@arndb.de>
References: <1352238933-4886-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:T8wtbYZUk7YRqg1xEHk6D8ajEvX7rr7pQs8I05fyocI
 TysyiTUuBhvNSk0jbXbwFEbab0gKI6i370Wc0Mwe4Qu5fZKxtj
 WYpwZXsaKnyxHA0K3awg0Zw3E0h32dxZhNCZA0mdhG6nQ/EFxb
 R48uu8uNijfSiTWNJfSGIEM6KRjngAzrwaeo6ri2QsEjLY+7l2
 dDH3f+UhojzzlnJPr4euLaFIVc7QQSfsKmfxhEP7jRy71JJNC+
 /g3rdpJpvhb0k1zw5Lilj/bJAtrUH42pY/naVW97Y1hV946Chh
 nPAn0E2KZRSuMkWmT6zSVzf5A0PMarZNdGn1O4Tuo4pnmHM4DF
 QEYDCZKOPaGM5GXdR067a7UOOE5hhEa0WAap+OhQbRznfzNXkJ
 dx1+ervJ4xlcg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_device_id match data is now marked as const and
must not be modified. This changes the dw_mmc to mark
all pointers passing the dw_mci_drv_data or dw_mci_dma_ops
structures as const, and also marks the static definitions
as const.

drivers/mmc/host/dw_mmc-exynos.c: In function 'dw_mci_exynos_probe':
drivers/mmc/host/dw_mmc-exynos.c:234:11: warning: assignment discards 'const' qualifier from pointer target type [enabled by default]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Will Newton <will.newton@imgtec.com>
Cc: Chris Ball <cjb@laptop.org>
---
 drivers/mmc/host/dw_mmc-exynos.c |    6 +++---
 drivers/mmc/host/dw_mmc-pltfm.c  |    2 +-
 drivers/mmc/host/dw_mmc-pltfm.h  |    2 +-
 drivers/mmc/host/dw_mmc.c        |    2 +-
 include/linux/mmc/dw_mmc.h       |    4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
index 0147ac3a..4d50da6 100644
--- a/drivers/mmc/host/dw_mmc-exynos.c
+++ b/drivers/mmc/host/dw_mmc-exynos.c
@@ -208,7 +208,7 @@ static unsigned long exynos5250_dwmmc_caps[4] = {
 	MMC_CAP_CMD23,
 };
 
-static struct dw_mci_drv_data exynos5250_drv_data = {
+static const struct dw_mci_drv_data exynos5250_drv_data = {
 	.caps			= exynos5250_dwmmc_caps,
 	.init			= dw_mci_exynos_priv_init,
 	.setup_clock		= dw_mci_exynos_setup_clock,
@@ -220,14 +220,14 @@ static struct dw_mci_drv_data exynos5250_drv_data = {
 
 static const struct of_device_id dw_mci_exynos_match[] = {
 	{ .compatible = "samsung,exynos5250-dw-mshc",
-			.data = (void *)&exynos5250_drv_data, },
+			.data = &exynos5250_drv_data, },
 	{},
 };
 MODULE_DEVICE_TABLE(of, dw_mci_exynos_match);
 
 int dw_mci_exynos_probe(struct platform_device *pdev)
 {
-	struct dw_mci_drv_data *drv_data;
+	const struct dw_mci_drv_data *drv_data;
 	const struct of_device_id *match;
 
 	match = of_match_node(dw_mci_exynos_match, pdev->dev.of_node);
diff --git a/drivers/mmc/host/dw_mmc-pltfm.c b/drivers/mmc/host/dw_mmc-pltfm.c
index c960ca7..5e33156 100644
--- a/drivers/mmc/host/dw_mmc-pltfm.c
+++ b/drivers/mmc/host/dw_mmc-pltfm.c
@@ -24,7 +24,7 @@
 #include "dw_mmc.h"
 
 int dw_mci_pltfm_register(struct platform_device *pdev,
-				struct dw_mci_drv_data *drv_data)
+				const struct dw_mci_drv_data *drv_data)
 {
 	struct dw_mci *host;
 	struct resource	*regs;
diff --git a/drivers/mmc/host/dw_mmc-pltfm.h b/drivers/mmc/host/dw_mmc-pltfm.h
index 301f245..2ac37b8 100644
--- a/drivers/mmc/host/dw_mmc-pltfm.h
+++ b/drivers/mmc/host/dw_mmc-pltfm.h
@@ -13,7 +13,7 @@
 #define _DW_MMC_PLTFM_H_
 
 extern int dw_mci_pltfm_register(struct platform_device *pdev,
-				struct dw_mci_drv_data *drv_data);
+				const struct dw_mci_drv_data *drv_data);
 extern int __devexit dw_mci_pltfm_remove(struct platform_device *pdev);
 extern const struct dev_pm_ops dw_mci_pltfm_pmops;
 
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 250aa18..4f01f9f 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -434,7 +434,7 @@ static int dw_mci_idmac_init(struct dw_mci *host)
 	return 0;
 }
 
-static struct dw_mci_dma_ops dw_mci_idmac_ops = {
+static const struct dw_mci_dma_ops dw_mci_idmac_ops = {
 	.init = dw_mci_idmac_init,
 	.start = dw_mci_idmac_start_dma,
 	.stop = dw_mci_idmac_stop_dma,
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index 7c6a113..b611f32 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -137,7 +137,7 @@ struct dw_mci {
 
 	dma_addr_t		sg_dma;
 	void			*sg_cpu;
-	struct dw_mci_dma_ops	*dma_ops;
+	const struct dw_mci_dma_ops	*dma_ops;
 #ifdef CONFIG_MMC_DW_IDMAC
 	unsigned int		ring_size;
 #else
@@ -162,7 +162,7 @@ struct dw_mci {
 	u16			data_offset;
 	struct device		*dev;
 	struct dw_mci_board	*pdata;
-	struct dw_mci_drv_data	*drv_data;
+	const struct dw_mci_drv_data	*drv_data;
 	void			*priv;
 	struct clk		*biu_clk;
 	struct clk		*ciu_clk;
-- 
1.7.10


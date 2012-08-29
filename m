Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab2H2Iv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 04:51:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40424 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2H2Ivy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 04:51:54 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Vinod Koul <vinod.koul@intel.com>, djbw@fb.com,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 1/2] dma: tegra: make tegra_dma.chip_data a pointer to const data
Date: Wed, 29 Aug 2012 10:51:34 +0200
Message-Id: <1346230295-15898-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120829084911.GE28643@pengutronix.de>
References: <20120829084911.GE28643@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laxman Dewangan <ldewangan@nvidia.com>

This prepares *of_device_id.data becoming const. Without this change
the following warning would occur:

	drivers/dma/tegra20-apb-dma.c: In function 'tegra_dma_probe':
	drivers/dma/tegra20-apb-dma.c:1210:9: warning: assignment discards 'const' qualifier from pointer target type [enabled by default]

[ukl: split Laxman's patch to prevent warnings in the middle of the
series. Original patch was sent with msgid
1346217447-19730-1-git-send-email-ldewangan@nvidia.com]

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Acked-by: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/dma/tegra20-apb-dma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index d52dbc6..29a39b8 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -201,7 +201,7 @@ struct tegra_dma {
 	struct clk			*dma_clk;
 	spinlock_t			global_lock;
 	void __iomem			*base_addr;
-	struct tegra_dma_chip_data	*chip_data;
+	const struct tegra_dma_chip_data *chip_data;
 
 	/* Some register need to be cache before suspend */
 	u32				reg_gen;
@@ -1197,7 +1197,7 @@ static int __devinit tegra_dma_probe(struct platform_device *pdev)
 	struct tegra_dma *tdma;
 	int ret;
 	int i;
-	struct tegra_dma_chip_data *cdata = NULL;
+	const struct tegra_dma_chip_data *cdata = NULL;
 
 	if (pdev->dev.of_node) {
 		const struct of_device_id *match;
-- 
1.7.10.4


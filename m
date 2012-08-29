Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab2H2Iv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 04:51:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40428 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab2H2Ivz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 04:51:55 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Vinod Koul <vinod.koul@intel.com>, djbw@fb.com,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 2/2] dma: tegra: make data used as *of_device_id.data const
Date: Wed, 29 Aug 2012 10:51:35 +0200
Message-Id: <1346230295-15898-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346230295-15898-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20120829084911.GE28643@pengutronix.de>
 <1346230295-15898-1-git-send-email-u.kleine-koenig@pengutronix.de>
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

Since of_device_id.data is declared as a pointer to const data a few
more consts can be added in this driver.

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
index 29a39b8..56adcfc 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1166,14 +1166,14 @@ static void tegra_dma_free_chan_resources(struct dma_chan *dc)
 }
 
 /* Tegra20 specific DMA controller information */
-static struct tegra_dma_chip_data tegra20_dma_chip_data = {
+static const struct tegra_dma_chip_data tegra20_dma_chip_data = {
 	.nr_channels		= 16,
 	.max_dma_count		= 1024UL * 64,
 };
 
 #if defined(CONFIG_OF)
 /* Tegra30 specific DMA controller information */
-static struct tegra_dma_chip_data tegra30_dma_chip_data = {
+static const struct tegra_dma_chip_data tegra30_dma_chip_data = {
 	.nr_channels		= 32,
 	.max_dma_count		= 1024UL * 64,
 };
-- 
1.7.10.4


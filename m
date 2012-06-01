Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227Ab2FAJOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:14:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4488 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759213Ab2FAJOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:14:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 01 Jun 2012 02:13:50 -0700
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <olof@lixom.net>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <grant.likely@secretlab.ca>,
        <spi-devel-general@lists.sourceforge.net>
Subject: [PATCH 6/9] spi/tegra: add clk_prepare/clk_unprepare
Date: Fri, 1 Jun 2012 14:42:45 +0530
Message-ID: <1338541968-7961-7-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1338541968-7961-1-git-send-email-pgaikwad@nvidia.com>
References: <1338541968-7961-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use clk_prepare/clk_unprepare as required by the generic clk framework.

This patch should go through Tegra tree since other patches to port Tegra
to generic clock framework are dependent on it. Posting here to get ack from
the maintainers.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 drivers/spi/spi-tegra.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-tegra.c b/drivers/spi/spi-tegra.c
index ae6d78a..7f99ff3 100644
--- a/drivers/spi/spi-tegra.c
+++ b/drivers/spi/spi-tegra.c
@@ -261,7 +261,7 @@ static void spi_tegra_start_transfer(struct spi_device *spi,
 		clk_set_rate(tspi->clk, speed);
 
 	if (tspi->cur_speed == 0)
-		clk_enable(tspi->clk);
+		clk_prepare_enable(tspi->clk);
 
 	tspi->cur_speed = speed;
 
@@ -373,7 +373,7 @@ static void tegra_spi_rx_dma_complete(struct tegra_dma_req *req)
 			spi = m->state;
 			spi_tegra_start_message(spi, m);
 		} else {
-			clk_disable(tspi->clk);
+			clk_disable_unprepare(tspi->clk);
 			tspi->cur_speed = 0;
 		}
 	}
-- 
1.7.4.1


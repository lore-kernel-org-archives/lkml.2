Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab3AFQXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 11:23:17 -0500
Received: from [216.228.121.140] ([216.228.121.140]:2827 "EHLO
	hqemgate03.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab3AFQXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 11:23:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 06 Jan 2013 08:18:06 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <vinod.koul@intel.com>
CC: <djbw@fb.com>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] dma: tegra: add support for Tegra114 SoC
Date: Sun, 6 Jan 2013 21:52:03 +0530
Message-ID: <1357489323-21359-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1357489323-21359-1-git-send-email-ldewangan@nvidia.com>
References: <1357489323-21359-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NVIDIA's Tegra114 has APB DMA controller which has 32 dma channels
and support support channel wise pause control.

Add support for Tegra114 which uses the channel wise pause control
hardware feature.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/dma/tegra20-apb-dma.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 1f3ea0f..d33c1ae 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1217,8 +1217,19 @@ static const struct tegra_dma_chip_data tegra30_dma_chip_data = {
 	.support_channel_pause	= false,
 };
 
+/* Tegra114 specific DMA controller information */
+static const struct tegra_dma_chip_data tegra114_dma_chip_data = {
+	.nr_channels		= 32,
+	.max_dma_count		= 1024UL * 64,
+	.support_channel_pause	= true,
+};
+
+
 static const struct of_device_id tegra_dma_of_match[] = {
 	{
+		.compatible = "nvidia,tegra114-apbdma",
+		.data = &tegra114_dma_chip_data,
+	}, {
 		.compatible = "nvidia,tegra30-apbdma",
 		.data = &tegra30_dma_chip_data,
 	}, {
-- 
1.7.1.1


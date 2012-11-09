Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab2KIJK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 04:10:29 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1233 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2KIJKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 04:10:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 09 Nov 2012 01:09:58 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <broonie@opensource.wolfsonmicro.com>
CC: <swarren@nvidia.com>, <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] spi: tegra: sequence compatible strings as per preference
Date: Fri, 9 Nov 2012 14:37:32 +0530
Message-ID: <1352452052-13823-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sequence compatible list for tegra20-slink driver to first
look for Tegra30 and then Tegra20. Tegra30 have additional
feature in HW which need to be utilize if it is provided from DT.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/spi/spi-tegra20-slink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index 07dc735..7882b50 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -1109,8 +1109,8 @@ const struct tegra_slink_chip_data tegra20_spi_cdata = {
 };
 
 static struct of_device_id tegra_slink_of_match[] __devinitconst = {
-	{ .compatible = "nvidia,tegra20-slink", .data = &tegra20_spi_cdata, },
 	{ .compatible = "nvidia,tegra30-slink", .data = &tegra30_spi_cdata, },
+	{ .compatible = "nvidia,tegra20-slink", .data = &tegra20_spi_cdata, },
 	{}
 };
 MODULE_DEVICE_TABLE(of, tegra_slink_of_match);
-- 
1.7.1.1


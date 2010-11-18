Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab0KRJD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:03:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:51165 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab0KRJDW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:03:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,216,1288594800"; 
   d="scan'208,223";a="858891994"
Date: Thu, 18 Nov 2010 17:01:07 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, arjan@linux.intel.com
Subject: [PATCH v2 3/3]mmc: Add the new quirk to MFLD SDHCI HC
Message-ID: <20101118090107.GD18161@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 26a27fbbb8c28f7b2e9079b7e600625af5718b8c Mon Sep 17 00:00:00 2001
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
Date: Thu, 18 Nov 2010 16:25:03 +0800
Subject: [PATCH 3/3] mmc: Add SDHCI_QUIRK_FORCE_ERASE_SINGLE to MFLD sdhci HC

This will be going to let MFLD SDHCI host controller to erase single block
each time.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/host/sdhci-pci.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 3d9c246..6eea1ba 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -169,11 +169,13 @@ static const struct sdhci_pci_fixes sdhci_intel_mrst_hc1_hc2 = {
 };
 
 static const struct sdhci_pci_fixes sdhci_intel_mfd_sd = {
-	.quirks		= SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC,
+	.quirks		= SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC |
+				SDHCI_QUIRK_FORCE_ERASE_SINGLE,
 };
 
 static const struct sdhci_pci_fixes sdhci_intel_mfd_emmc_sdio = {
-	.quirks		= SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC,
+	.quirks		= SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC |
+				SDHCI_QUIRK_FORCE_ERASE_SINGLE,
 };
 
 static int jmicron_pmos(struct sdhci_pci_chip *chip, int on)
-- 
1.6.6.1


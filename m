Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab0LBLaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:30:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:17567 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab0LBLaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:30:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,287,1288594800"; 
   d="scan'208,223";a="632360599"
Date: Thu, 2 Dec 2010 19:27:00 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, arjan@linux.intel.com,
        alan@linux.intel.com, akpm@linux-foundation.org,
        adrian.hunter@nokia.com
Subject: [PATCH v3 3/3]add this quirk to MFLD SDHCI host
Message-ID: <20101202112700.GD10358@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8572052d6130daaddbae7c529b02a61692ff765f Mon Sep 17 00:00:00 2001
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
Date: Thu, 2 Dec 2010 18:53:39 +0800
Subject: [PATCH 3/3] Add quirk to MFLD sdhci host controller

MFLD platform host controller cannot erase too many sectors at one time,
this quirk will let host controller only erase single eraseblock each time.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/host/sdhci-pci.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 831cf91..2419cc5 100644
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
 
 /* O2Micro extra registers */
-- 
1.6.6.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196Ab2JWNn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:43:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:57446 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933183Ab2JWNny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:43:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="237191353"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 26/26] mmc: sdhci-pci: add panic write support
Date: Tue, 23 Oct 2012 16:48:24 +0300
Message-Id: <1351000104-13015-27-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
References: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 drivers/mmc/host/sdhci-pci.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 4bb74b0..bee9a45 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -966,6 +966,8 @@ static void sdhci_pci_hw_reset(struct sdhci_host *host)
 
 	if (!gpio_is_valid(rst_n_gpio))
 		return;
+	if (mmc_panic_task_active(host->mmc))
+		return;
 	gpio_set_value_cansleep(rst_n_gpio, 0);
 	/* For eMMC, minimum is 1us but give it 10us for good measure */
 	udelay(10);
@@ -1278,6 +1280,9 @@ static struct sdhci_pci_slot * __devinit sdhci_pci_probe_slot(
 	}
 
 	host->mmc->pm_caps = MMC_PM_KEEP_POWER | MMC_PM_WAKE_SDIO_IRQ;
+#ifdef CONFIG_MMC_BLOCK_PANIC_WRITE
+	slot->host->mmc->caps2 = MMC_CAP_PANIC_WRITE;
+#endif
 
 	ret = sdhci_add_host(host);
 	if (ret)
-- 
1.7.9.5


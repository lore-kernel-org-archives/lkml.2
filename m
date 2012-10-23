Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182Ab2JWNnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:43:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:19320 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933126Ab2JWNnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:43:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="237191301"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 19/26] mmc: sdhci: panic write: no runtime pm
Date: Tue, 23 Oct 2012 16:48:17 +0300
Message-Id: <1351000104-13015-20-git-send-email-irina.tirdea@intel.com>
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
 drivers/mmc/host/sdhci.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 3653494..fcedcec 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2601,11 +2601,17 @@ EXPORT_SYMBOL_GPL(sdhci_enable_irq_wakeups);
 
 static int sdhci_runtime_pm_get(struct sdhci_host *host)
 {
+	if (mmc_am_panic_task(host->mmc))
+		return 0;
+
 	return pm_runtime_get_sync(host->mmc->parent);
 }
 
 static int sdhci_runtime_pm_put(struct sdhci_host *host)
 {
+	if (mmc_am_panic_task(host->mmc))
+		return 0;
+
 	pm_runtime_mark_last_busy(host->mmc->parent);
 	return pm_runtime_put_autosuspend(host->mmc->parent);
 }
-- 
1.7.9.5


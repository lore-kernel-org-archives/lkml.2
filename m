Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab1KDIQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 04:16:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:62538 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684Ab1KDIQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 04:16:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="70971306"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V3 2/4] mmc: sdhci: prevent card detection activity for non-removable cards
Date: Fri,  4 Nov 2011 10:16:01 +0200
Message-Id: <1320394563-29682-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320394563-29682-1-git-send-email-adrian.hunter@intel.com>
References: <1320394563-29682-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not enable card detection interrupts for non-removable cards.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/mmc/host/sdhci.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 5b01eff..2213366 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -146,10 +146,9 @@ static void sdhci_set_card_detection(struct sdhci_host *host, bool enable)
 {
 	u32 present, irqs;
 
-	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
-		return;
-
-	if (host->quirks2 & SDHCI_QUIRK2_OWN_CARD_DETECTION)
+	if ((host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION) ||
+	    (host->quirks2 & SDHCI_QUIRK2_OWN_CARD_DETECTION) ||
+	    !mmc_card_is_removable(host->mmc))
 		return;
 
 	present = sdhci_readl(host, SDHCI_PRESENT_STATE) &
-- 
1.7.6.4


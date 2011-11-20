Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab1KTV37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 16:29:59 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:46200 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab1KTV34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 16:29:56 -0500
Date: Sun, 20 Nov 2011 15:29:51 -0600
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Yunpeng Gao <yunpeng.gao@intel.com>
Subject: [PATCH] sdhci-pci register legacy PCI PM or runtime PM not both
Message-ID: <20111120212951.GA4577@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (SpacedOut.fries.net [127.0.0.1]); Sun, 20 Nov 2011 15:29:52 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Fries <David@Fries.net>

pci_has_legacy_pm_support says to not register both legacy PM
and runtime PM callbacks, modified ifdefs.

Signed-off-by: David Fries <David@Fries.net>
Cc: linux-mmc@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Yunpeng Gao <yunpeng.gao@intel.com>
---
 drivers/mmc/host/sdhci-pci.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index d833d9c..eca6e84 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -991,7 +991,8 @@ static struct sdhci_ops sdhci_pci_ops = {
  *                                                                           *
 \*****************************************************************************/
 
-#ifdef CONFIG_PM
+/* Register legacy PM or PM runtime, not both. */
+#if defined(CONFIG_PM) && !defined(CONFIG_PM_RUNTIME)
 
 static int sdhci_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
@@ -1085,12 +1086,12 @@ static int sdhci_pci_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-#else /* CONFIG_PM */
+#else /* CONFIG_PM && !CONFIG_PM_RUNTIME */
 
 #define sdhci_pci_suspend NULL
 #define sdhci_pci_resume NULL
 
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM && !CONFIG_PM_RUNTIME */
 
 #ifdef CONFIG_PM_RUNTIME
 
-- 
1.7.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab1KDIBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 04:01:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:30607 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab1KDIBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 04:01:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,454,1315206000"; 
   d="scan'208";a="81162079"
Message-ID: <4EB39BB4.3060508@intel.com>
Date: Fri, 04 Nov 2011 10:00:52 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: joe@perches.com
CC: linux-kernel@vger.kernel.org, linux-mmc <linux-mmc@vger.kernel.org>
Subject: Incorrect checkpatch warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This checkpatch warning looks wrong:

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#73: FILE: drivers/mmc/host/sdhci-pci-data.c:5:
+EXPORT_SYMBOL_GPL(sdhci_pci_get_data);

The patch has this:

diff --git a/drivers/mmc/host/sdhci-pci-data.c b/drivers/mmc/host/sdhci-pci-data.c
new file mode 100644
index 0000000..a611217
--- /dev/null
+++ b/drivers/mmc/host/sdhci-pci-data.c
@@ -0,0 +1,5 @@
+#include <linux/module.h>
+#include <linux/mmc/sdhci-pci-data.h>
+
+struct sdhci_pci_data *(*sdhci_pci_get_data)(struct pci_dev *pdev, int slotno);
+EXPORT_SYMBOL_GPL(sdhci_pci_get_data);


Regards
Adrian

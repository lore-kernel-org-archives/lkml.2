Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157Ab2JWNnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:43:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:56255 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933051Ab2JWNnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:43:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="237191298"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 18/26] mmc: sdhci: panic write: no timeout timer
Date: Tue, 23 Oct 2012 16:48:16 +0300
Message-Id: <1351000104-13015-19-git-send-email-irina.tirdea@intel.com>
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
 drivers/mmc/host/sdhci.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index ff72e98..3653494 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1012,7 +1012,8 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 		mdelay(1);
 	}
 
-	mod_timer(&host->timer, jiffies + 10 * HZ);
+	if (!mmc_am_panic_task(host->mmc))
+		mod_timer(&host->timer, jiffies + 10 * HZ);
 
 	host->cmd = cmd;
 
@@ -2117,7 +2118,8 @@ static void sdhci_tasklet_finish(unsigned long param)
 		return;
 	}
 
-	del_timer(&host->timer);
+	if (!mmc_am_panic_task(host->mmc))
+		del_timer(&host->timer);
 
 	mrq = host->mrq;
 
-- 
1.7.9.5


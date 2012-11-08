Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2KHPJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:09:20 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46468 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2KHPJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:09:18 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] mmc: sdhci-spear: Initialize sdhci clk to 50 MHz
Date: Thu,  8 Nov 2012 20:39:09 +0530
Message-Id: <fd576f198e6f3dc4031bb905247ed9c0a0b66a20.1352387305.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vipul Kumar Samar <vipulkumar.samar@st.com>

SPEAr sdhci driver expects the clock to be set to 50 MHz for proper functioning.
This patch sets clk to 50 MHz in probe.

Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/mmc/host/sdhci-spear.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mmc/host/sdhci-spear.c b/drivers/mmc/host/sdhci-spear.c
index 6be89c0..fea8bf9 100644
--- a/drivers/mmc/host/sdhci-spear.c
+++ b/drivers/mmc/host/sdhci-spear.c
@@ -146,6 +146,11 @@ static int __devinit sdhci_probe(struct platform_device *pdev)
 		goto put_clk;
 	}
 
+	ret = clk_set_rate(sdhci->clk, 50000000);
+	if (ret)
+		dev_dbg(&pdev->dev, "Error setting desired clk, clk=%lu\n",
+				clk_get_rate(sdhci->clk));
+
 	if (np) {
 		sdhci->data = sdhci_probe_config_dt(pdev);
 		if (IS_ERR(sdhci->data)) {
-- 
1.7.12.rc2.18.g61b472e


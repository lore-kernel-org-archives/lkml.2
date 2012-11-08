Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab2KHPJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:09:29 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33299 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2KHPJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:09:23 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/2] mmc: sdhci-spear: Don't call clk_{un}prepare() in suspend resume
Date: Thu,  8 Nov 2012 20:39:10 +0530
Message-Id: <e677b5b8e17c2349d624e949722f4ab1a5e1698c.1352387305.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <fd576f198e6f3dc4031bb905247ed9c0a0b66a20.1352387305.git.viresh.kumar@linaro.org>
References: <fd576f198e6f3dc4031bb905247ed9c0a0b66a20.1352387305.git.viresh.kumar@linaro.org>
In-Reply-To: <fd576f198e6f3dc4031bb905247ed9c0a0b66a20.1352387305.git.viresh.kumar@linaro.org>
References: <fd576f198e6f3dc4031bb905247ed9c0a0b66a20.1352387305.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_{un}prepare is mandatory for platforms using common clock framework. Because
for SPEAr we don't do anything in clk_{un}prepare() calls, just call them ones
in probe/remove.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/mmc/host/sdhci-spear.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-spear.c b/drivers/mmc/host/sdhci-spear.c
index fea8bf9..87a7009 100644
--- a/drivers/mmc/host/sdhci-spear.c
+++ b/drivers/mmc/host/sdhci-spear.c
@@ -302,7 +302,7 @@ static int sdhci_suspend(struct device *dev)
 
 	ret = sdhci_suspend_host(host);
 	if (!ret)
-		clk_disable_unprepare(sdhci->clk);
+		clk_disable(sdhci->clk);
 
 	return ret;
 }
@@ -313,7 +313,7 @@ static int sdhci_resume(struct device *dev)
 	struct spear_sdhci *sdhci = dev_get_platdata(dev);
 	int ret;
 
-	ret = clk_prepare_enable(sdhci->clk);
+	ret = clk_enable(sdhci->clk);
 	if (ret) {
 		dev_dbg(dev, "Resume: Error enabling clock\n");
 		return ret;
-- 
1.7.12.rc2.18.g61b472e


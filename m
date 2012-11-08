Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab2KHPKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:10:09 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60365 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab2KHPKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:10:06 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] ata: pata_arasan: Initialize cf clock to 166MHz
Date: Thu,  8 Nov 2012 20:39:54 +0530
Message-Id: <382d2087350ff0955ba14f125294ace4ed28382b.1352387366.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vipul Kumar Samar <vipulkumar.samar@st.com>

PATA arasan driver expects the clock to be set to 166 MHz for proper functioning.
This patch sets clk to 166 MHz in probe.

Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/ata/pata_arasan_cf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index 26201eb..71111f2 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -317,6 +317,12 @@ static int cf_init(struct arasan_cf_dev *acdev)
 		return ret;
 	}
 
+	ret = clk_set_rate(acdev->clk, 166000000);
+	if (ret) {
+		dev_warn(acdev->host->dev, "clock set rate failed");
+		return ret;
+	}
+
 	spin_lock_irqsave(&acdev->host->lock, flags);
 	/* configure CF interface clock */
 	writel((pdata->cf_if_clk <= CF_IF_CLK_200M) ? pdata->cf_if_clk :
-- 
1.7.12.rc2.18.g61b472e


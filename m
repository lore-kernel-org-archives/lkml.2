Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab2GEKOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:14:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58308 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab2GEKOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:14:15 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Cc: Chris Ball <cjb@laptop.org>, Anton Vorontsov <cbouatmailru@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, Viresh Kumar <viresh.kumar@st.com>,
        Manuel Lauss <manuel.lauss@googlemail.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/2] mmc: sdhci-dove: Add SDHCI_QUIRK_NO_HISPD_BIT
Date: Thu,  5 Jul 2012 12:14:00 +0200
Message-Id: <1341483241-18300-1-git-send-email-sebastian.hesselbarth@googlemail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sdio controller on dove doesn't have a bit to indicate
high-speed. With the quirk set it fixes accessing high-speed
sdcards.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Viresh Kumar <viresh.kumar@st.com>
Cc: Manuel Lauss <manuel.lauss@googlemail.com>
Cc: linux-mmc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/mmc/host/sdhci-dove.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-dove.c b/drivers/mmc/host/sdhci-dove.c
index 177f697..9c85368 100644
--- a/drivers/mmc/host/sdhci-dove.c
+++ b/drivers/mmc/host/sdhci-dove.c
@@ -66,7 +66,8 @@ static struct sdhci_pltfm_data sdhci_dove_pdata = {
 	.quirks	= SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER |
 		  SDHCI_QUIRK_NO_BUSY_IRQ |
 		  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
-		  SDHCI_QUIRK_FORCE_DMA,
+		  SDHCI_QUIRK_FORCE_DMA |
+		  SDHCI_QUIRK_NO_HISPD_BIT,
 };
 
 static int __devinit sdhci_dove_probe(struct platform_device *pdev)
-- 
1.7.10


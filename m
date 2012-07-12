Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab2GLH0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 03:26:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58556 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2GLH0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 03:26:52 -0400
Message-ID: <4FFE7C38.9020800@googlemail.com>
Date: Thu, 12 Jul 2012 09:26:48 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Rabeeh Khoury <rabeeh@solid-run.com>
CC: Chris Ball <cjb@laptop.org>, Anton Vorontsov <cbouatmailru@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v1 1/2] mmc: sdhci-dove: Add SDHCI_QUIRK_NO_HISPD_BIT
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump. There has been no discussion on this patch nor on patch 2/2. Is there
anybody out there willing to test and confirm these patches?
--
The sdio controller on dove doesn't have a bit to indicate
high-speed. With the quirk set it fixes accessing high-speed
sdcards.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
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


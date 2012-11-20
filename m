Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab2KTEti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:49:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40698 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798Ab2KTEtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:49:36 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/5] mfd: arizona: Correctly report when AIF2/AIF1 is underclocked
Date: Tue, 20 Nov 2012 13:46:20 +0900
Message-Id: <1353386781-10468-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353386781-10468-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20121120044544.GF4483@opensource.wolfsonmicro.com>
 <1353386781-10468-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

In the interrupt handler for an underclocked event, whilst checking for
the source of the interrupt, AIF3 was checked twice and AIF1 was not
checked. This change correctly checks the AIF1 underclocked bit and
reports the correct error messages for all cases.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 166254b..202bf55 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -98,9 +98,9 @@ static irqreturn_t arizona_underclocked(int irq, void *data)
 
 	if (val & ARIZONA_AIF3_UNDERCLOCKED_STS)
 		dev_err(arizona->dev, "AIF3 underclocked\n");
-	if (val & ARIZONA_AIF3_UNDERCLOCKED_STS)
-		dev_err(arizona->dev, "AIF3 underclocked\n");
 	if (val & ARIZONA_AIF2_UNDERCLOCKED_STS)
+		dev_err(arizona->dev, "AIF2 underclocked\n");
+	if (val & ARIZONA_AIF1_UNDERCLOCKED_STS)
 		dev_err(arizona->dev, "AIF1 underclocked\n");
 	if (val & ARIZONA_ISRC2_UNDERCLOCKED_STS)
 		dev_err(arizona->dev, "ISRC2 underclocked\n");
-- 
1.7.10.4


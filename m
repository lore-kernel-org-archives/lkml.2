Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665Ab2JYOOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:14:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58821 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759638Ab2JYOOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:14:15 -0400
Date: Thu, 25 Oct 2012 15:14:13 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mfd: arizona: Correctly report when AIF2/AIF1 is
	underclocked
Message-ID: <20121025141413.GA31418@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the interrupt handler for an underclocked event, whilst checking for
the source of the interrupt, AIF3 was checked twice and AIF1 was not
checked. This change correctly checks the AIF1 underclocked bit and
reports the correct error messages for all cases.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
1.7.2.5


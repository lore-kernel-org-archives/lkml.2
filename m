Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab1IICPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 22:15:51 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:50173 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab1IICPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 22:15:50 -0400
Subject: [PATCH] ASoC: playpaq_wm8510: Return proper error if clk_get fails
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Geoffrey Wossum <gwossum@acm.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Sep 2011 10:15:37 +0800
Message-ID: <1315534538.3275.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return proper error instead of 0 if clk_get fails.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/atmel/playpaq_wm8510.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/sound/soc/atmel/playpaq_wm8510.c b/sound/soc/atmel/playpaq_wm8510.c
index 1aac2f4..2909bfa 100644
--- a/sound/soc/atmel/playpaq_wm8510.c
+++ b/sound/soc/atmel/playpaq_wm8510.c
@@ -383,14 +383,17 @@ static int __init playpaq_asoc_init(void)
 	_gclk0 = clk_get(NULL, "gclk0");
 	if (IS_ERR(_gclk0)) {
 		_gclk0 = NULL;
+		ret = PTR_ERR(_gclk0);
 		goto err_gclk0;
 	}
 	_pll0 = clk_get(NULL, "pll0");
 	if (IS_ERR(_pll0)) {
 		_pll0 = NULL;
+		ret = PTR_ERR(_pll0);
 		goto err_pll0;
 	}
-	if (clk_set_parent(_gclk0, _pll0)) {
+	ret = clk_set_parent(_gclk0, _pll0);
+	if (ret) {
 		pr_warning("snd-soc-playpaq: "
 			   "Failed to set PLL0 as parent for DAC clock\n");
 		goto err_set_clk;
-- 
1.7.4.1




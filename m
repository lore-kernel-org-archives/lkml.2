Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2A3WCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:02:13 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:45885 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848Ab2A3WAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:00:40 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/16] max2165: trival fix for some -Wuninitialized warning
Date: Mon, 30 Jan 2012 23:00:06 +0100
Message-Id: <1327960820-11867-3-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327960840;836e2fd0;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for some -Wuninitialized compiler warnings.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/media/common/tuners/max2165.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/tuners/max2165.c b/drivers/media/common/tuners/max2165.c
index cb2c98f..ba84936 100644
--- a/drivers/media/common/tuners/max2165.c
+++ b/drivers/media/common/tuners/max2165.c
@@ -168,7 +168,7 @@ int fixpt_div32(u32 dividend, u32 divisor, u32 *quotient, u32 *fraction)
 	int i;
 
 	if (0 == divisor)
-		return -1;
+		return -EINVAL;
 
 	q = dividend / divisor;
 	remainder = dividend - q * divisor;
@@ -194,10 +194,13 @@ static int max2165_set_rf(struct max2165_priv *priv, u32 freq)
 	u8 tf_ntch;
 	u32 t;
 	u32 quotient, fraction;
+	int ret;
 
 	/* Set PLL divider according to RF frequency */
-	fixpt_div32(freq / 1000, priv->config->osc_clk * 1000,
-		&quotient, &fraction);
+	ret = fixpt_div32(freq / 1000, priv->config->osc_clk * 1000,
+			 &quotient, &fraction);
+	if (ret != 0)
+		return ret;
 
 	/* 20-bit fraction */
 	fraction >>= 12;
-- 
1.7.7.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab2BGGXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 01:23:17 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42502 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2BGGXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 01:23:16 -0500
Message-ID: <1328595786.5274.6.camel@phoenix>
Subject: [PATCH RFC] leds: lm3530: Fix setting pltfm->als_vmax
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 07 Feb 2012 14:23:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, pltfm->als_vmin is set to LM3530_ALS_WINDOW_mV and 
pltfm->als_vmax is 0. This looks does not make sense.
I think what we want here is setting pltfm->als_vmax to LM3530_ALS_WINDOW_mV.

Both als_vmin and als_vmax local variables will be set to pltfm->als_vmin and
pltfm->als_vmax by a few lines latter.
Thus also remove a redundant assignment for als_vmin and als_vmax in this patch.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi Kim,
I don't have this hardware, I'd appreciate if you can review and test this patch.

Thanks,
Axel
 drivers/leds/leds-lm3530.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 45e6878..e59c166 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -164,8 +164,8 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 
 	if (drvdata->mode == LM3530_BL_MODE_ALS) {
 		if (pltfm->als_vmax == 0) {
-			pltfm->als_vmin = als_vmin = 0;
-			pltfm->als_vmin = als_vmax = LM3530_ALS_WINDOW_mV;
+			pltfm->als_vmin = 0;
+			pltfm->als_vmax = LM3530_ALS_WINDOW_mV;
 		}
 
 		als_vmin = pltfm->als_vmin;
-- 
1.7.5.4




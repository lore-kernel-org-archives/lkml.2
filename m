Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab1JJFHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 01:07:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61673 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1JJFHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 01:07:22 -0400
From: Michael Opdenacker <michael.opdenacker@linaro.org>
To: jarkko.nikula@bitmer.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        perex@perex.cz, tiwai@suse.de
Cc: linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@linaro.org>
Subject: [PATCH 1/2] omap: sound: fix "ambiguous else" warning
Date: Mon, 10 Oct 2011 07:07:07 +0200
Message-Id: <1318223228-15671-2-git-send-email-michael.opdenacker@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318223228-15671-1-git-send-email-michael.opdenacker@linaro.org>
References: <1318223228-15671-1-git-send-email-michael.opdenacker@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies against Tony Lindgren's linux-omap tree
It fixes "ambiguous else" warnings at compile time.

Signed-off-by: Michael Opdenacker <michael.opdenacker@linaro.org>
---
 sound/soc/omap/omap-mcbsp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/soc/omap/omap-mcbsp.c b/sound/soc/omap/omap-mcbsp.c
index 478d607..1391ea0 100644
--- a/sound/soc/omap/omap-mcbsp.c
+++ b/sound/soc/omap/omap-mcbsp.c
@@ -516,11 +516,12 @@ static int omap_mcbsp_dai_set_dai_sysclk(struct snd_soc_dai *cpu_dai,
 	struct omap_mcbsp_reg_cfg *regs = &mcbsp_data->regs;
 	int err = 0;
 
-	if (mcbsp_data->active)
+	if (mcbsp_data->active) {
 		if (freq == mcbsp_data->in_freq)
 			return 0;
 		else
 			return -EBUSY;
+	}
 
 	/* The McBSP signal muxing functions are only available on McBSP1 */
 	if (clk_id == OMAP_MCBSP_CLKR_SRC_CLKR ||
-- 
1.7.4.1


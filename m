Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463Ab2J3OZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 10:25:16 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:53009 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab2J3OZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 10:25:12 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: swarren@nvidia.com
Cc: digetx@gmail.com, tiwai@suse.de, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: tegra: update spdif tx_atn_lvl on hw_params()
Date: Tue, 30 Oct 2012 18:23:59 +0400
Message-Id: <1351607039-9027-1-git-send-email-digetx@gmail.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prevents playing sound with wrong speed.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
I'm using deep sleep on my tablet and faced with this bug when played sound via
hdmi after suspend. I know that there is no deep sleep support in upstream kernel,
but will be nice to see that bug fixed.

 sound/soc/tegra/tegra20_spdif.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/tegra/tegra20_spdif.c b/sound/soc/tegra/tegra20_spdif.c
index 3ebc867..24b46f1 100644
--- a/sound/soc/tegra/tegra20_spdif.c
+++ b/sound/soc/tegra/tegra20_spdif.c
@@ -114,6 +114,10 @@ static int tegra20_spdif_hw_params(struct snd_pcm_substream *substream,
 		return ret;
 	}
 
+	regmap_update_bits(spdif->regmap, TEGRA20_SPDIF_DATA_FIFO_CSR,
+			   TEGRA20_SPDIF_DATA_FIFO_CSR_TX_ATN_LVL_MASK,
+			   TEGRA20_SPDIF_DATA_FIFO_CSR_TX_ATN_LVL_TU4_WORD_FULL);
+
 	return 0;
 }
 
-- 
1.7.12


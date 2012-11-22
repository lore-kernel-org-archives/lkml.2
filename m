Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2KWFqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 00:46:18 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:56743 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2KWFqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 00:46:14 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: <alsa-devel@alsa-project.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [BUGFIX PATCH] ASoC: imx-sgtl5000: prevent module from being unloaded when in use
Date: Thu, 22 Nov 2012 13:31:08 +0100
Message-Id: <1353587470-11994-3-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1353587470-11994-1-git-send-email-LW@KARO-electronics.de>
References: <1353587470-11994-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set the 'onwer' field of the registered snd_soc_card object to prevent
removal of the module when its resources are in use.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 sound/soc/fsl/imx-sgtl5000.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/fsl/imx-sgtl5000.c b/sound/soc/fsl/imx-sgtl5000.c
index 199408e..3d9b1c4 100644
--- a/sound/soc/fsl/imx-sgtl5000.c
+++ b/sound/soc/fsl/imx-sgtl5000.c
@@ -162,6 +162,7 @@ static int __devinit imx_sgtl5000_probe(struct platform_device *pdev)
 	if (ret)
 		goto clk_fail;
 	data->card.num_links = 1;
+	data->card.owner = THIS_MODULE;
 	data->card.dai_link = &data->dai;
 	data->card.dapm_widgets = imx_sgtl5000_dapm_widgets;
 	data->card.num_dapm_widgets = ARRAY_SIZE(imx_sgtl5000_dapm_widgets);
-- 
1.7.2.5


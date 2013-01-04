Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab3ADJyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 04:54:37 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47082 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab3ADJye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 04:54:34 -0500
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <alsa-devel@alsa-project.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <tony@atomide.com>, <lrg@ti.com>, <perex@perex.cz>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <rob@landley.net>
Subject: [PATCH V2 1/2] ASoC: davinci-mcasp: Add pinctrl support
Date: Fri, 4 Jan 2013 15:24:36 +0530
Message-ID: <1357293277-25543-2-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357293277-25543-1-git-send-email-gururaja.hebbar@ti.com>
References: <1357293277-25543-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>

Signed-off-by: Hebbar, Gururaja <gururaja.hebbar@ti.com>
---
Changes in V2
	- no change

:100644 100644 55e2bf6... 83d96eb... M	sound/soc/davinci/davinci-mcasp.c
 sound/soc/davinci/davinci-mcasp.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index 55e2bf6..83d96eb 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -25,6 +25,7 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/of_device.h>
+#include <linux/pinctrl/consumer.h>
 
 #include <sound/core.h>
 #include <sound/pcm.h>
@@ -1080,6 +1081,7 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 	struct resource *mem, *ioarea, *res;
 	struct snd_platform_data *pdata;
 	struct davinci_audio_dev *dev;
+	struct pinctrl *pinctrl;
 	int ret;
 
 	if (!pdev->dev.platform_data && !pdev->dev.of_node) {
@@ -1111,6 +1113,11 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 		return -EBUSY;
 	}
 
+	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(pinctrl))
+		dev_warn(&pdev->dev,
+				"pins are not configured from the driver\n");
+
 	pm_runtime_enable(&pdev->dev);
 
 	ret = pm_runtime_get_sync(&pdev->dev);
-- 
1.7.9.5


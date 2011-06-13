Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab1FMQl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 12:41:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44857 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab1FMQih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 12:38:37 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH v5 10/18] MFD: twl6040: Change platform data for soc codec driver
Date: Mon, 13 Jun 2011 19:37:42 +0300
Message-ID: <1307983070-2257-11-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1307983070-2257-1-git-send-email-peter.ujfalusi@ti.com>
References: <1307983070-2257-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass twl4030_codec_data instead of the twl4030_audio_data
for the ASoC codec driver.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 195613c..b6e5338 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -507,9 +507,8 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
 	if (pdata->codec) {
 		cell = &twl6040->cells[children];
 		cell->name = "twl6040-codec";
-		/* The codec expects the twl4030_audio_data as platform data */
-		cell->platform_data = pdata;
-		cell->pdata_size = sizeof(*pdata);
+		cell->platform_data = pdata->codec;
+		cell->pdata_size = sizeof(*pdata->codec);
 		children++;
 	}
 
-- 
1.7.5.3


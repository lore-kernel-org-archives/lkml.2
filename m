Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935992Ab2C3VUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:20:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965892Ab2C3VUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:20:08 -0400
Message-Id: <20120330194837.193711239@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Timur Tabi <timur@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 067/175] ASoC: fsl: p1022ds: tell the WM8776 codec driver that its the master
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Tabi <timur@freescale.com>

commit 70ac07bb633dee75ac554195b9a4d69adfa7803c upstream.

The WM8776 codec driver requires the machine driver to set one of the
SND_SOC_DAIFMT_CBx_xxx values.  The P1022DS machine driver should be setting
SND_SOC_DAIFMT_CBM_CFM, but since that value was zero, no one noticed.

Commit 75d9ac46 ("ASoC: Allow DAI formats to be specified in the
dai_link"), however, changed the value of SND_SOC_DAIFMT_CBM_CFM from zero
to a non-zero value, which means that it now needs to be specifically set
by the machine driver.

We also set SND_SOC_DAIFMT_NB_NF, for the same reason.

Signed-off-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/fsl/p1022_ds.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/sound/soc/fsl/p1022_ds.c
+++ b/sound/soc/fsl/p1022_ds.c
@@ -395,7 +395,8 @@ static int p1022_ds_probe(struct platfor
 	}
 
 	if (strcasecmp(sprop, "i2s-slave") == 0) {
-		mdata->dai_format = SND_SOC_DAIFMT_I2S;
+		mdata->dai_format = SND_SOC_DAIFMT_NB_NF |
+			SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_CBM_CFM;
 		mdata->codec_clk_direction = SND_SOC_CLOCK_OUT;
 		mdata->cpu_clk_direction = SND_SOC_CLOCK_IN;
 
@@ -412,31 +413,38 @@ static int p1022_ds_probe(struct platfor
 		}
 		mdata->clk_frequency = be32_to_cpup(iprop);
 	} else if (strcasecmp(sprop, "i2s-master") == 0) {
-		mdata->dai_format = SND_SOC_DAIFMT_I2S;
+		mdata->dai_format = SND_SOC_DAIFMT_NB_NF |
+			SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_CBS_CFS;
 		mdata->codec_clk_direction = SND_SOC_CLOCK_IN;
 		mdata->cpu_clk_direction = SND_SOC_CLOCK_OUT;
 	} else if (strcasecmp(sprop, "lj-slave") == 0) {
-		mdata->dai_format = SND_SOC_DAIFMT_LEFT_J;
+		mdata->dai_format = SND_SOC_DAIFMT_NB_NF |
+			SND_SOC_DAIFMT_LEFT_J | SND_SOC_DAIFMT_CBM_CFM;
 		mdata->codec_clk_direction = SND_SOC_CLOCK_OUT;
 		mdata->cpu_clk_direction = SND_SOC_CLOCK_IN;
 	} else if (strcasecmp(sprop, "lj-master") == 0) {
-		mdata->dai_format = SND_SOC_DAIFMT_LEFT_J;
+		mdata->dai_format = SND_SOC_DAIFMT_NB_NF |
+			SND_SOC_DAIFMT_LEFT_J | SND_SOC_DAIFMT_CBS_CFS;
 		mdata->codec_clk_direction = SND_SOC_CLOCK_IN;
 		mdata->cpu_clk_direction = SND_SOC_CLOCK_OUT;
 	} else if (strcasecmp(sprop, "rj-slave") == 0) {
-		mdata->dai_format = SND_SOC_DAIFMT_RIGHT_J;
+		mdata->dai_format = SND_SOC_DAIFMT_NB_NF |
+			SND_SOC_DAIFMT_RIGHT_J | SND_SOC_DAIFMT_CBM_CFM;
 		mdata->codec_clk_direction = SND_SOC_CLOCK_OUT;
 		mdata->cpu_clk_direction = SND_SOC_CLOCK_IN;
 	} else if (strcasecmp(sprop, "rj-master") == 0) {
-		mdata->dai_format = SND_SOC_DAIFMT_RIGHT_J;
+		mdata->dai_format = SND_SOC_DAIFMT_NB_NF |
+			SND_SOC_DAIFMT_RIGHT_J | SND_SOC_DAIFMT_CBS_CFS;
 		mdata->codec_clk_direction = SND_SOC_CLOCK_IN;
 		mdata->cpu_clk_direction = SND_SOC_CLOCK_OUT;
 	} else if (strcasecmp(sprop, "ac97-slave") == 0) {
-		mdata->dai_format = SND_SOC_DAIFMT_AC97;
+		mdata->dai_format = SND_SOC_DAIFMT_NB_NF |
+			SND_SOC_DAIFMT_AC97 | SND_SOC_DAIFMT_CBM_CFM;
 		mdata->codec_clk_direction = SND_SOC_CLOCK_OUT;
 		mdata->cpu_clk_direction = SND_SOC_CLOCK_IN;
 	} else if (strcasecmp(sprop, "ac97-master") == 0) {
-		mdata->dai_format = SND_SOC_DAIFMT_AC97;
+		mdata->dai_format = SND_SOC_DAIFMT_NB_NF |
+			SND_SOC_DAIFMT_AC97 | SND_SOC_DAIFMT_CBS_CFS;
 		mdata->codec_clk_direction = SND_SOC_CLOCK_IN;
 		mdata->cpu_clk_direction = SND_SOC_CLOCK_OUT;
 	} else {



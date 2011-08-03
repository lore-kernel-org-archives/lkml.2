Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1HCX0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:26:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967Ab1HCXZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:25:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:46 2011
Message-Id: <20110803221246.133902001@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [021/102] ASoC: davinci: fix codec start and stop functions
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>

commit 3012f43eaf7592d8121426918e43e3b5db013aff upstream.

According to DM365 voice codec data sheet at [1], before starting
recording or playback, ADC/DAC modules should follow a reset and
enable cycle. Writing a 1 to the ADC/DAC bit in the register resets
the module and clearing the bit to 0 will enable the module. But the
driver seems to be doing the reverse of it.

[1] http://focus.ti.com/lit/ug/sprufi9b/sprufi9b.pdf

Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/davinci/davinci-vcif.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/davinci/davinci-vcif.c
+++ b/sound/soc/davinci/davinci-vcif.c
@@ -62,9 +62,9 @@ static void davinci_vcif_start(struct sn
 	w = readl(davinci_vc->base + DAVINCI_VC_CTRL);
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		MOD_REG_BIT(w, DAVINCI_VC_CTRL_RSTDAC, 1);
+		MOD_REG_BIT(w, DAVINCI_VC_CTRL_RSTDAC, 0);
 	else
-		MOD_REG_BIT(w, DAVINCI_VC_CTRL_RSTADC, 1);
+		MOD_REG_BIT(w, DAVINCI_VC_CTRL_RSTADC, 0);
 
 	writel(w, davinci_vc->base + DAVINCI_VC_CTRL);
 }
@@ -80,9 +80,9 @@ static void davinci_vcif_stop(struct snd
 	/* Reset transmitter/receiver and sample rate/frame sync generators */
 	w = readl(davinci_vc->base + DAVINCI_VC_CTRL);
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		MOD_REG_BIT(w, DAVINCI_VC_CTRL_RSTDAC, 0);
+		MOD_REG_BIT(w, DAVINCI_VC_CTRL_RSTDAC, 1);
 	else
-		MOD_REG_BIT(w, DAVINCI_VC_CTRL_RSTADC, 0);
+		MOD_REG_BIT(w, DAVINCI_VC_CTRL_RSTADC, 1);
 
 	writel(w, davinci_vc->base + DAVINCI_VC_CTRL);
 }



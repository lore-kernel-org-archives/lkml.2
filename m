Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab1DLRiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:38:00 -0400
Received: from smtp-out-051.synserver.de ([212.40.185.51]:1126 "HELO
	smtp-out-049.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S932255Ab1DLRh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:37:58 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24502
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 5/5] ASoC: JZ4740: qi_lb60: Use the SND_SOC_DAPM_EVENT_OFF for the speakers status
Date: Tue, 12 Apr 2011 19:31:05 +0200
Message-Id: <1302629465-21315-5-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1302629465-21315-1-git-send-email-lars@metafoo.de>
References: <1302629465-21315-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use SND_SOC_DAPM_EVENT_OFF for determining whether the speaker should be turned
on or off instead of open coding it.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/jz4740/qi_lb60.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/sound/soc/jz4740/qi_lb60.c b/sound/soc/jz4740/qi_lb60.c
index 8c4e84b..c5fc339 100644
--- a/sound/soc/jz4740/qi_lb60.c
+++ b/sound/soc/jz4740/qi_lb60.c
@@ -27,11 +27,7 @@
 static int qi_lb60_spk_event(struct snd_soc_dapm_widget *widget,
 			     struct snd_kcontrol *ctrl, int event)
 {
-	int on = 0;
-	if (event & SND_SOC_DAPM_POST_PMU)
-		on = 1;
-	else if (event & SND_SOC_DAPM_PRE_PMD)
-		on = 0;
+	int on = !SND_SOC_DAPM_EVENT_OFF(event);
 
 	gpio_set_value(QI_LB60_SND_GPIO, on);
 	gpio_set_value(QI_LB60_AMP_GPIO, on);
-- 
1.7.2.5


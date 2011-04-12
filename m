Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab1DLRhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:37:42 -0400
Received: from smtp-out-051.synserver.de ([212.40.185.51]:1077 "HELO
	smtp-out-049.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753590Ab1DLRhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:37:15 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24502
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/5] ASoC: JZ4740: Convert qi_lb60 codec to table based DAPM setup
Date: Tue, 12 Apr 2011 19:31:03 +0200
Message-Id: <1302629465-21315-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1302629465-21315-1-git-send-email-lars@metafoo.de>
References: <1302629465-21315-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced dapm_widgets, dpam_routes and fields of the
snd_soc_card struct to setup DAPM.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/jz4740/qi_lb60.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/sound/soc/jz4740/qi_lb60.c b/sound/soc/jz4740/qi_lb60.c
index 49723e3..875abc9 100644
--- a/sound/soc/jz4740/qi_lb60.c
+++ b/sound/soc/jz4740/qi_lb60.c
@@ -70,12 +70,6 @@ static int qi_lb60_codec_init(struct snd_soc_pcm_runtime *rtd)
 		return ret;
 	}
 
-	snd_soc_dapm_new_controls(dapm, qi_lb60_widgets,
-				  ARRAY_SIZE(qi_lb60_widgets));
-	snd_soc_dapm_add_routes(dapm, qi_lb60_routes,
-				ARRAY_SIZE(qi_lb60_routes));
-	snd_soc_dapm_sync(dapm);
-
 	return 0;
 }
 
@@ -93,6 +87,11 @@ static struct snd_soc_card qi_lb60 = {
 	.name = "QI LB60",
 	.dai_link = &qi_lb60_dai,
 	.num_links = 1,
+
+	.dapm_widgets = qi_lb60_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(qi_lb60_widgets),
+	.dapm_routes = qi_lb60_routes,
+	.num_dapm_routes = ARRAY_SIZE(qi_lb60_routes),
 };
 
 static struct platform_device *qi_lb60_snd_device;
-- 
1.7.2.5


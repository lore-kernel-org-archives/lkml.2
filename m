Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151Ab1HJEBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 00:01:18 -0400
Received: from smtp-out-003.synserver.de ([212.40.185.3]:1071 "HELO
	smtp-out-003.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750708Ab1HJEBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 00:01:16 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Aug 2011 00:01:16 EDT
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 28254
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/4] ASoC: DAPM: Allow multiple mixer sources to be routed via the same switch
Date: Wed, 10 Aug 2011 05:52:41 +0200
Message-Id: <1312948364-2587-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it is only possible to route one source per switch into a mixer.
This patch modifies the code, so that it is possible to route multiple sources
into a mixer via the same switch. One use-case for this is routing a stereo
channel pair into a mono-mixer via the same switch.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/soc-dapm.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index c265311..170c4ff 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -443,6 +443,11 @@ static int dapm_new_mixer(struct snd_soc_dapm_widget *w)
 			if (path->name != (char *)w->kcontrol_news[i].name)
 				continue;
 
+			if (w->kcontrols[i]) {
+				path->kcontrol = w->kcontrols[i];
+				continue;
+			}
+
 			wlistsize = sizeof(struct snd_soc_dapm_widget_list) +
 				    sizeof(struct snd_soc_dapm_widget *),
 			wlist = kzalloc(wlistsize, GFP_KERNEL);
@@ -1556,7 +1561,6 @@ static int dapm_mixer_update_power(struct snd_soc_dapm_widget *widget,
 		/* found, now check type */
 		found = 1;
 		path->connect = connect;
-		break;
 	}
 
 	if (found)
-- 
1.7.2.5


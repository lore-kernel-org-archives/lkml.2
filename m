Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab1HOSRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:17:40 -0400
Received: from smtp-out-020.synserver.de ([212.40.185.20]:1039 "HELO
	smtp-out-020.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750790Ab1HOSRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:17:39 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 10030
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/4] ASoC: DAPM: Allow multiple mixer sources to be routed via the same switch
Date: Mon, 15 Aug 2011 20:15:21 +0200
Message-Id: <1313432124-22591-1-git-send-email-lars@metafoo.de>
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


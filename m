Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab1DLRhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:37:24 -0400
Received: from smtp-out-051.synserver.de ([212.40.185.51]:1100 "HELO
	smtp-out-049.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1756226Ab1DLRhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:37:13 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24502
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/5] ASoC: Call snd_soc_new_widgets() after registering cards DAPM widgets
Date: Tue, 12 Apr 2011 19:31:02 +0200
Message-Id: <1302629465-21315-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1302629465-21315-1-git-send-email-lars@metafoo.de>
References: <1302629465-21315-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After registering new DAPM widgets nd_soc_new_widgets() must be called,
otherwise DAPM for those new widgets will not work.

snd_soc_new_widgets() is placed after the card late_probe call, so cards
can register new DAPM widgets in there.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/soc-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index f75f139..b6a78d9 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1932,6 +1932,8 @@ static void snd_soc_instantiate_card(struct snd_soc_card *card)
 		}
 	}
 
+	snd_soc_dapm_new_widgets(&card->dapm);
+
 	ret = snd_card_register(card->snd_card);
 	if (ret < 0) {
 		printk(KERN_ERR "asoc: failed to register soundcard for %s\n", card->name);
-- 
1.7.2.5


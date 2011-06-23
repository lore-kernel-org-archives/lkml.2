Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab1FWR3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:29:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:65215 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872Ab1FWR3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:29:45 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Mike Frysinger <vapier@gentoo.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 046/247] ASoC: Blackfin AC97: fix build error after multi-component update
Date: Thu, 23 Jun 2011 13:25:45 -0400
Message-Id: <1308850146-15061-5-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e9c2048915048d605fd76539ddd96f00d593e1eb upstream.

We need to tweak how we query the active capture/playback state after
the recent overhauls of common code.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/soc/blackfin/bf5xx-ac97.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/blackfin/bf5xx-ac97.c b/sound/soc/blackfin/bf5xx-ac97.c
index 523b7fc..b69cd4b 100644
--- a/sound/soc/blackfin/bf5xx-ac97.c
+++ b/sound/soc/blackfin/bf5xx-ac97.c
@@ -261,9 +261,9 @@ static int bf5xx_ac97_suspend(struct snd_soc_dai *dai)
 	pr_debug("%s : sport %d\n", __func__, dai->id);
 	if (!dai->active)
 		return 0;
-	if (dai->capture.active)
+	if (dai->capture_active)
 		sport_rx_stop(sport);
-	if (dai->playback.active)
+	if (dai->playback_active)
 		sport_tx_stop(sport);
 	return 0;
 }
-- 
1.7.4.4


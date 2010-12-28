Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab0L1JQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 04:16:35 -0500
Received: from smtp.nokia.com ([147.243.1.47]:23193 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab0L1JQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 04:16:33 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: tpa6130a2: Fix compiler warning
Date: Tue, 28 Dec 2010 11:16:19 +0200
Message-Id: <1293527779-32580-1-git-send-email-peter.ujfalusi@nokia.com>
X-Mailer: git-send-email 1.7.3.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sound/soc/codecs/tpa6130a2.c: In function 'tpa6130a2_add_controls':
sound/soc/codecs/tpa6130a2.c:342: warning: unused variable 'dapm'

Introduced by commit 39646871a47fd8808c08de0ce7d7ca8393af2805 ("ASoC:
tpa6130a2: Replace DAPM code with direct interface").

The DAPM code has been removed from the driver, but the
dapm struct remained.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
---
 sound/soc/codecs/tpa6130a2.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/tpa6130a2.c b/sound/soc/codecs/tpa6130a2.c
index 0a99f31..1f1ac81 100644
--- a/sound/soc/codecs/tpa6130a2.c
+++ b/sound/soc/codecs/tpa6130a2.c
@@ -339,7 +339,6 @@ EXPORT_SYMBOL_GPL(tpa6130a2_stereo_enable);
 int tpa6130a2_add_controls(struct snd_soc_codec *codec)
 {
 	struct	tpa6130a2_data *data;
-	struct snd_soc_dapm_context *dapm = &codec->dapm;
 
 	if (tpa6130a2_client == NULL)
 		return -ENODEV;
-- 
1.7.3.4


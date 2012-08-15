Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab2HOTt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:49:56 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62809 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab2HOTtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:52 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 042/165] ASoC: Fix reporting of partial jack updates
Date: Wed, 15 Aug 2012 15:46:26 -0400
Message-ID: <1345060109-9187-43-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 747da0f80e566500421bd7760b2e050fea3fde5e upstream.

We need to report the entire jack state to the core jack code, not just
the bits that were being updated by the caller, otherwise the status
reported by other detection methods will be omitted from the state seen
by userspace.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/soc/soc-jack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-jack.c b/sound/soc/soc-jack.c
index 3c07a94..f097755 100644
--- a/sound/soc/soc-jack.c
+++ b/sound/soc/soc-jack.c
@@ -95,7 +95,7 @@ void snd_soc_jack_report(struct snd_soc_jack *jack, int status, int mask)
 
 	snd_soc_dapm_sync(codec);
 
-	snd_jack_report(jack->jack, status);
+	snd_jack_report(jack->jack, jack->status);
 
 out:
 	mutex_unlock(&codec->mutex);
-- 
1.7.12.rc2


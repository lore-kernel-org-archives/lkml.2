Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab2HOUSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:18:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:36874 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab2HOTvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 087/165] ASoC: ak4642: fixup cache register table
Date: Wed, 15 Aug 2012 15:47:11 -0400
Message-ID: <1345060109-9187-88-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 19b115e523208a926813751aac8934cf3fc6085e upstream.

ak4642 register was 8bit, but cache table was defined as 16bit.
ak4642 doesn't work correctry without this patch.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/soc/codecs/ak4642.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index 729859c..858d476 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -94,17 +94,17 @@ static struct snd_soc_codec *ak4642_codec;
 /*
  * ak4642 register cache
  */
-static const u16 ak4642_reg[AK4642_CACHEREGNUM] = {
-	0x0000, 0x0000, 0x0001, 0x0000,
-	0x0002, 0x0000, 0x0000, 0x0000,
-	0x00e1, 0x00e1, 0x0018, 0x0000,
-	0x00e1, 0x0018, 0x0011, 0x0008,
-	0x0000, 0x0000, 0x0000, 0x0000,
-	0x0000, 0x0000, 0x0000, 0x0000,
-	0x0000, 0x0000, 0x0000, 0x0000,
-	0x0000, 0x0000, 0x0000, 0x0000,
-	0x0000, 0x0000, 0x0000, 0x0000,
-	0x0000,
+static const u8 ak4642_reg[AK4642_CACHEREGNUM] = {
+	0x00, 0x00, 0x01, 0x00,
+	0x02, 0x00, 0x00, 0x00,
+	0xe1, 0xe1, 0x18, 0x00,
+	0xe1, 0x18, 0x11, 0x08,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+	0x00,
 };
 
 /*
-- 
1.7.12.rc2


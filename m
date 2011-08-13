Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab1HMLPP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 07:15:15 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48835 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab1HMLPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 07:15:10 -0400
Subject: [PATCH] ASoC: soc-jack: Fix checking return value of
 request_any_context_irq
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Aug 2011 19:15:01 +0800
Message-ID: <1313234101.23974.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_any_context_irq() returns a negative value on failure.
On success, it returns either IRQC_IS_HARDIRQ or IRQC_IS_NESTED.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/soc-jack.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/soc-jack.c b/sound/soc/soc-jack.c
index 7c17b98..38b0013 100644
--- a/sound/soc/soc-jack.c
+++ b/sound/soc/soc-jack.c
@@ -327,7 +327,7 @@ int snd_soc_jack_add_gpios(struct snd_soc_jack *jack, int count,
 					      IRQF_TRIGGER_FALLING,
 					      gpios[i].name,
 					      &gpios[i]);
-		if (ret)
+		if (ret < 0)
 			goto err;
 
 		if (gpios[i].wake) {
-- 
1.7.4.1




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab2LMORJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:17:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45176 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933358Ab2LMOPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:15:23 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 236/241] ASoC: dmaengine: Correct Makefile when sound is built as module
Date: Thu, 13 Dec 2012 12:00:01 -0200
Message-Id: <1355407206-17100-237-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit 961a7aeafab477f63d9eef26afde9cbb8badcd0f upstream.

soc-dmaengine-pcm library need to be part of the snd-soc-core in order to
be able to compile ASoC as modules when dmaengine is enabled on the platform.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/soc/Makefile |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/Makefile b/sound/soc/Makefile
index 70990f4..7fda792 100644
--- a/sound/soc/Makefile
+++ b/sound/soc/Makefile
@@ -1,8 +1,9 @@
 snd-soc-core-objs := soc-core.o soc-dapm.o soc-jack.o soc-cache.o soc-utils.o
 snd-soc-core-objs += soc-pcm.o soc-io.o
 
-snd-soc-dmaengine-pcm-objs := soc-dmaengine-pcm.o
-obj-$(CONFIG_SND_SOC_DMAENGINE_PCM) += snd-soc-dmaengine-pcm.o
+ifneq ($(CONFIG_SND_SOC_DMAENGINE_PCM),)
+snd-soc-core-objs += soc-dmaengine-pcm.o
+endif
 
 obj-$(CONFIG_SND_SOC)	+= snd-soc-core.o
 obj-$(CONFIG_SND_SOC)	+= codecs/
-- 
1.7.9.5


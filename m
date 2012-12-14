Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab2LNXCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:02:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:40460 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932658Ab2LNXCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:02:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Florian Fainelli <florian@openwrt.org>
Subject: [ 05/37] ASoC: dmaengine: Correct Makefile when sound is built as module
Date: Fri, 14 Dec 2012 15:00:42 -0800
Message-Id: <20121214222254.000522007@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222252.781413287@linuxfoundation.org>
References: <20121214222252.781413287@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit 961a7aeafab477f63d9eef26afde9cbb8badcd0f upstream.

soc-dmaengine-pcm library need to be part of the snd-soc-core in order to
be able to compile ASoC as modules when dmaengine is enabled on the platform.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/Makefile |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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



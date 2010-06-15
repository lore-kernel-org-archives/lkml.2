Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab0FOPjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 11:39:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:59228 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932379Ab0FOPjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 11:39:00 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX190Tb10GX10OahueXGfgl3otiMt5egemUUpAAFNxI
	BHYCUu2Q/GiM6g
From: Peter Huewe <PeterHuewe@gmx.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH v2] soc/sh: Fix I2C dependency for SND_FSI_AK4642 and SND_FSI_DA7210
Date: Tue, 15 Jun 2010 17:38:55 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-sh@vger.kernel.org,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
References: <201006141739.42346.PeterHuewe@gmx.de> <201006151649.07554.PeterHuewe@gmx.de> <20100615151913.GJ14510@rakim.wolfsonmicro.main>
In-Reply-To: <20100615151913.GJ14510@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006151738.56143.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

The config option SND_FSI_AK4642 selects SND_SOC_AK4642 which in turn
enables the compilation of ak4642.c - however this codec uses I2C to
communicate with the HW.
Same applies to DA7210.

Consequently when I2C is not set, the compilation fails [1]

This patch fixes this issues, by adding a depencdency on the related HW-
controller.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
How about this one?

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2709408/
KernelVersion: linux-next 20100615

 sound/soc/sh/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sh/Kconfig b/sound/soc/sh/Kconfig
index a1d14bc..52d7e8e 100644
--- a/sound/soc/sh/Kconfig
+++ b/sound/soc/sh/Kconfig
@@ -48,7 +48,7 @@ config SND_SH7760_AC97
 
 config SND_FSI_AK4642
 	bool "FSI-AK4642 sound support"
-	depends on SND_SOC_SH4_FSI
+	depends on SND_SOC_SH4_FSI && I2C_SH_MOBILE
 	select SND_SOC_AK4642
 	help
 	  This option enables generic sound support for the
@@ -56,7 +56,7 @@ config SND_FSI_AK4642
 
 config SND_FSI_DA7210
 	bool "FSI-DA7210 sound support"
-	depends on SND_SOC_SH4_FSI
+	depends on SND_SOC_SH4_FSI && I2C_SH_MOBILE
 	select SND_SOC_DA7210
 	help
 	  This option enables generic sound support for the
-- 
1.6.4.4


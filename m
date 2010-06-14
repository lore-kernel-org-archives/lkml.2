Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab0FNPjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:39:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:42388 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752901Ab0FNPjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:39:44 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/I1rJPtUzIion6ctk7t1wLcV4vymMhQpjtX3JA21
	4p0Bb6sY3VM7qd
From: Peter Huewe <PeterHuewe@gmx.de>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH] soc/sh: Fix I2C dependency for SND_FSI_AK4642
Date: Mon, 14 Jun 2010 17:39:41 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: linux-sh@vger.kernel.org, Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141739.42346.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

The config option SND_FSI_AK4642 selects SND_SOC_AK464 which in turn
enables the compilation of ak4642.c - however this codec uses I2C to
communicate with the HW.

Consequently when I2C is not set, the compilation fails [1]

This patch fixes this issues.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2709408/
KernelVersion: linux-next 20100614

 sound/soc/sh/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/sh/Kconfig b/sound/soc/sh/Kconfig
index a1d14bc..d26b815 100644
--- a/sound/soc/sh/Kconfig
+++ b/sound/soc/sh/Kconfig
@@ -50,6 +50,7 @@ config SND_FSI_AK4642
 	bool "FSI-AK4642 sound support"
 	depends on SND_SOC_SH4_FSI
 	select SND_SOC_AK4642
+	select I2C
 	help
 	  This option enables generic sound support for the
 	  FSI - AK4642 unit
-- 
1.6.4.4


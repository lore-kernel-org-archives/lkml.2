Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab1CUPhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 11:37:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45203 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab1CUPhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 11:37:37 -0400
Date: Mon, 21 Mar 2011 16:37:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: [build failure] Re: [GIT PULL] sound updates for 2.6.39-rc1
Message-ID: <20110321153719.GA12325@elte.hu>
References: <s5hr5a4ttfi.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hr5a4ttfi.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Takashi Iwai <tiwai@suse.de> wrote:

> Linus,
> 
> please pull sound updates for v2.6.39-rc1 from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git for-linus

This build failure:

sound/built-in.o: In function `ldo_regulator_remove':
sgtl5000.c:(.text+0x82678): undefined reference to `regulator_unregister'
sound/built-in.o: In function `ldo_regulator_is_enabled':
sgtl5000.c:(.text+0x826c5): undefined reference to `rdev_get_drvdata'
sound/built-in.o: In function `ldo_regulator_disable':
sgtl5000.c:(.text+0x826ef): undefined reference to `rdev_get_drvdata'
sound/built-in.o: In function `ldo_regulator_enable':
sgtl5000.c:(.text+0x82756): undefined reference to `rdev_get_drvdata'
sound/built-in.o: In function `ldo_regulator_get_voltage':
sgtl5000.c:(.text+0x82815): undefined reference to `rdev_get_drvdata'
sound/built-in.o: In function `sgtl5000_probe':

has been pushed upstream - although the build breakage was reported against 
linux-next two weeks ago, with fix provided, in this lkml thread:

  [PATCH -next] soc: sgtl5000 uses regulator interfaces

Please do not push known-broken code upstream.

Randy's fix below resolved the bug for me.

Thanks,

	Ingo

--------------------->
>From 8c7c9a0622d5b1955628961ae193c12d948c1871 Mon Sep 17 00:00:00 2001
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Fri, 4 Mar 2011 17:33:57 -0800
Subject: [PATCH] soc: Sgtl5000 uses regulator interfaces

sgtl5000 uses regulator interfaces, so make selecting it depend
on REGULATOR.

 sgtl5000.c:(.text+0x4ae33): undefined reference to `regulator_unregister'
 sgtl5000.c:(.text+0x4af41): undefined reference to `rdev_get_drvdata'
 sgtl5000.c:(.text+0x4b191): undefined reference to `regulator_register'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Zeng Zhaoming <zhaoming.zeng@freescale.com>
LKML-Reference: <20110304173357.23d36116.randy.dunlap@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 sound/soc/codecs/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index d63c175..84818f5 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -36,7 +36,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_MAX9850 if I2C
 	select SND_SOC_MAX9877 if I2C
 	select SND_SOC_PCM3008
-	select SND_SOC_SGTL5000 if I2C
+	select SND_SOC_SGTL5000 if I2C && REGULATOR
 	select SND_SOC_SN95031 if INTEL_SCU_IPC
 	select SND_SOC_SPDIF
 	select SND_SOC_SSM2602 if I2C

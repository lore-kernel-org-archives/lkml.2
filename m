Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab1JCNna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:43:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51118 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab1JCNn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:43:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        linux-kernel@vger.kernel.org, "'Liam Girdwood'" <lrg@ti.com>
Subject: [PATCH 5/6] ASoC: samsung: wm8994 depends on mfd_wm8994
Date: Mon, 03 Oct 2011 15:43:10 +0200
Message-ID: <11174515.ANsqIhx0NX@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20111003120741.GD23811@sirena.org.uk>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de> <1869072.QQLATNzYYx@wuerfel> <20111003120741.GD23811@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Yf89Dj60vSporU/ytQwytU1ug0zXqvUuJbVKA9Ntp6U
 orYZYwMgnTWcrENFijPNsM+TPYAOP1AVscNg/Feu8arjW+DQtI
 JFTnH53mP/6h+RSgG1wGGVe/zKm7YoyojU2bzrTEmGlsQSoGsF
 LDelvM9v4ClxevtSu6l/nGNJ47LbcfoZiVsKq93HDathOGMUlY
 VtVmP6qpipYseYfKVZ6xhnXB2rDEpFOTEav/d0jRgAmSlQSeDp
 iky5XlMQf93LT+Q85pbYsUeakJeCF0ZgVUn9++LTGGl+dCuGcI
 Im4NCqyLQBpl+WlzxidHAh2egjzPucq1T/pE4L8pM3KZEE5tg5
 3hJaNaS9eXezZiW+elOU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any driver that selects SND_SOC_WM8994 should also make sure that
MFD_WM8994 is set, since the codec relies on the mfd code:

  sound/built-in.o: In function `wm8994_read':
  last.c:(.text+0x20160): undefined reference to `wm8994_reg_read'
  sound/built-in.o: In function `wm8994_write':
  last.c:(.text+0x20e68): undefined reference to `wm8994_reg_write'

This adds the missing 'depends' statements to Kconfig, as found
during ARM randconfig tests.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 sound/soc/samsung/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

On Monday 03 October 2011 13:07:41 Mark Brown wrote:
> On Mon, Oct 03, 2011 at 01:50:08PM +0200, Arnd Bergmann wrote:
> 
> > the patch. The other problem in this patch is still there, with
> > CONFIG_SND_SOC_SMDK_WM8994_PCM=y and CONFIG_MFD_WM8994=n:
> 
> You've not sent a seprate patch for that one yet...

I wasn't sure any more which version you wanted. Is this this right one?

--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -65,6 +65,7 @@ config SND_SOC_SAMSUNG_SMDK_WM8580
 config SND_SOC_SAMSUNG_SMDK_WM8994
 	tristate "SoC I2S Audio support for WM8994 on SMDK"
 	depends on SND_SOC_SAMSUNG && (MACH_SMDKV310 || MACH_SMDKC210)
+	depends on MFD_WM8994
 	select SND_SOC_WM8994
 	select SND_SAMSUNG_I2S
 	help
@@ -152,6 +153,7 @@ config SND_SOC_GONI_AQUILA_WM8994
 	tristate "SoC I2S Audio support for AQUILA/GONI - WM8994"
 	depends on SND_SOC_SAMSUNG && (MACH_GONI || MACH_AQUILA)
 	select SND_SAMSUNG_I2S
+	depends on MFD_WM8994
 	select SND_SOC_WM8994
 	help
 	  Say Y if you want to add support for SoC audio on goni or aquila
@@ -175,6 +177,7 @@ config SND_SOC_SMDK_WM8580_PCM
 config SND_SOC_SMDK_WM8994_PCM
 	tristate "SoC PCM Audio support for WM8994 on SMDK"
 	depends on SND_SOC_SAMSUNG && (MACH_SMDKC210 || MACH_SMDKV310)
+	depends on MFD_WM8994
 	select SND_SOC_WM8994
 	select SND_SAMSUNG_PCM
 	help

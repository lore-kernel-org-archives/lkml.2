Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab1JBU3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:29:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64188 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1JBU3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:29:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Jassi Brar <jassisinghbrar@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>
Subject: [PATCH 5/6] ASoC: samsung: fix Kconfig dependencies
Date: Sun,  2 Oct 2011 22:28:03 +0200
Message-Id: <1317587284-2776-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317587284-2776-1-git-send-email-arnd@arndb.de>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:WV0c/brfqrzKtfgWTCStKJVsyiSW1EXCpjKFr15dnXc
 mzTmoOkUaI4bjjS3xUmScon0UzKGfkblN7jbvXe11sISiUe7d7
 go5UmKhVANPT3Vg5bxUnEMOtQ+QxPpa+TkGWXCVfqCwAk6XBwu
 Wa9MKVObhIXbGqCX6swZx3bUuynirBsIKf4BmSrOO3xF8Yn8T+
 TtkkWos1u0rrZuDtcIRzMeJThDoCb/6Juk2x/MxS2iGhOLRPZf
 S/e63iyQ6BptIKT5SN8jRtxu5d39esHEJw86rD4NfBDDVTCHj/
 9HSUeUVYDqewdMOiQ4YDeYPdWvGhk/9+qtPnucOWApzXoULIkI
 xJEoJ2Q0ngJNLCq4h+CPjUAZEQOI7s3uD0hHGxqc09mYOuJowt
 lhclgU2bA4Ipw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SND_SOC_WM8994 can only be selected if the respective MFD driver is
present.

SND_SAMSUNG_AC97 must not be builtin if SND_SOC_ALL_CODECS is
set to building all drivers as modules.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>
---
 sound/soc/samsung/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index 65f980e..cb63cd0 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -25,6 +25,7 @@ config SND_SAMSUNG_PCM
 
 config SND_SAMSUNG_AC97
 	tristate
+	depends on SND_SOC_ALL_CODECS=n || SND_SOC_ALL_CODECS
 	select SND_SOC_AC97_BUS
 
 config SND_SAMSUNG_SPDIF
@@ -64,6 +65,7 @@ config SND_SOC_SAMSUNG_SMDK_WM8580
 config SND_SOC_SAMSUNG_SMDK_WM8994
 	tristate "SoC I2S Audio support for WM8994 on SMDK"
 	depends on SND_SOC_SAMSUNG && (MACH_SMDKV310 || MACH_SMDKC210)
+	depends on MFD_WM8994
 	select SND_SOC_WM8994
 	select SND_SAMSUNG_I2S
 	help
@@ -151,6 +153,7 @@ config SND_SOC_GONI_AQUILA_WM8994
 	tristate "SoC I2S Audio support for AQUILA/GONI - WM8994"
 	depends on SND_SOC_SAMSUNG && (MACH_GONI || MACH_AQUILA)
 	select SND_SAMSUNG_I2S
+	depends on MFD_WM8994
 	select SND_SOC_WM8994
 	help
 	  Say Y if you want to add support for SoC audio on goni or aquila
@@ -174,6 +177,7 @@ config SND_SOC_SMDK_WM8580_PCM
 config SND_SOC_SMDK_WM8994_PCM
 	tristate "SoC PCM Audio support for WM8994 on SMDK"
 	depends on SND_SOC_SAMSUNG && (MACH_SMDKC210 || MACH_SMDKV310)
+	depends on MFD_WM8994
 	select SND_SOC_WM8994
 	select SND_SAMSUNG_PCM
 	help
-- 
1.7.5.4


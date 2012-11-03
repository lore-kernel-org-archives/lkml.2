Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab2KCWEj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 18:04:39 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51761 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab2KCWCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 18:02:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: [PATCH 5/9] ASoC: Only compile adav80x codec when a bus is defined
Date: Sat,  3 Nov 2012 23:02:26 +0100
Message-Id: <1351980150-24145-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If !CONFIG_SPI and !CONFIG_I2C* then there is no point adding support
for the adav80x codec as it relies on a bus to operate. This patch
fixes the build warnings below when SPI and I2C are not specified in
the configuration.

sound/soc/codecs/adav80x.c:842:22: warning: ‘adav80x_bus_probe’ defined but not used [-Wunused-function]
sound/soc/codecs/adav80x.c:863:22: warning: ‘adav80x_bus_remove’ defined but not used [-Wunused-function]

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/codecs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index b92759a..0d8135a 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -19,7 +19,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_AD1980 if SND_SOC_AC97_BUS
 	select SND_SOC_AD73311
 	select SND_SOC_ADAU1373 if I2C
-	select SND_SOC_ADAV80X
+	select SND_SOC_ADAV80X if (I2C || I2C_MODULE || SPI_MASTER)
 	select SND_SOC_ADS117X
 	select SND_SOC_AK4104 if SPI_MASTER
 	select SND_SOC_AK4535 if I2C
-- 
1.7.9.5


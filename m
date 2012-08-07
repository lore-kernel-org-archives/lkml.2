Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031146Ab2HGW6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:58:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33320 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031026Ab2HGWpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:45:33 -0400
From: Matt Sealey <matt@genesi-usa.com>
To: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Cc: Steev Klimaszewski <steev@genesi-usa.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Sealey <matt@genesi-usa.com>, Shawn Guo <shawn.guo@linaro.org>,
        Dave Martin <dave.martin@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: [PATCH 2/2] ARM: only build ssi-fiq.S et al if CONFIG_SND_IMX_SOC_PCM_FIQ is selected
Date: Tue,  7 Aug 2012 17:45:14 -0500
Message-Id: <1344379514-30076-3-git-send-email-matt@genesi-usa.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344379514-30076-1-git-send-email-matt@genesi-usa.com>
References: <1344379514-30076-1-git-send-email-matt@genesi-usa.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further to the previous patch, a custom configuration may be used based on the
imx_v6_v7_defconfig which removes the board depending on the audio driver pulling
this support code. However, since it is built dependent on CONFIG_SND_IMX_SOC
it is enabled in the build for all i.MX processors which enable any audio drivers.

Correct this by only building the SSI FIQ support code when the more specific
CONFIG_SND_IMX_SOC_PCM_FIQ is enabled. Since it's enabled in the imx_v6_v7_defconfig
anyway by the Eukrea board, nothing changes using the defconfig, so this is just
a convenience for people reconfiguring their kernels more sparsely than the default.

Signed-off-by: Matt Sealey <matt@genesi-usa.com>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
---
 arch/arm/plat-mxc/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-mxc/Makefile b/arch/arm/plat-mxc/Makefile
index 6ac7200..89927f5 100644
--- a/arch/arm/plat-mxc/Makefile
+++ b/arch/arm/plat-mxc/Makefile
@@ -16,7 +16,7 @@ obj-$(CONFIG_MXC_USE_EPIT) += epit.o
 obj-$(CONFIG_MXC_DEBUG_BOARD) += 3ds_debugboard.o
 obj-$(CONFIG_CPU_FREQ_IMX)    += cpufreq.o
 obj-$(CONFIG_CPU_IDLE) += cpuidle.o
-ifdef CONFIG_SND_IMX_SOC
+ifdef CONFIG_SND_IMX_SOC_PCM_FIQ
 obj-y += ssi-fiq.o
 obj-y += ssi-fiq-ksym.o
 endif
-- 
1.7.9.5


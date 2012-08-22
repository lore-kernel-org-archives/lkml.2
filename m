Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab2HVPNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:13:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57091 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430Ab2HVPNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:13:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Sascha Hauer <s.hauer@pengutronix.de>,
        Yong Shen <yong.shen@linaro.org>, Shawn Guo <shawn.guo@freescale.com>,
        stable@vger.kernel.org
Subject: [PATCH 5/6] ARM: imx: select CPU_FREQ_TABLE when needed
Date: Wed, 22 Aug 2012 17:13:09 +0200
Message-Id: <1345648390-4234-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1345648390-4234-1-git-send-email-arnd@arndb.de>
References: <1345648390-4234-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ep2N/tGmTBp7/a1EBlIvHkFAlJ1HmtkwU8yJSgmeN3D
 Dov8OQFncSjj6eLUne9VHjJ59iZseFSTBMwCi0APtH8PXxBDUt
 pjOcFSJgqkJ2Wovfl9GHk8D0WgeYQYfqh/8IrdNAY77J5+BCzX
 BAV5CiGFP3UcOEUJslw6JTpxGEzTux7OGU9RMFwEZpaLPweu0R
 Ts7m4dPzSKNyGGnKzTufpsZ2mzhs/s7DSNaZ+whI6E/jF2vJzA
 XJPFcgpv2mwQP9RDZdUefiJQkGq+ULHxKBeEdxrxOyQxAtVSJT
 lVuQuyexdigtxg/hu/w9m6Y0IKcJxCAqojRE2NSuQRvoItTRin
 CNyFTk6YxMgO2/8FYOwkdVL9NOV6TIAdZgfTyXdT8cFhvMtd1c
 YNs56h2+2rXgg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i.MX cpufreq implementation uses the CPU_FREQ_TABLE helpers,
so it needs to select that code to be built. This problem has
apparently existed since the i.MX cpufreq code was first merged
in v3.6.37.

Building IMX without CPU_FREQ_TABLE results in:

arch/arm/plat-mxc/built-in.o: In function `mxc_cpufreq_exit':
arch/arm/plat-mxc/cpufreq.c:173: undefined reference to `cpufreq_frequency_table_put_attr'
arch/arm/plat-mxc/built-in.o: In function `mxc_set_target':
arch/arm/plat-mxc/cpufreq.c:84: undefined reference to `cpufreq_frequency_table_target'
arch/arm/plat-mxc/built-in.o: In function `mxc_verify_speed':
arch/arm/plat-mxc/cpufreq.c:65: undefined reference to `cpufreq_frequency_table_verify'
arch/arm/plat-mxc/built-in.o: In function `mxc_cpufreq_init':
arch/arm/plat-mxc/cpufreq.c:154: undefined reference to `cpufreq_frequency_table_cpuinfo'
arch/arm/plat-mxc/cpufreq.c:162: undefined reference to `cpufreq_frequency_table_get_attr'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Yong Shen <yong.shen@linaro.org>
Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: stable@vger.kernel.org
---
 arch/arm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e91c7cd..84b5a0c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2150,6 +2150,7 @@ source "drivers/cpufreq/Kconfig"
 config CPU_FREQ_IMX
 	tristate "CPUfreq driver for i.MX CPUs"
 	depends on ARCH_MXC && CPU_FREQ
+	select CPU_FREQ_TABLE
 	help
 	  This enables the CPUfreq driver for i.MX CPUs.
 
-- 
1.7.10


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab2IQAua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33375 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033Ab2IQAth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:37 -0400
Message-Id: <20120917003628.725374376@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arnd Bergmann <arnd@arndb.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Yong Shen <yong.shen@linaro.org>
Subject: [ 018/135] ARM: imx: select CPU_FREQ_TABLE when needed
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit f637c4c9405e21f44cf0045eaf77eddd3a79ca5a upstream.

The i.MX cpufreq implementation uses the CPU_FREQ_TABLE helpers,
so it needs to select that code to be built. This problem has
apparently existed since the i.MX cpufreq code was first merged
in v2.6.37.

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
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Yong Shen <yong.shen@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
 



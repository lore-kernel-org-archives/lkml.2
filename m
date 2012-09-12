Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263Ab2ILXze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:55:34 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50638 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab2ILXnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:43:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Yong Shen <yong.shen@linaro.org>
Subject: [ 08/46] ARM: imx: select CPU_FREQ_TABLE when needed
Date: Wed, 12 Sep 2012 16:38:58 -0700
Message-Id: <20120912233818.529389627@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1875,6 +1875,7 @@ source "drivers/cpufreq/Kconfig"
 config CPU_FREQ_IMX
 	tristate "CPUfreq driver for i.MX CPUs"
 	depends on ARCH_MXC && CPU_FREQ
+	select CPU_FREQ_TABLE
 	help
 	  This enables the CPUfreq driver for i.MX CPUs.
 



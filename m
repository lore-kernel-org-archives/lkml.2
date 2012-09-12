Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab2ILXbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:31:23 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64398 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab2ILXbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:31:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [ 014/108] ARM: imx: build pm-imx5 code only when PM is enabled
Date: Wed, 12 Sep 2012 16:28:12 -0700
Message-Id: <20120912232452.008431867@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit a28eecef8ac2671dce7d892165bf374eeaa04e15 upstream.

This moves the imx5 pm code out of the list of unconditionally
compiled files for imx5, mirroring what we already do for imx6
and how it was done before the code was move from mach-mx5 to
mach-imx in v3.3.

Without this patch, building with CONFIG_PM disabled results in:

arch/arm/mach-imx/pm-imx5.c:202:116: error: redefinition of 'imx51_pm_init'
arch/arm/mach-imx/include/mach-imx/common.h:154:91: note: previous definition of 'imx51_pm_init' was here
arch/arm/mach-imx/pm-imx5.c:209:116: error: redefinition of 'imx53_pm_init'
arch/arm/mach-imx/include/mach-imx/common.h:155:91: note: previous definition of 'imx53_pm_init' was here

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -9,7 +9,8 @@ obj-$(CONFIG_SOC_IMX27) += clk-imx27.o m
 obj-$(CONFIG_SOC_IMX31) += mm-imx3.o cpu-imx31.o clk-imx31.o iomux-imx31.o ehci-imx31.o pm-imx3.o
 obj-$(CONFIG_SOC_IMX35) += mm-imx3.o cpu-imx35.o clk-imx35.o ehci-imx35.o pm-imx3.o
 
-obj-$(CONFIG_SOC_IMX5) += cpu-imx5.o mm-imx5.o clk-imx51-imx53.o ehci-imx5.o pm-imx5.o cpu_op-mx51.o
+imx5-pm-$(CONFIG_PM) += pm-imx5.o
+obj-$(CONFIG_SOC_IMX5) += cpu-imx5.o mm-imx5.o clk-imx51-imx53.o ehci-imx5.o $(imx5-pm-y) cpu_op-mx51.o
 
 obj-$(CONFIG_COMMON_CLK) += clk-pllv1.o clk-pllv2.o clk-pllv3.o clk-gate2.o \
 			    clk-pfd.o clk-busy.o



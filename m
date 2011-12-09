Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab1LICnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 21:43:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53113 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab1LICnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 21:43:02 -0500
From: Shawn Guo <shawn.guo@linaro.org>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: Richard Zhao <richard.zhao@freescale.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] arm/imx: fix cpufreq build error
Date: Fri,  9 Dec 2011 10:50:55 +0800
Message-Id: <1323399055-31850-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20111209020948.GA28216@b20223-02.ap.freescale.net>
References: <20111209020948.GA28216@b20223-02.ap.freescale.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing linux/module.h to fix the build error seen
on imx cpuidle driver.

  CC      arch/arm/plat-mxc/cpufreq.o
arch/arm/plat-mxc/cpufreq.c:203: error: expected declaration specifiers or '...' before string constant
arch/arm/plat-mxc/cpufreq.c:203: warning: data definition has no type or storage class
arch/arm/plat-mxc/cpufreq.c:203: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
arch/arm/plat-mxc/cpufreq.c:203: warning: function declaration isn't a prototype
arch/arm/plat-mxc/cpufreq.c:204: error: expected declaration specifiers or '...' before string constant
arch/arm/plat-mxc/cpufreq.c:204: warning: data definition has no type or storage class
arch/arm/plat-mxc/cpufreq.c:204: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
arch/arm/plat-mxc/cpufreq.c:204: warning: function declaration isn't a prototype
arch/arm/plat-mxc/cpufreq.c:205: error: expected declaration specifiers or '...' before string constant
arch/arm/plat-mxc/cpufreq.c:205: warning: data definition has no type or storage class
arch/arm/plat-mxc/cpufreq.c:205: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
arch/arm/plat-mxc/cpufreq.c:205: warning: function declaration isn't a prototype
make[1]: *** [arch/arm/plat-mxc/cpufreq.o] Error 1
make: *** [arch/arm/plat-mxc] Error 2

Reported-by: Richard Zhao <richard.zhao@freescale.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 arch/arm/plat-mxc/cpufreq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-mxc/cpufreq.c b/arch/arm/plat-mxc/cpufreq.c
index 74aac96..e3073be 100644
--- a/arch/arm/plat-mxc/cpufreq.c
+++ b/arch/arm/plat-mxc/cpufreq.c
@@ -20,6 +20,7 @@
 #include <linux/cpufreq.h>
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <mach/hardware.h>
 #include <mach/clock.h>
-- 
1.7.4.1


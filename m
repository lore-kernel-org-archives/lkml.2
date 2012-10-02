Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab2JBQh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:37:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64725 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab2JBQhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 09/17] ARM: imx: select ARM_CPU_SUSPEND if necessary
Date: Tue,  2 Oct 2012 18:36:48 +0200
Message-Id: <1349195816-2225-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349195816-2225-1-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:pn/anpJJPD5ZXVH0eq/2sxgL77p+4Kk2Rca+iNfALy+
 9EYsADEkHVXlv0Y7YjU6bXoF6RHdNc5yH2ch8tgJ90rBnwwTKl
 McCZnpNkmqbOsSjyzpn6qisaPGRsuxYjwHSRm5P6fZkNYbGth/
 NqRsBNYqb0sEYukPq4xDM9ZVS0aOToD5J+UGWJ3Y7cy/iqbq5o
 ygNYDDn7jya8fZ89EWJcZglH0pJ0suUkBT4LJE7IivoVKX18zv
 vohZHbD7w1sIWU2sV9LG4mhrMLLgyy968wWb9Iep8Co2KU1zO7
 t+8SZsxt6L7Qi5BjGA5jI2k7Pi0L+3ZNN1B/EPABmE595b871l
 1e5ZudsqKqJILTOwiI9PIIUMkBDLekWIn/zNXnUNDMg8iLIrOL
 InSZCwckcqphw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As tests using 'make randconfig' showed, imx5 requires the same logic
as imx6 to select ARM_CPU_SUSPEND when building with power management
enabled.

The defconfig does not have this problem because it enables imx6
as well, but disabling it leads to this warning:

arch/arm/mach-imx/built-in.o: In function `v7_cpu_resume':
arch/arm/mach-imx/head-v7.S:104: undefined reference to `cpu_resume'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
---
 arch/arm/mach-imx/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index afd542a..8e96573 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -89,6 +89,7 @@ config SOC_IMX5
 	select ARCH_MXC_IOMUX_V3
 	select ARCH_HAS_CPUFREQ
 	select ARCH_MX5
+	select ARM_CPU_SUSPEND if PM
 	bool
 
 config SOC_IMX50
-- 
1.7.10


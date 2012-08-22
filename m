Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab2HVPO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:14:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59936 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab2HVPNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:13:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Eric Miao <eric.miao@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>, stable@vger.kernel.org
Subject: [PATCH 6/6] ARM: imx: select ARM_CPU_SUSPEND when necessary
Date: Wed, 22 Aug 2012 17:13:10 +0200
Message-Id: <1345648390-4234-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1345648390-4234-1-git-send-email-arnd@arndb.de>
References: <1345648390-4234-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:OD1Me6i0W/zZ4Y+z8kxaSc57hzfBVZnnNRQRl3795Nm
 1YrYqFPukLnSOo7ESkJnf6Ehy4TsNVSgd9cgewUk/osRMHoiwq
 Ty3zudlbovXIJjuo5XraqDRD3dWeg76WLEMU3tHsn7kye4yngv
 gmiZ214gYl9qYY/6OmL0xQjyrCFXm5yK7vBtEsCBY3kUn1T/3u
 terMvVWR+pbRuuQm0WDSzSrlm74QrB/AXtLB7WL7lasjUlX7EQ
 C4a5ht1OkeRKKf9kceti/m4fdyX2ehL2OMG191ds8Sw8Sfeaor
 Us3UKTDxfUSwIocyGirr293nvMEYMTJX+cOm8zDjPyyhvvHW0N
 GFLm6tu3fIzJlrxANNzPI8xDWzSF/pj4+8PLpySbVcx+/ixG/p
 GCw4nhc7pvLCA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On i.MX6, we select ARM_CPU_SUSPEND when building with power management
support, but for some reason this was omitted on i.MX5. Normally we
build kernels for both together so the error only showed up in
randconfig tests.

Without this patch, building imx5 standalone results in:

arch/arm/mach-imx/built-in.o: In function `v7_cpu_resume':
arch/arm/mach-imx/head-v7.S:104: undefined reference to `cpu_resume'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Miao <eric.miao@linaro.org>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: stable@vger.kernel.org
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


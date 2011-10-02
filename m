Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab1JBOuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:50:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51780 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab1JBOrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:47:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 30/30] ARM: omap2: select ARM_AMBA for OMAP3_EMU
Date: Sun,  2 Oct 2011 16:46:00 +0200
Message-Id: <1317566760-25681-31-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:o7m8A3KaaYdX21ztWg9FuvL7C/e55zmKloR7x0e/Q/x
 aguCB3QJnNSdUrPk49QmeHRqfmMuJN6Nhs5TNl70pKr4dTP+fy
 FEkpm1maLmjpxc/R1SxTfFUmqUJLkYW9/ICzT7+30cvh6rCAqJ
 MonMwjJK2UL7NY20zDKLU8E56BzPIacJQLBrqOcqZhhcKOivIx
 tgFgEAg9eNZpqXISymDvKy0ttQQLi7Uj/9kz0dfCvUavCJ+gCG
 H0U18U2lOssjLOB/2Mp71u07ASZ4LMY6J/U0ow1L2/UdKAPMET
 okR+XZ3UIbx83ydCPAjVj3IAb7gEASpBs6w7JJYzdtAC/CxqU2
 o9EzccgWaNu4OCF/o2lNI3b7bYuMWemUv4Z13jd9b4dw4mNj/P
 TWeBondZgURlg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP3_EMU needs OC_ETM, which needs ARM_AMBA. Since the latter
dependency is getting turned from a 'select' into a 'depends',
omap has to select ARM_AMBA itself in order to have a correct
dependency chain. Alternatively, we could change OMAP3_EMU
to have a 'depends on OC_ETM' instead of selecting it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-omap2/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index fdd45dd..12ae86e 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -386,6 +386,7 @@ config OMAP3_EMU
 	bool "OMAP3 debugging peripherals"
 	depends on ARCH_OMAP3
 	select OC_ETM
+	select ARM_AMBA
 	help
 	  Say Y here to enable debugging hardware of omap3
 
-- 
1.7.5.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab2BHK72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 05:59:28 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:45469 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755470Ab2BHK70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 05:59:26 -0500
From: Luciano Coelho <coelho@ti.com>
To: tony@atomide.com
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 3.3] OMAP4: PRM: fix build breakage when CONFIG_OF is not defined
Date: Wed,  8 Feb 2012 12:59:12 +0200
Message-Id: <1328698752-18756-1-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 3.3-rc1, prm44xx.c build breaks if CONFIG_OF is not set:

arch/arm/mach-omap2/prm44xx.c:41: error: 'OMAP44XX_IRQ_PRCM' undeclared here (not in a function)
make[1]: *** [arch/arm/mach-omap2/prm44xx.o] Error 1

This is because of a missing include, which is added indirectly if
CONFIG_OF is defined.  This problem was introduced in commit
2f31b51659c2d8315ea2888ba5b93076febe672b

Cc: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 arch/arm/mach-omap2/prm44xx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/prm44xx.c b/arch/arm/mach-omap2/prm44xx.c
index 33dd655..f2e06ad 100644
--- a/arch/arm/mach-omap2/prm44xx.c
+++ b/arch/arm/mach-omap2/prm44xx.c
@@ -20,6 +20,7 @@
 #include "common.h"
 #include <plat/cpu.h>
 #include <plat/prcm.h>
+#include <plat/irqs.h>
 
 #include "vp.h"
 #include "prm44xx.h"
-- 
1.7.5.4


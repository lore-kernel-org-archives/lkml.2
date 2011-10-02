Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab1JBOtr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:49:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55222 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab1JBOrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:47:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 25/30] ARM: OMAP depends on MMU
Date: Sun,  2 Oct 2011 16:45:55 +0200
Message-Id: <1317566760-25681-26-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:IVkHqJl/hgp9Tt5nS5Tkb6pnxrY+1IAwWr3HdF0WcOT
 dN0IsM/S/99xzzzXA97mSlT31UYtiNN+lqXo6o0OtSBCYgfHBL
 rEZgHO1uImLQsI+hc+lPETQGpA9nj4sB7FGbb5OKAGcyxUoph7
 C3HdJTUhv0zLNfjGK3lqY78IzUEE9uIWhhIoEcJ/R44NqtEPRO
 0x0HoDu43OUqsR+pAFxceNG+8bOco6dVd6iTHreKeoj4Ep9ZC3
 ARK4fhGKo9x0s5p+nKMW+raJ+Gm9Jl4jCdMvxv+ZH/hQSWhhNw
 NGWcG60yauZTyhwkNkYpmkmwj6rF4O9RuXqvNbHM+nS7l94yQC
 3AbYZqtN/nIKmcX29y/BmTGp5us3qPw03W7KHMdOa6e1R5XtvU
 PAGaawWeKcVCA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no way to build OMAP kernels without an MMU
at this point because of dependencies on MMU-only functions.

As long as nobody is interested in fixing this, let's just disable
this platforms for nommu kernels.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5ebc5d9..e688ca4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -875,6 +875,7 @@ config ARCH_DAVINCI
 
 config ARCH_OMAP
 	bool "TI OMAP"
+	depends on MMU
 	select HAVE_CLK
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_HAS_CPUFREQ
-- 
1.7.5.4


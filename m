Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab2FHAvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:51:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58722 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab2FHAvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:51:06 -0400
From: mathieu.poirier@linaro.org
To: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH] arm: OMAP depends on MMU
Date: Thu,  7 Jun 2012 18:50:51 -0600
Message-Id: <1339116651-18051-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

There is no way to build OMAP kernels without an MMU
at this point because of dependencies on MMU-only functions.

As long as nobody is interested in fixing this, let's just disable
this platforms for nommu kernels.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 84449dd..4b1fc0d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -934,6 +934,7 @@ config ARCH_DAVINCI
 
 config ARCH_OMAP
 	bool "TI OMAP"
+	depends on MMU
 	select HAVE_CLK
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_HAS_CPUFREQ
-- 
1.7.5.4


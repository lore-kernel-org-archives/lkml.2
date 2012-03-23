Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304Ab2CWROW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:14:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53297 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759246Ab2CWROQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:14:16 -0400
From: mathieu.poirier@linaro.org
To: tony@atomide.com
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: [PATCH 9/9] ARM: omap: select CPU_FREQ_TABLE where needed
Date: Fri, 23 Mar 2012 11:13:56 -0600
Message-Id: <1332522836-29517-10-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
References: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The omap platform requires CPU_FREQ_TABLE support to be enabled for its
CPU_FREQ implementations, so automatically select that when CPU_FREQ
is enabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 arch/arm/plat-omap/Kconfig |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index aa59f42..1983d16 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -207,6 +207,11 @@ config OMAP_PM_NOOP
 
 endchoice
 
+config OMAP_CPU_FREQ
+	def_bool "y"
+	depends on CPU_FREQ
+	select CPU_FREQ_TABLE
+
 endmenu
 
 endif
-- 
1.7.5.4


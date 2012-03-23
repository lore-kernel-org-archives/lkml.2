Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab2CWRQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:16:33 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40425 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759089Ab2CWROG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:14:06 -0400
From: mathieu.poirier@linaro.org
To: tony@atomide.com
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: [PATCH 1/9] arm/omap: enable building omap2 without omap2420/2430
Date: Fri, 23 Mar 2012 11:13:48 -0600
Message-Id: <1332522836-29517-2-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
References: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Kconfig allows selecting CONFIG_OMAP2 but no specific SOC, the options
being omap2420 and omap2430, but that leads to a build error when
omap3 or omap4 are also enabled and the MULTI_OMAP2 symbol is
undefined.

This adds another clause to plat/multi.h, mainly to allow all
possible randconfig combinations to build cleanly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/include/plat/multi.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/multi.h b/arch/arm/plat-omap/include/plat/multi.h
index 999ffba..fb7f196 100644
--- a/arch/arm/plat-omap/include/plat/multi.h
+++ b/arch/arm/plat-omap/include/plat/multi.h
@@ -82,6 +82,11 @@
 #  define OMAP_NAME omap2430
 # endif
 #endif
+#ifdef CONFIG_ARCH_OMAP2
+# ifndef OMAP_NAME
+#  define OMAP_NAME omap2
+# endif
+#endif
 #ifdef CONFIG_ARCH_OMAP3
 # ifdef OMAP_NAME
 #  undef  MULTI_OMAP2
-- 
1.7.5.4


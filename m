Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab1JBOrk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:47:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60280 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab1JBOqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:46:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 05/30] ARM: omap: enable building omap2 without omap2420/2430
Date: Sun,  2 Oct 2011 16:45:35 +0200
Message-Id: <1317566760-25681-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:8XEsUoKXYu3JoXDctJ09FQfkCju5z3UBJpumu1UHS+X
 MJ1I1Y0ZMYkab3IreWy9srZhrs2ZHJzaeSDWhw3H7R+5FN4Sh4
 dtwlOgYTmHnFRTVAUDBuVxqRb9JqGZPGGZxKV3aIsMaOgp/h+6
 0gVpAce7s52gqKxn1HalzGll90anoGkPKhIrjy3XJ78UKk0lHu
 d+qqGCYXV9H3nrtWHKLNQ7T0g99zKiAA/C/ukx8F/p74l8m5ex
 1SMt2G2WcLgvXF/G23s/y49WzGhTiigZS++y7WQPYJTVnvG2Vo
 tQdOC7ES+LNCMfLopfi6tCR0QydYUVSn5pVpcFN2TBTrNE2CYr
 m8aaNJ4ECEOOdH9sR+2vJQQhtLaPZlD8S3WTK8DuCoYZIYh0dS
 M4UUr+MXaIRhA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig allows selecting CONFIG_OMAP2 but no specific SOC, the options
being omap2420 and omap2430, but that leads to a build error when
omap3 or omap4 are also enabled and the MULTI_OMAP2 symbol is
undefined.

This adds another clause to plat/multi.h, mainly to allow all
possible randconfig combinations to build cleanly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
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


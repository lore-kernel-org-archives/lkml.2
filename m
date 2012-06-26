Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab2FZVNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 17:13:33 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:4313 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753821Ab2FZVNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 17:13:32 -0400
Message-ID: <1340745209.1911.15.camel@x61.thuisdomein>
Subject: [PATCH 2/2] ARM: omap: remove unused cpu detection macros
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 26 Jun 2012 23:13:29 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 26 Jun 2012 21:13:30.0636 (UTC) FILETIME=[896304C0:01CD53E0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that OMAP730 and OMAP850 support is mostly unified, there's no
need for separate cpu detection macros for these architectures. At
least, currently there isn't, because both macros are unused.
cpu_is_7xx() seems to cover all possible uses.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Entirely untested!

1) And now the IS_OMAP_TYPE() macro "calls" for 730 and 850 are unused.
Not sure whether they should be removed too.

2) Note that cpu_is_omap343x(), cpu_is_omap447x(), and cpu_is_omap2423()
are all unused too. Reserved for future use, I guess.

 arch/arm/plat-omap/include/plat/cpu.h |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/cpu.h b/arch/arm/plat-omap/include/plat/cpu.h
index f2bdf15..e5304f2 100644
--- a/arch/arm/plat-omap/include/plat/cpu.h
+++ b/arch/arm/plat-omap/include/plat/cpu.h
@@ -239,8 +239,6 @@ IS_AM_SUBCLASS(335x, 0x335)
  * Macros to detect individual cpu types.
  * These are only rarely needed.
  * cpu_is_omap310():	True for OMAP310
- * cpu_is_omap730():	True for OMAP730
- * cpu_is_omap850():	True for OMAP850
  * cpu_is_omap1510():	True for OMAP1510
  * cpu_is_omap1610():	True for OMAP1610
  * cpu_is_omap1611():	True for OMAP1611
@@ -281,8 +279,6 @@ IS_OMAP_TYPE(3505, 0x3517)
 IS_OMAP_TYPE(3517, 0x3517)
 
 #define cpu_is_omap310()		0
-#define cpu_is_omap730()		0
-#define cpu_is_omap850()		0
 #define cpu_is_omap1510()		0
 #define cpu_is_omap1610()		0
 #define cpu_is_omap5912()		0
@@ -304,19 +300,9 @@ IS_OMAP_TYPE(3517, 0x3517)
 
 /*
  * Whether we have MULTI_OMAP1 or not, we still need to distinguish
- * between 730 vs 850, 310 vs. 1510 and 1611B/5912 vs. 1710.
+ * between 310 vs. 1510 and 1611B/5912 vs. 1710.
  */
 
-#if defined(CONFIG_ARCH_OMAP730)
-# undef  cpu_is_omap730
-# define cpu_is_omap730()		is_omap730()
-#endif
-
-#if defined(CONFIG_ARCH_OMAP850)
-# undef  cpu_is_omap850
-# define cpu_is_omap850()		is_omap850()
-#endif
-
 #if defined(CONFIG_ARCH_OMAP15XX)
 # undef  cpu_is_omap310
 # undef  cpu_is_omap1510
-- 
1.7.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab0EUITi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:19:38 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:40275 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab0EUITf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:19:35 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH] [WATCHDOG] bfin: use new common Blackfin watchdog header
Date: Fri, 21 May 2010 04:23:28 -0400
Message-Id: <1274430208-15087-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1268150860-28011-1-git-send-email-vapier@gentoo.org>
References: <1268150860-28011-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
Andrew: could you pick this up ?  it was posted a few months ago ...

 drivers/watchdog/bfin_wdt.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 9c7ccd1..9042a95 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
 #include <asm/blackfin.h>
+#include <asm/bfin_watchdog.h>
 
 #define stamp(fmt, args...) \
 	pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
@@ -49,24 +50,6 @@
 # define bfin_write_WDOG_STAT(x) bfin_write_WDOGA_STAT(x)
 #endif
 
-/* Bit in SWRST that indicates boot caused by watchdog */
-#define SWRST_RESET_WDOG 0x4000
-
-/* Bit in WDOG_CTL that indicates watchdog has expired (WDR0) */
-#define WDOG_EXPIRED 0x8000
-
-/* Masks for WDEV field in WDOG_CTL register */
-#define ICTL_RESET   0x0
-#define ICTL_NMI     0x2
-#define ICTL_GPI     0x4
-#define ICTL_NONE    0x6
-#define ICTL_MASK    0x6
-
-/* Masks for WDEN field in WDOG_CTL register */
-#define WDEN_MASK    0x0FF0
-#define WDEN_ENABLE  0x0000
-#define WDEN_DISABLE 0x0AD0
-
 /* some defaults */
 #define WATCHDOG_TIMEOUT 20
 
-- 
1.7.1


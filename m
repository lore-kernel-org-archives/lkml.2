Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934122Ab1J3Mws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 08:52:48 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:43200 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933994Ab1J3Mss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 08:48:48 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 17/27] m68k/mac: Convert Mac to genirq
Date: Sun, 30 Oct 2011 13:48:25 +0100
Message-Id: <1319978915-10933-18-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
References: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig      |    1 -
 arch/m68k/mac/baboon.c |    3 +++
 arch/m68k/mac/oss.c    |    3 +++
 arch/m68k/mac/psc.c    |    3 +++
 arch/m68k/mac/via.c    |    3 +++
 5 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 9000921..9ba1a89 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -87,7 +87,6 @@ config MMU_SUN3
 config USE_GENERIC_HARDIRQS
 	bool "Use genirq"
 	depends on MMU
-	depends on !MAC
 	depends on !APOLLO
 	depends on !MVME147
 	depends on !MVME16x
diff --git a/arch/m68k/mac/baboon.c b/arch/m68k/mac/baboon.c
index f264791..ff11746 100644
--- a/arch/m68k/mac/baboon.c
+++ b/arch/m68k/mac/baboon.c
@@ -11,6 +11,9 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#ifdef CONFIG_GENERIC_HARDIRQS
+#include <linux/irq.h>
+#endif
 
 #include <asm/traps.h>
 #include <asm/bootinfo.h>
diff --git a/arch/m68k/mac/oss.c b/arch/m68k/mac/oss.c
index 1eb60f0..ed95270 100644
--- a/arch/m68k/mac/oss.c
+++ b/arch/m68k/mac/oss.c
@@ -19,6 +19,9 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#ifdef CONFIG_GENERIC_HARDIRQS
+#include <linux/irq.h>
+#endif
 
 #include <asm/bootinfo.h>
 #include <asm/macintosh.h>
diff --git a/arch/m68k/mac/psc.c b/arch/m68k/mac/psc.c
index 26c2b65..0a34b7a 100644
--- a/arch/m68k/mac/psc.c
+++ b/arch/m68k/mac/psc.c
@@ -18,6 +18,9 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#ifdef CONFIG_GENERIC_HARDIRQS
+#include <linux/irq.h>
+#endif
 
 #include <asm/traps.h>
 #include <asm/bootinfo.h>
diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index af9ed33..bde156c 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -28,6 +28,9 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#ifdef CONFIG_GENERIC_HARDIRQS
+#include <linux/irq.h>
+#endif
 
 #include <asm/bootinfo.h>
 #include <asm/macintosh.h>
-- 
1.7.0.4


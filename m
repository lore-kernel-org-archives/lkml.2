Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131Ab1J3MyD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 08:54:03 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:47686 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab1J3Mss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 08:48:48 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 15/27] m68k/amiga: Convert Amiga to genirq
Date: Sun, 30 Oct 2011 13:48:23 +0100
Message-Id: <1319978915-10933-16-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
References: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig         |    1 -
 arch/m68k/amiga/amiints.c |    3 +++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 9d60f40..9000921 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -87,7 +87,6 @@ config MMU_SUN3
 config USE_GENERIC_HARDIRQS
 	bool "Use genirq"
 	depends on MMU
-	depends on !AMIGA
 	depends on !MAC
 	depends on !APOLLO
 	depends on !MVME147
diff --git a/arch/m68k/amiga/amiints.c b/arch/m68k/amiga/amiints.c
index c8f9eac..c3da534 100644
--- a/arch/m68k/amiga/amiints.c
+++ b/arch/m68k/amiga/amiints.c
@@ -9,6 +9,9 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/errno.h>
+#ifdef CONFIG_GENERIC_HARDIRQS
+#include <linux/irq.h>
+#endif
 
 #include <asm/irq.h>
 #include <asm/traps.h>
-- 
1.7.0.4


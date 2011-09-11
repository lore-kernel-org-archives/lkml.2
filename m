Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab1IKMEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 08:04:52 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:53558 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760108Ab1IKMAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 08:00:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 17/28] m68k/amiga: Convert Amiga to genirq
Date: Sun, 11 Sep 2011 13:59:43 +0200
Message-Id: <1315742394-16036-18-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v3: With handle_simple_irq(), we don't need the .irq_{,un}mask methods anymore.
    With m68k_handle_int() renamed to generic_handle_irq(), code paths for
    legacy and genirq become the same.

v2: Added this changeset
---
 arch/m68k/Kconfig.mmu     |    1 -
 arch/m68k/amiga/amiints.c |    3 +++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/Kconfig.mmu b/arch/m68k/Kconfig.mmu
index 2df049f..20e27d1 100644
--- a/arch/m68k/Kconfig.mmu
+++ b/arch/m68k/Kconfig.mmu
@@ -200,7 +200,6 @@ config SUN3
 
 config USE_GENERIC_HARDIRQS
 	bool "Use genirq"
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


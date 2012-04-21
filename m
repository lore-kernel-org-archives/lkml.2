Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2DUJKa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:10:30 -0400
Received: from smtp4.mail.ru ([94.100.176.44]:47985 "EHLO smtp4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923Ab2DUJK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:10:26 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 12/17] ARM clps711x: Simple optimise debug_macro by removing one NOP
Date: Sat, 21 Apr 2012 13:11:25 +0400
Message-Id: <1334999490-27177-13-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 arch/arm/mach-clps711x/include/mach/debug-macro.S |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-clps711x/include/mach/debug-macro.S b/arch/arm/mach-clps711x/include/mach/debug-macro.S
index 118b3d9..37c4d8a 100644
--- a/arch/arm/mach-clps711x/include/mach/debug-macro.S
+++ b/arch/arm/mach-clps711x/include/mach/debug-macro.S
@@ -14,10 +14,8 @@
 #include <mach/hardware.h>
 
 		.macro	addruart, rp, rv, tmp
-#ifndef CONFIG_DEBUG_CLPS711X_UART2
-		mov	\rp, #0x0000	@ UART1
-#else
-		mov	\rp, #0x1000	@ UART2
+#ifdef CONFIG_DEBUG_CLPS711X_UART2
+		mov	\rp, #0x1000	@ Add offset for UART2 base reg
 #endif
 		orr	\rv, \rp, #CLPS711X_VIRT_BASE
 		orr	\rp, \rp, #CLPS711X_PHYS_BASE
-- 
1.7.3.4


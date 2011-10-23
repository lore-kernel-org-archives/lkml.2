Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab1JWVSa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 17:18:30 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:46369 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab1JWVSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 17:18:25 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5/5] m68k/irq: Remove obsolete IRQ_FLG_* definitions
Date: Sun, 23 Oct 2011 23:18:06 +0200
Message-Id: <1319404686-10800-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319404686-10800-1-git-send-email-geert@linux-m68k.org>
References: <1319404686-10800-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The m68k core irq code stopped honoring these flags during the irq
restructuring in 2006.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
This is a split-up of "m68k/irq: Remove obsolete IRQ_FLG_* definitions and
users", to reduce conflicts and remove dependencies.

diff --git a/arch/m68k/include/asm/irq.h b/arch/m68k/include/asm/irq.h
index 9a2bae8..fe625e2 100644
--- a/arch/m68k/include/asm/irq.h
+++ b/arch/m68k/include/asm/irq.h
@@ -59,19 +59,6 @@ extern unsigned int irq_canonicalize(unsigned int irq);
 struct pt_regs;
 
 /*
- * various flags for request_irq() - the Amiga now uses the standard
- * mechanism like all other architectures - IRQF_DISABLED and
- * IRQF_SHARED are your friends.
- */
-#ifndef MACH_AMIGA_ONLY
-#define IRQ_FLG_LOCK	(0x0001)	/* handler is not replaceable	*/
-#define IRQ_FLG_REPLACE	(0x0002)	/* replace existing handler	*/
-#define IRQ_FLG_FAST	(0x0004)
-#define IRQ_FLG_SLOW	(0x0008)
-#define IRQ_FLG_STD	(0x8000)	/* internally used		*/
-#endif
-
-/*
  * This structure is used to chain together the ISRs for a particular
  * interrupt source (if it supports chaining).
  */

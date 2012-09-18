Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2IRSTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:19:32 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:57866 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab2IRSTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:19:30 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next, RESEND] av32: Make sure _TIF_BREAKPOINT is defined
Date: Tue, 18 Sep 2012 20:19:21 +0200
Message-Id: <1347992361-11510-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 1deb667af4fc713364fed72ccdf217162b62ec7f ("avr32: trim masks")
replaced "1 << TIF_BREAKPOINT" by "_TIF_BREAKPOINT", but forgot to define
the latter:

arch/avr32/kernel/entry-avr32b.S: Assembler messages:
arch/avr32/kernel/entry-avr32b.S:232: Error: undefined symbol `_TIF_BREAKPOINT' in operation
arch/avr32/kernel/entry-avr32b.S:258: Error: undefined symbol `_TIF_BREAKPOINT' in operation
arch/avr32/kernel/entry-avr32b.S:852: Error: undefined symbol `_TIF_BREAKPOINT' in operation
arch/avr32/kernel/entry-avr32b.S:631: Error: undefined symbol `_TIF_BREAKPOINT' in operation
arch/avr32/kernel/entry-avr32b.S:631: Error: undefined symbol `_TIF_BREAKPOINT' in operation
arch/avr32/kernel/entry-avr32b.S:852: Error: undefined symbol `_TIF_BREAKPOINT' in operation
arch/avr32/kernel/entry-avr32b.S:852: Error: undefined symbol `_TIF_BREAKPOINT' in operation
arch/avr32/kernel/entry-avr32b.S:852: Error: undefined symbol `_TIF_BREAKPOINT' in operation
arch/avr32/kernel/entry-avr32b.S:852: Error: undefined symbol `_TIF_BREAKPOINT' in operation

Add the missing definition to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
---
Still not fixed after almost 4 months...

 arch/avr32/include/asm/thread_info.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/include/asm/thread_info.h b/arch/avr32/include/asm/thread_info.h
index 2f0c412..6dc62e1 100644
--- a/arch/avr32/include/asm/thread_info.h
+++ b/arch/avr32/include/asm/thread_info.h
@@ -89,6 +89,7 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_BREAKPOINT		(1 << TIF_BREAKPOINT)
 #define _TIF_SINGLE_STEP	(1 << TIF_SINGLE_STEP)
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_CPU_GOING_TO_SLEEP (1 << TIF_CPU_GOING_TO_SLEEP)
-- 
1.7.0.4


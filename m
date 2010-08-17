Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab0HQP2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:28:52 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:2492 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757687Ab0HQP2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:28:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAGtHakzCTtAn/2dsb2JhbACTJ40XccAxhTcEiWc
Date: Tue, 17 Aug 2010 17:28:33 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] m68k{nommu}/blackfin : remove old assembler-only flags bit
	definitions.
Message-ID: <20100817152833.GA15475@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Long ago, PT_TRACESYS_OFF and friends were introduced as hard defines
to avoid straight constants in assembler parts of linux m68k.
They are not used anymore, and were not updated to follow changes
in linux kernel.  Remove them.  When similar constants are needed,
they are now generated using asm-offsets.c.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
---
 arch/blackfin/include/asm/entry.h |    8 --------
 arch/m68k/include/asm/entry_mm.h  |    8 --------
 arch/m68k/include/asm/entry_no.h  |   10 ----------
 3 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/arch/blackfin/include/asm/entry.h b/arch/blackfin/include/asm/entry.h
index a6886f6..4104d57 100644
--- a/arch/blackfin/include/asm/entry.h
+++ b/arch/blackfin/include/asm/entry.h
@@ -15,14 +15,6 @@
 #define	LFLUSH_I_AND_D	0x00000808
 #define	LSIGTRAP	5
 
-/* process bits for task_struct.flags */
-#define	PF_TRACESYS_OFF	3
-#define	PF_TRACESYS_BIT	5
-#define	PF_PTRACED_OFF	3
-#define	PF_PTRACED_BIT	4
-#define	PF_DTRACE_OFF	1
-#define	PF_DTRACE_BIT	5
-
 /*
  * NOTE!  The single-stepping code assumes that all interrupt handlers
  * start by saving SYSCFG on the stack with their first instruction.
diff --git a/arch/m68k/include/asm/entry_mm.h b/arch/m68k/include/asm/entry_mm.h
index 4741258..6f70823 100644
--- a/arch/m68k/include/asm/entry_mm.h
+++ b/arch/m68k/include/asm/entry_mm.h
@@ -47,14 +47,6 @@
 
 LFLUSH_I_AND_D = 0x00000808
 
-/* process bits for task_struct.ptrace */
-PT_TRACESYS_OFF = 3
-PT_TRACESYS_BIT = 1
-PT_PTRACED_OFF = 3
-PT_PTRACED_BIT = 0
-PT_DTRACE_OFF = 3
-PT_DTRACE_BIT = 2
-
 #define SAVE_ALL_INT save_all_int
 #define SAVE_ALL_SYS save_all_sys
 #define RESTORE_ALL restore_all
diff --git a/arch/m68k/include/asm/entry_no.h b/arch/m68k/include/asm/entry_no.h
index 907ed03..477d91a 100644
--- a/arch/m68k/include/asm/entry_no.h
+++ b/arch/m68k/include/asm/entry_no.h
@@ -32,16 +32,6 @@
 
 #ifdef __ASSEMBLY__
 
-/* process bits for task_struct.flags */
-PF_TRACESYS_OFF = 3
-PF_TRACESYS_BIT = 5
-PF_PTRACED_OFF = 3
-PF_PTRACED_BIT = 4
-PF_DTRACE_OFF = 1
-PF_DTRACE_BIT = 5
-
-LENOSYS = 38
-
 #define SWITCH_STACK_SIZE (6*4+4)	/* Includes return address */
 
 /*
-- 
1.6.3.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2FJIvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 04:51:55 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:3489 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451Ab2FJIvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 04:51:53 -0400
Message-ID: <1339318307.30984.27.camel@x61.thuisdomein>
Subject: [PATCH] sparc: remove two unused headers
From: Paul Bolle <pebolle@tiscali.nl>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 10 Jun 2012 10:51:47 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 10 Jun 2012 08:51:48.0062 (UTC) FILETIME=[452D1FE0:01CD46E6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing includes these two headers. None of the macros they define are
used anywhere in the tree. This was also the case in v2.6.12-rc2 and,
presumably, every release in between. These two headers can safely be
removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested by prodding at the (history of the) tree with various git
commands.

 arch/sparc/include/asm/cmt.h    |   59 ----------------------------------
 arch/sparc/include/asm/mpmbox.h |   67 ---------------------------------------
 2 files changed, 0 insertions(+), 126 deletions(-)
 delete mode 100644 arch/sparc/include/asm/cmt.h
 delete mode 100644 arch/sparc/include/asm/mpmbox.h

diff --git a/arch/sparc/include/asm/cmt.h b/arch/sparc/include/asm/cmt.h
deleted file mode 100644
index 870db59..0000000
--- a/arch/sparc/include/asm/cmt.h
+++ /dev/null
@@ -1,59 +0,0 @@
-#ifndef _SPARC64_CMT_H
-#define _SPARC64_CMT_H
-
-/* cmt.h: Chip Multi-Threading register definitions
- *
- * Copyright (C) 2004 David S. Miller (davem@redhat.com)
- */
-
-/* ASI_CORE_ID - private */
-#define LP_ID		0x0000000000000010UL
-#define  LP_ID_MAX	0x00000000003f0000UL
-#define  LP_ID_ID	0x000000000000003fUL
-
-/* ASI_INTR_ID - private */
-#define LP_INTR_ID	0x0000000000000000UL
-#define  LP_INTR_ID_ID	0x00000000000003ffUL
-
-/* ASI_CESR_ID - private */
-#define CESR_ID		0x0000000000000040UL
-#define  CESR_ID_ID	0x00000000000000ffUL
-
-/* ASI_CORE_AVAILABLE - shared */
-#define LP_AVAIL	0x0000000000000000UL
-#define  LP_AVAIL_1	0x0000000000000002UL
-#define  LP_AVAIL_0	0x0000000000000001UL
-
-/* ASI_CORE_ENABLE_STATUS - shared */
-#define LP_ENAB_STAT	0x0000000000000010UL
-#define  LP_ENAB_STAT_1	0x0000000000000002UL
-#define  LP_ENAB_STAT_0	0x0000000000000001UL
-
-/* ASI_CORE_ENABLE - shared */
-#define LP_ENAB		0x0000000000000020UL
-#define  LP_ENAB_1	0x0000000000000002UL
-#define  LP_ENAB_0	0x0000000000000001UL
-
-/* ASI_CORE_RUNNING - shared */
-#define LP_RUNNING_RW	0x0000000000000050UL
-#define LP_RUNNING_W1S	0x0000000000000060UL
-#define LP_RUNNING_W1C	0x0000000000000068UL
-#define  LP_RUNNING_1	0x0000000000000002UL
-#define  LP_RUNNING_0	0x0000000000000001UL
-
-/* ASI_CORE_RUNNING_STAT - shared */
-#define LP_RUN_STAT	0x0000000000000058UL
-#define  LP_RUN_STAT_1	0x0000000000000002UL
-#define  LP_RUN_STAT_0	0x0000000000000001UL
-
-/* ASI_XIR_STEERING - shared */
-#define LP_XIR_STEER	0x0000000000000030UL
-#define  LP_XIR_STEER_1	0x0000000000000002UL
-#define  LP_XIR_STEER_0	0x0000000000000001UL
-
-/* ASI_CMT_ERROR_STEERING - shared */
-#define CMT_ER_STEER	0x0000000000000040UL
-#define  CMT_ER_STEER_1	0x0000000000000002UL
-#define  CMT_ER_STEER_0	0x0000000000000001UL
-
-#endif /* _SPARC64_CMT_H */
diff --git a/arch/sparc/include/asm/mpmbox.h b/arch/sparc/include/asm/mpmbox.h
deleted file mode 100644
index f842303..0000000
--- a/arch/sparc/include/asm/mpmbox.h
+++ /dev/null
@@ -1,67 +0,0 @@
-/*
- * mpmbox.h:  Interface and defines for the OpenProm mailbox
- *               facilities for MP machines under Linux.
- *
- * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
- */
-
-#ifndef _SPARC_MPMBOX_H
-#define _SPARC_MPMBOX_H
-
-/* The prom allocates, for each CPU on the machine an unsigned
- * byte in physical ram.  You probe the device tree prom nodes
- * for these values.  The purpose of this byte is to be able to
- * pass messages from one cpu to another.
- */
-
-/* These are the main message types we have to look for in our
- * Cpu mailboxes, based upon these values we decide what course
- * of action to take.
- */
-
-/* The CPU is executing code in the kernel. */
-#define MAILBOX_ISRUNNING     0xf0
-
-/* Another CPU called romvec->pv_exit(), you should call
- * prom_stopcpu() when you see this in your mailbox.
- */
-#define MAILBOX_EXIT          0xfb
-
-/* Another CPU called romvec->pv_enter(), you should call
- * prom_cpuidle() when this is seen.
- */
-#define MAILBOX_GOSPIN        0xfc
-
-/* Another CPU has hit a breakpoint either into kadb or the prom
- * itself.  Just like MAILBOX_GOSPIN, you should call prom_cpuidle()
- * at this point.
- */
-#define MAILBOX_BPT_SPIN      0xfd
-
-/* Oh geese, some other nitwit got a damn watchdog reset.  The party's
- * over so go call prom_stopcpu().
- */
-#define MAILBOX_WDOG_STOP     0xfe
-
-#ifndef __ASSEMBLY__
-
-/* Handy macro's to determine a cpu's state. */
-
-/* Is the cpu still in Power On Self Test? */
-#define MBOX_POST_P(letter)  ((letter) >= 0x00 && (letter) <= 0x7f)
-
-/* Is the cpu at the 'ok' prompt of the PROM? */
-#define MBOX_PROMPROMPT_P(letter) ((letter) >= 0x80 && (letter) <= 0x8f)
-
-/* Is the cpu spinning in the PROM? */
-#define MBOX_PROMSPIN_P(letter) ((letter) >= 0x90 && (letter) <= 0xef)
-
-/* Sanity check... This is junk mail, throw it out. */
-#define MBOX_BOGON_P(letter) ((letter) >= 0xf1 && (letter) <= 0xfa)
-
-/* Is the cpu actively running an application/kernel-code? */
-#define MBOX_RUNNING_P(letter) ((letter) == MAILBOX_ISRUNNING)
-
-#endif /* !(__ASSEMBLY__) */
-
-#endif /* !(_SPARC_MPMBOX_H) */
-- 
1.7.7.6


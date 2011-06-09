Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab1FINIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:08:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:33346 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757824Ab1FINIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:08:38 -0400
Date: Thu, 9 Jun 2011 13:08:13 GMT
From: tip-bot for Ralf Baechle <ralf@linux-mips.org>
Message-ID: <tip-850492760cfd38d14d64a5fc6d636091464f755e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, linux@arm.linux.org.uk, tglx@linutronix.de
In-Reply-To: <20110601180610.913463093@duck.linux-mips.net>
References: <20110601180610.913463093@duck.linux-mips.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] i8253: Move remaining content and delete asm/i8253.h
Git-Commit-ID: 850492760cfd38d14d64a5fc6d636091464f755e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Jun 2011 13:08:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  850492760cfd38d14d64a5fc6d636091464f755e
Gitweb:     http://git.kernel.org/tip/850492760cfd38d14d64a5fc6d636091464f755e
Author:     Ralf Baechle <ralf@linux-mips.org>
AuthorDate: Wed, 1 Jun 2011 19:05:08 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Jun 2011 15:01:40 +0200

i8253: Move remaining content and delete asm/i8253.h

Move setup_pit_timer() declaration to the common header file and
remove the arch specific ones.

[ tglx: Move it to linux/i8253.h instead of asm/mips and asm/x86 ]

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-mips@linux-mips.org
Cc: Sergei Shtylyov <sshtylyov@mvista.com
Link: http://lkml.kernel.org/r/20110601180610.913463093@duck.linux-mips.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/arm/include/asm/i8253.h  |    4 ----
 arch/mips/include/asm/i8253.h |   10 ----------
 arch/x86/include/asm/i8253.h  |    6 ------
 include/linux/i8253.h         |    3 ++-
 4 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/arch/arm/include/asm/i8253.h b/arch/arm/include/asm/i8253.h
deleted file mode 100644
index fee59eb..0000000
--- a/arch/arm/include/asm/i8253.h
+++ /dev/null
@@ -1,4 +0,0 @@
-#ifndef __ASMARM_I8253_H
-#define __ASMARM_I8253_H
-
-#endif
diff --git a/arch/mips/include/asm/i8253.h b/arch/mips/include/asm/i8253.h
deleted file mode 100644
index 26f4eb1..0000000
--- a/arch/mips/include/asm/i8253.h
+++ /dev/null
@@ -1,10 +0,0 @@
-/*
- *  Machine specific IO port address definition for generic.
- *  Written by Osamu Tomita <tomita@cinet.co.jp>
- */
-#ifndef __ASM_I8253_H
-#define __ASM_I8253_H
-
-extern void setup_pit_timer(void);
-
-#endif /* __ASM_I8253_H */
diff --git a/arch/x86/include/asm/i8253.h b/arch/x86/include/asm/i8253.h
deleted file mode 100644
index 0049dc9..0000000
--- a/arch/x86/include/asm/i8253.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_X86_I8253_H
-#define _ASM_X86_I8253_H
-
-extern void setup_pit_timer(void);
-
-#endif /* _ASM_X86_I8253_H */
diff --git a/include/linux/i8253.h b/include/linux/i8253.h
index 1ec6323..76039c8 100644
--- a/include/linux/i8253.h
+++ b/include/linux/i8253.h
@@ -12,7 +12,6 @@
 #include <linux/param.h>
 #include <linux/spinlock.h>
 #include <linux/timex.h>
-#include <asm/i8253.h>
 
 /* i8253A PIT registers */
 #define PIT_MODE	0x43
@@ -26,4 +25,6 @@
 
 extern raw_spinlock_t i8253_lock;
 
+extern void setup_pit_timer(void);
+
 #endif /* __LINUX_I8253_H */

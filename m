Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab1FINIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:08:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:33325 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757592Ab1FINIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:08:06 -0400
Date: Thu, 9 Jun 2011 13:07:49 GMT
From: tip-bot for Ralf Baechle <ralf@linux-mips.org>
Message-ID: <tip-49cf3f29a1ef2e59f1be823e376c1fbac586eb8d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, linux@arm.linux.org.uk, tglx@linutronix.de
In-Reply-To: <20110601180610.832810002@duck.linux-mips.net>
References: <20110601180610.832810002@duck.linux-mips.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] i8253: Consolidate definitions of PIT_LATCH
Git-Commit-ID: 49cf3f29a1ef2e59f1be823e376c1fbac586eb8d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Jun 2011 13:07:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49cf3f29a1ef2e59f1be823e376c1fbac586eb8d
Gitweb:     http://git.kernel.org/tip/49cf3f29a1ef2e59f1be823e376c1fbac586eb8d
Author:     Ralf Baechle <ralf@linux-mips.org>
AuthorDate: Wed, 1 Jun 2011 19:05:07 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Jun 2011 15:01:40 +0200

i8253: Consolidate definitions of PIT_LATCH

x86 defines PIT_LATCH as LATCH which in <linux/timex.h> is defined as
((CLOCK_TICK_RATE + HZ/2) / HZ) and <asm/timex.h> again defines
CLOCK_TICK_RATE as PIT_TICK_RATE.

MIPS defines PIT_LATCH as LATCH which in <linux/timex.h> is defined as
((CLOCK_TICK_RATE + HZ/2) / HZ) and <asm/timex.h> again defines
CLOCK_TICK_RATE as 1193182.

ARM defines PITCH_LATCH as ((PIT_TICK_RATE + HZ / 2) / HZ) - and that's
the sanest thing and equivalent to above definitions so use that as the
new definition in <linux/i8253.h>.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mips@linux-mips.org
Link: http://lkml.kernel.org/r/20110601180610.832810002@duck.linux-mips.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/arm/include/asm/i8253.h  |    2 --
 arch/mips/include/asm/i8253.h |    2 --
 arch/x86/include/asm/i8253.h  |    2 --
 include/linux/i8253.h         |    4 ++++
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/i8253.h b/arch/arm/include/asm/i8253.h
index 5b41b92..fee59eb 100644
--- a/arch/arm/include/asm/i8253.h
+++ b/arch/arm/include/asm/i8253.h
@@ -1,6 +1,4 @@
 #ifndef __ASMARM_I8253_H
 #define __ASMARM_I8253_H
 
-#define PIT_LATCH	((PIT_TICK_RATE + HZ / 2) / HZ)
-
 #endif
diff --git a/arch/mips/include/asm/i8253.h b/arch/mips/include/asm/i8253.h
index 32ec1f0..26f4eb1 100644
--- a/arch/mips/include/asm/i8253.h
+++ b/arch/mips/include/asm/i8253.h
@@ -5,8 +5,6 @@
 #ifndef __ASM_I8253_H
 #define __ASM_I8253_H
 
-#define PIT_LATCH		LATCH
-
 extern void setup_pit_timer(void);
 
 #endif /* __ASM_I8253_H */
diff --git a/arch/x86/include/asm/i8253.h b/arch/x86/include/asm/i8253.h
index 3d5f5ee..0049dc9 100644
--- a/arch/x86/include/asm/i8253.h
+++ b/arch/x86/include/asm/i8253.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_X86_I8253_H
 #define _ASM_X86_I8253_H
 
-#define PIT_LATCH	LATCH
-
 extern void setup_pit_timer(void);
 
 #endif /* _ASM_X86_I8253_H */
diff --git a/include/linux/i8253.h b/include/linux/i8253.h
index 13048d3..1ec6323 100644
--- a/include/linux/i8253.h
+++ b/include/linux/i8253.h
@@ -9,7 +9,9 @@
 #ifndef __LINUX_I8253_H
 #define __LINUX_I8253_H
 
+#include <linux/param.h>
 #include <linux/spinlock.h>
+#include <linux/timex.h>
 #include <asm/i8253.h>
 
 /* i8253A PIT registers */
@@ -17,6 +19,8 @@
 #define PIT_CH0		0x40
 #define PIT_CH2		0x42
 
+#define PIT_LATCH	((PIT_TICK_RATE + HZ/2) / HZ)
+
 #define inb_pit         inb_p
 #define outb_pit        outb_p
 

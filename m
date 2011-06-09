Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab1FILRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:17:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:41148 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab1FILRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:17:20 -0400
Date: Thu, 9 Jun 2011 11:16:49 GMT
From: tip-bot for Ralf Baechle <ralf@linux-mips.org>
Message-ID: <tip-1ff256164618afb3880137d4819ee62e9bda2d50@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, linux@arm.linux.org.uk, tglx@linutronix.de
In-Reply-To: <20110601180610.134151920@duck.linux-mips.net>
References: <20110601180610.134151920@duck.linux-mips.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] i8253: Unify all kernel declarations of i8253_lock
Git-Commit-ID: 1ff256164618afb3880137d4819ee62e9bda2d50
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Jun 2011 11:16:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ff256164618afb3880137d4819ee62e9bda2d50
Gitweb:     http://git.kernel.org/tip/1ff256164618afb3880137d4819ee62e9bda2d50
Author:     Ralf Baechle <ralf@linux-mips.org>
AuthorDate: Wed, 1 Jun 2011 19:04:58 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Jun 2011 12:03:49 +0200

i8253: Unify all kernel declarations of i8253_lock

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mips@linux-mips.org
Link: http://lkml.kernel.org/r/20110601180610.134151920@duck.linux-mips.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/arm/include/asm/i8253.h  |    9 ---------
 arch/mips/include/asm/i8253.h |   12 ------------
 arch/x86/include/asm/i8253.h  |   10 ----------
 include/linux/i8253.h         |   14 ++++++++++++++
 4 files changed, 14 insertions(+), 31 deletions(-)

diff --git a/arch/arm/include/asm/i8253.h b/arch/arm/include/asm/i8253.h
index 70656b6..5b41b92 100644
--- a/arch/arm/include/asm/i8253.h
+++ b/arch/arm/include/asm/i8253.h
@@ -1,15 +1,6 @@
 #ifndef __ASMARM_I8253_H
 #define __ASMARM_I8253_H
 
-/* i8253A PIT registers */
-#define PIT_MODE	0x43
-#define PIT_CH0		0x40
-
 #define PIT_LATCH	((PIT_TICK_RATE + HZ / 2) / HZ)
 
-extern raw_spinlock_t i8253_lock;
-
-#define outb_pit	outb_p
-#define inb_pit		inb_p
-
 #endif
diff --git a/arch/mips/include/asm/i8253.h b/arch/mips/include/asm/i8253.h
index 9ad0113..32ec1f0 100644
--- a/arch/mips/include/asm/i8253.h
+++ b/arch/mips/include/asm/i8253.h
@@ -5,20 +5,8 @@
 #ifndef __ASM_I8253_H
 #define __ASM_I8253_H
 
-#include <linux/spinlock.h>
-
-/* i8253A PIT registers */
-#define PIT_MODE		0x43
-#define PIT_CH0			0x40
-#define PIT_CH2			0x42
-
 #define PIT_LATCH		LATCH
 
-extern raw_spinlock_t i8253_lock;
-
 extern void setup_pit_timer(void);
 
-#define inb_pit inb_p
-#define outb_pit outb_p
-
 #endif /* __ASM_I8253_H */
diff --git a/arch/x86/include/asm/i8253.h b/arch/x86/include/asm/i8253.h
index 65aaa91..20480ce 100644
--- a/arch/x86/include/asm/i8253.h
+++ b/arch/x86/include/asm/i8253.h
@@ -1,20 +1,10 @@
 #ifndef _ASM_X86_I8253_H
 #define _ASM_X86_I8253_H
 
-/* i8253A PIT registers */
-#define PIT_MODE		0x43
-#define PIT_CH0			0x40
-#define PIT_CH2			0x42
-
 #define PIT_LATCH	LATCH
 
-extern raw_spinlock_t i8253_lock;
-
 extern struct clock_event_device *global_clock_event;
 
 extern void setup_pit_timer(void);
 
-#define inb_pit		inb_p
-#define outb_pit	outb_p
-
 #endif /* _ASM_X86_I8253_H */
diff --git a/include/linux/i8253.h b/include/linux/i8253.h
index d2cba88..13048d3 100644
--- a/include/linux/i8253.h
+++ b/include/linux/i8253.h
@@ -2,10 +2,24 @@
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
+ *
+ *  Machine specific IO port address definition for generic.
+ *  Written by Osamu Tomita <tomita@cinet.co.jp>
  */
 #ifndef __LINUX_I8253_H
 #define __LINUX_I8253_H
 
+#include <linux/spinlock.h>
 #include <asm/i8253.h>
 
+/* i8253A PIT registers */
+#define PIT_MODE	0x43
+#define PIT_CH0		0x40
+#define PIT_CH2		0x42
+
+#define inb_pit         inb_p
+#define outb_pit        outb_p
+
+extern raw_spinlock_t i8253_lock;
+
 #endif /* __LINUX_I8253_H */

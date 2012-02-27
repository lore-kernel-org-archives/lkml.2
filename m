Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab2B0Jka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:40:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab2B0Jk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:40:29 -0500
Date: Mon, 27 Feb 2012 01:39:43 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-d93c4071b78f4676ef70ec8f2d4bae59b6cc5523@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4F4787930200007800074A10@nat28.tlf.novell.com>
References: <4F4787930200007800074A10@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] x86/time: Eliminate unused irq0_irqs counter
Git-Commit-ID: d93c4071b78f4676ef70ec8f2d4bae59b6cc5523
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Feb 2012 01:40:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d93c4071b78f4676ef70ec8f2d4bae59b6cc5523
Gitweb:     http://git.kernel.org/tip/d93c4071b78f4676ef70ec8f2d4bae59b6cc5523
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 24 Feb 2012 11:50:27 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 27 Feb 2012 08:46:25 +0100

x86/time: Eliminate unused irq0_irqs counter

As of v2.6.38 this counter is being maintained without ever being
read.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/4F4787930200007800074A10@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/hardirq.h |    1 -
 arch/x86/kernel/time.c         |    3 ---
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index da0b3ca..382f75d 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -7,7 +7,6 @@
 typedef struct {
 	unsigned int __softirq_pending;
 	unsigned int __nmi_count;	/* arch dependent */
-	unsigned int irq0_irqs;
 #ifdef CONFIG_X86_LOCAL_APIC
 	unsigned int apic_timer_irqs;	/* arch dependent */
 	unsigned int irq_spurious_count;
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index dd5fbf4..c6eba2b 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -57,9 +57,6 @@ EXPORT_SYMBOL(profile_pc);
  */
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
-	/* Keep nmi watchdog up to date */
-	inc_irq_stat(irq0_irqs);
-
 	global_clock_event->event_handler(global_clock_event);
 
 	/* MCA bus quirk: Acknowledge irq0 by setting bit 7 in port 0x61 */

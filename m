Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0LIPKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:10:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:48859 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab0LIPKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:10:06 -0500
Date: Thu, 9 Dec 2010 15:09:55 GMT
From: tip-bot for Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rakib.mullick@gmail.com, tglx@linutronix.de,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rakib.mullick@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
        dzickus@redhat.com
In-Reply-To: <AANLkTi=rcc38QzoKa6LFy4m++-p_9=Zt4_kDQE=GeKxf@mail.gmail.com>
References: <AANLkTi=rcc38QzoKa6LFy4m++-p_9=Zt4_kDQE=GeKxf@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Address 'unused' warning in hw_nmi.c again
Message-ID: <tip-2c6cb1053ad8b61ab9fb50b578d0ffea959f7583@git.kernel.org>
Git-Commit-ID: 2c6cb1053ad8b61ab9fb50b578d0ffea959f7583
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 15:09:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c6cb1053ad8b61ab9fb50b578d0ffea959f7583
Gitweb:     http://git.kernel.org/tip/2c6cb1053ad8b61ab9fb50b578d0ffea959f7583
Author:     Rakib Mullick <rakib.mullick@gmail.com>
AuthorDate: Thu, 9 Dec 2010 14:47:34 +0600
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Dec 2010 16:06:52 +0100

x86: Address 'unused' warning in hw_nmi.c again

arch/x86/kernel/apic/hw_nmi.c:29: warning: backtrace_mask defined but not used

commit 0e2af2a9(x86, hw_nmi: Move backtrace_mask declaration under
ARCH_HAS_NMI_WATCHDOG) addressed this warning, but it was reintroduced
by commit 5f2b0ba4(x86, nmi_watchdog: Remove the old nmi_watchdog).

Move backtrace_mask into the #ifdef arch_trigger_all_cpu_backtrace
section again.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <AANLkTi=rcc38QzoKa6LFy4m++-p_9=Zt4_kDQE=GeKxf@mail.gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/hw_nmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index a0e71cb..057f1eb 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -24,11 +24,11 @@ u64 hw_nmi_get_sample_period(void)
 }
 #endif
 
+#ifdef arch_trigger_all_cpu_backtrace
 
 /* For reliability, we're prepared to waste bits here. */
 static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
 
-#ifdef arch_trigger_all_cpu_backtrace
 void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;

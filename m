Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423567Ab2KNWkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:40:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45433 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab2KNWkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:40:10 -0500
Date: Wed, 14 Nov 2012 13:27:55 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-42e78e9719aa0c76711e2731b19c90fe5ae05278@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1352835171-3958-8-git-send-email-fenghua.yu@intel.com>
References: <1352835171-3958-8-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/bsp-hotplug] x86-64, hotplug: Add start_cpu0()
  entry point to head_64.S
Git-Commit-ID: 42e78e9719aa0c76711e2731b19c90fe5ae05278
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 14 Nov 2012 14:40:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42e78e9719aa0c76711e2731b19c90fe5ae05278
Gitweb:     http://git.kernel.org/tip/42e78e9719aa0c76711e2731b19c90fe5ae05278
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 13 Nov 2012 11:32:44 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 14 Nov 2012 09:39:51 -0800

x86-64, hotplug: Add start_cpu0() entry point to head_64.S

start_cpu0() is defined in head_64.S for 64-bit. The function sets up stack and
jumps to start_secondary() for CPU0 wake up.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1352835171-3958-8-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head_64.S | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 94bf9cc..980053c 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -252,6 +252,22 @@ ENTRY(secondary_startup_64)
 	pushq	%rax		# target address in negative space
 	lretq
 
+#ifdef CONFIG_HOTPLUG_CPU
+/*
+ * Boot CPU0 entry point. It's called from play_dead(). Everything has been set
+ * up already except stack. We just set up stack here. Then call
+ * start_secondary().
+ */
+ENTRY(start_cpu0)
+	movq stack_start(%rip),%rsp
+	movq	initial_code(%rip),%rax
+	pushq	$0		# fake return address to stop unwinder
+	pushq	$__KERNEL_CS	# set correct cs
+	pushq	%rax		# target address in negative space
+	lretq
+ENDPROC(start_cpu0)
+#endif
+
 	/* SMP bootup changes these two */
 	__REFDATA
 	.align	8

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab1A1Oiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:38:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:59960 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab1A1Ois (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:38:48 -0500
Date: Fri, 28 Jan 2011 14:37:56 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, penberg@kernel.org, gorcunov@gmail.com,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, gorcunov@gmail.com, mingo@elte.hu
In-Reply-To: <1295789862-25482-4-git-send-email-tj@kernel.org>
References: <1295789862-25482-4-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86: Make default_send_IPI_mask_sequence/allbutself_logical() 32bit only
Message-ID: <tip-1245e1668c6e52bee76a423f8fab3bfcdd6226ae@git.kernel.org>
Git-Commit-ID: 1245e1668c6e52bee76a423f8fab3bfcdd6226ae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 14:37:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1245e1668c6e52bee76a423f8fab3bfcdd6226ae
Gitweb:     http://git.kernel.org/tip/1245e1668c6e52bee76a423f8fab3bfcdd6226ae
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Sun, 23 Jan 2011 14:37:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Jan 2011 14:54:05 +0100

x86: Make default_send_IPI_mask_sequence/allbutself_logical() 32bit only

Both functions are used only in 32bit.  Put them inside
CONFIG_X86_32. This is to prepare for logical apicid handling
update.

- Cyrill Gorcunov spotted that I forgot to move declarations in
ipi.h   under CONFIG_X86_32.  Fixed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: eric.dumazet@gmail.com
Cc: brgerst@gmail.com
Cc: shaohui.zheng@intel.com
Cc: rientjes@google.com
LKML-Reference: <1295789862-25482-4-git-send-email-tj@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/ipi.h |    8 ++++----
 arch/x86/kernel/apic/ipi.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/ipi.h b/arch/x86/include/asm/ipi.h
index 0b72282..615fa90 100644
--- a/arch/x86/include/asm/ipi.h
+++ b/arch/x86/include/asm/ipi.h
@@ -123,10 +123,6 @@ extern void default_send_IPI_mask_sequence_phys(const struct cpumask *mask,
 						 int vector);
 extern void default_send_IPI_mask_allbutself_phys(const struct cpumask *mask,
 							 int vector);
-extern void default_send_IPI_mask_sequence_logical(const struct cpumask *mask,
-							 int vector);
-extern void default_send_IPI_mask_allbutself_logical(const struct cpumask *mask,
-							 int vector);
 
 /* Avoid include hell */
 #define NMI_VECTOR 0x02
@@ -150,6 +146,10 @@ static inline void __default_local_send_IPI_all(int vector)
 }
 
 #ifdef CONFIG_X86_32
+extern void default_send_IPI_mask_sequence_logical(const struct cpumask *mask,
+							 int vector);
+extern void default_send_IPI_mask_allbutself_logical(const struct cpumask *mask,
+							 int vector);
 extern void default_send_IPI_mask_logical(const struct cpumask *mask,
 						 int vector);
 extern void default_send_IPI_allbutself(int vector);
diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index 08385e0..5037736 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -56,6 +56,8 @@ void default_send_IPI_mask_allbutself_phys(const struct cpumask *mask,
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_X86_32
+
 void default_send_IPI_mask_sequence_logical(const struct cpumask *mask,
 						 int vector)
 {
@@ -96,8 +98,6 @@ void default_send_IPI_mask_allbutself_logical(const struct cpumask *mask,
 	local_irq_restore(flags);
 }
 
-#ifdef CONFIG_X86_32
-
 /*
  * This is only used on smaller machines.
  */

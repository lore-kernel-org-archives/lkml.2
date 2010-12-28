Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab0L1Lv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 06:51:59 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59564 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab0L1LtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 06:49:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=YKfDD7oSiiOgF8o+aXbbcI7YpKDjmEIEcoIAV0uSoOB8Yq6hmim0gvmIaBd49B5aA+
         jlbraZOjygnaycqXAjB7Aqc0SUBcbeZMPfwCHTgABI1bTyJ10KszacLRBlVs0ouZk6M0
         YRsMH2UeIws7+pzyPsqZsjkSsmG17Gvqrub+w=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/16] x86: Make default_send_IPI_mask_sequence/allbutself_logical() 32bit only
Date: Tue, 28 Dec 2010 12:48:36 +0100
Message-Id: <1293536929-31683-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293536929-31683-1-git-send-email-tj@kernel.org>
References: <1293536929-31683-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both functions are used only in 32bit.  Put them inside CONFIG_X86_32.
This is to prepare for logical apicid handling update.

- Cyrill Gorcunov spotted that I forgot to move declarations in ipi.h
  under CONFIG_X86_32.  Fixed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
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
-- 
1.7.1


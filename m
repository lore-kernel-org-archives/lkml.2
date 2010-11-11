Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab0KKReb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:34:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:52832 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618Ab0KKRea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:34:30 -0500
Message-ID: <4CDC2914.5060403@kernel.org>
Date: Thu, 11 Nov 2010 18:34:12 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, gorcunov@gmail.com
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Subject: [PATCH UPDATED 3/9] x86: Make default_send_IPI_mask_sequence/allbutself_logical()
 32bit only
References: <1289473363-29440-1-git-send-email-tj@kernel.org> <1289473363-29440-4-git-send-email-tj@kernel.org>
In-Reply-To: <1289473363-29440-4-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Nov 2010 17:34:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both functions are used only in 32bit.  Put them inside CONFIG_X86_32.
This is to prepare for logical apicid handling update.

- Cyrill Gorcunov spotted that I forgot to move declarations in ipi.h
  under CONFIG_X86_32.  Fixed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
---
Patch updated as per Cyrill's comment.  git tree has been updated
accordingly w/ Reviewed-by's added.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_32-numa

Thanks.

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


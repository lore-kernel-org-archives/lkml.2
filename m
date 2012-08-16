Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab2HPP4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:56:38 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:3320 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932892Ab2HPP4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:56:35 -0400
X-IronPort-AV: E=Sophos;i="4.77,778,1336363200"; 
   d="scan'208";a="205388649"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <tim@xen.org>, <Ian.Campbell@citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Dave Martin <dave.martin@linaro.org>
Subject: [PATCH v3 22/25] xen/arm: use the __HVC macro
Date: Thu, 16 Aug 2012 16:36:14 +0100
Message-ID: <1345131377-14713-22-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: This patch depends on Dave Martin's patch series "ARM: opcodes:
Facilitate custom opcode injection".

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Dave Martin <dave.martin@linaro.org>
---
 arch/arm/xen/hypercall.S |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm/xen/hypercall.S b/arch/arm/xen/hypercall.S
index 074f5ed..71f7239 100644
--- a/arch/arm/xen/hypercall.S
+++ b/arch/arm/xen/hypercall.S
@@ -48,20 +48,16 @@
 
 #include <linux/linkage.h>
 #include <asm/assembler.h>
+#include <asm/opcodes-virt.h>
 #include <xen/interface/xen.h>
 
 
-/* HVC 0xEA1 */
-#ifdef CONFIG_THUMB2_KERNEL
-#define xen_hvc .word 0xf7e08ea1
-#else
-#define xen_hvc .word 0xe140ea71
-#endif
+#define XEN_IMM 0xEA1
 
 #define HYPERCALL_SIMPLE(hypercall)		\
 ENTRY(HYPERVISOR_##hypercall)			\
 	mov r12, #__HYPERVISOR_##hypercall;	\
-	xen_hvc;							\
+	__HVC(XEN_IMM);						\
 	mov pc, lr;							\
 ENDPROC(HYPERVISOR_##hypercall)
 
@@ -76,7 +72,7 @@ ENTRY(HYPERVISOR_##hypercall)			\
 	stmdb sp!, {r4}						\
 	ldr r4, [sp, #4]					\
 	mov r12, #__HYPERVISOR_##hypercall;	\
-	xen_hvc								\
+	__HVC(XEN_IMM);						\
 	ldm sp!, {r4}						\
 	mov pc, lr							\
 ENDPROC(HYPERVISOR_##hypercall)
@@ -100,7 +96,7 @@ ENTRY(privcmd_call)
 	mov r2, r3
 	ldr r3, [sp, #8]
 	ldr r4, [sp, #4]
-	xen_hvc
+	__HVC(XEN_IMM)
 	ldm sp!, {r4}
 	mov pc, lr
 ENDPROC(privcmd_call);
-- 
1.7.2.5


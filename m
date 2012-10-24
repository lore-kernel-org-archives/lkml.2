Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934988Ab2JXP0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:26:41 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:1621 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934874Ab2JXP0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:26:39 -0400
X-IronPort-AV: E=Sophos;i="4.80,640,1344211200"; 
   d="scan'208";a="15362659"
Date: Wed, 24 Oct 2012 16:26:08 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Tim (Xen.org)" <tim@xen.org>, Ian Campbell <Ian.Campbell@citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Dave Martin <dave.martin@linaro.org>
Subject: [PATCH RESEND] xen/arm: use the __HVC macro
In-Reply-To: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1210241624400.2689@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new __HVC macro in hypercall.S.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

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

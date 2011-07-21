Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1GUJS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:18:58 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:57243 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab1GUJSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:18:46 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 07/10] um: Set __HAVE_ARCH_GATE_AREA for x86_64
Date: Thu, 21 Jul 2011 11:18:31 +0200
Message-Id: <1311239914-8301-7-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311239914-8301-1-git-send-email-richard@nod.at>
References: <1311239914-8301-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement arch_vma_name() and make get_gate_vma(),
in_gate_area() and in_gate_area_no_mm() a nop.

We need arch_vma_name() to support vDSO.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/sys-x86_64/asm/elf.h |    1 +
 arch/um/sys-x86_64/mem.c     |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/um/sys-x86_64/asm/elf.h b/arch/um/sys-x86_64/asm/elf.h
index d6d5af3..74eb0ac 100644
--- a/arch/um/sys-x86_64/asm/elf.h
+++ b/arch/um/sys-x86_64/asm/elf.h
@@ -119,4 +119,5 @@ extern long elf_aux_hwcap;
 
 #define SET_PERSONALITY(ex) do ; while(0)
 
+#define __HAVE_ARCH_GATE_AREA 1
 #endif
diff --git a/arch/um/sys-x86_64/mem.c b/arch/um/sys-x86_64/mem.c
index 3f8df8a..055cea0 100644
--- a/arch/um/sys-x86_64/mem.c
+++ b/arch/um/sys-x86_64/mem.c
@@ -14,3 +14,25 @@ unsigned long vm_data_default_flags = __VM_DATA_DEFAULT_FLAGS;
 unsigned long vm_data_default_flags32 = __VM_DATA_DEFAULT_FLAGS;
 unsigned long vm_force_exec32 = PROT_EXEC;
 
+const char *arch_vma_name(struct vm_area_struct *vma)
+{
+	if (vma->vm_mm && vma->vm_start == um_vdso_addr)
+		return "[vdso]";
+
+	return NULL;
+}
+
+struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
+{
+	return NULL;
+}
+
+int in_gate_area(struct mm_struct *mm, unsigned long addr)
+{
+	return 0;
+}
+
+int in_gate_area_no_mm(unsigned long addr)
+{
+	return 0;
+}
-- 
1.7.6


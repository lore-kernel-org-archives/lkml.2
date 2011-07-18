Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab1GRNHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:07:47 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:44036 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab1GRNHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:07:45 -0400
From: Richard Weinberger <richard@nod.at>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/3] um: Set __HAVE_ARCH_GATE_AREA
Date: Mon, 18 Jul 2011 15:07:35 +0200
Message-Id: <1310994456-14142-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310994456-14142-1-git-send-email-richard@nod.at>
References: <1310994456-14142-1-git-send-email-richard@nod.at>
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
index 3f8df8a..1bf301e 100644
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
+	return 0;
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


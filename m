Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030534Ab2CUG5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 02:57:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39114 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030281Ab2CUG5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 02:57:02 -0400
Subject: [PATCH 11/16] mm/s390: use vm_flags_t for vma flags
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-s390@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com
Date: Wed, 21 Mar 2012 10:56:58 +0400
Message-ID: <20120321065658.13852.52636.stgit@zurg>
In-Reply-To: <20120321065140.13852.52315.stgit@zurg>
References: <20120321065140.13852.52315.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 arch/s390/mm/fault.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index b17c42d..f8909e5 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -260,7 +260,7 @@ static noinline void do_fault_error(struct pt_regs *regs, int fault)
  *   11       Page translation     ->  Not present       (nullification)
  *   3b       Region third trans.  ->  Not present       (nullification)
  */
-static inline int do_exception(struct pt_regs *regs, int access)
+static inline int do_exception(struct pt_regs *regs, vm_flags_t access)
 {
 	struct task_struct *tsk;
 	struct mm_struct *mm;
@@ -399,7 +399,8 @@ void __kprobes do_protection_exception(struct pt_regs *regs)
 
 void __kprobes do_dat_exception(struct pt_regs *regs)
 {
-	int access, fault;
+	int fault;
+	vm_flags_t access;
 
 	access = VM_READ | VM_EXEC | VM_WRITE;
 	fault = do_exception(regs, access);
@@ -441,7 +442,8 @@ no_context:
 int __handle_fault(unsigned long uaddr, unsigned long pgm_int_code, int write)
 {
 	struct pt_regs regs;
-	int access, fault;
+	int fault;
+	vm_flags_t access;
 
 	regs.psw.mask = psw_kernel_bits | PSW_MASK_DAT | PSW_MASK_MCHECK;
 	if (!irqs_disabled())


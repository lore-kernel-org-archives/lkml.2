Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030692Ab2CUG6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 02:58:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39114 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030257Ab2CUG5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 02:57:10 -0400
Subject: [PATCH 13/16] mm/parisc: use vm_flags_t for vma flags
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Helge Deller <deller@gmx.de>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Date: Wed, 21 Mar 2012 10:57:06 +0400
Message-ID: <20120321065706.13852.68934.stgit@zurg>
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
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
---
 arch/parisc/mm/fault.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/mm/fault.c b/arch/parisc/mm/fault.c
index 18162ce..0d3680a 100644
--- a/arch/parisc/mm/fault.c
+++ b/arch/parisc/mm/fault.c
@@ -49,7 +49,7 @@ DEFINE_PER_CPU(struct exception_data, exception_data);
  *   VM_WRITE if write operation
  *   VM_EXEC  if execute operation
  */
-static unsigned long
+static vm_flags_t
 parisc_acctyp(unsigned long code, unsigned int inst)
 {
 	if (code == 6 || code == 16)
@@ -173,7 +173,7 @@ void do_page_fault(struct pt_regs *regs, unsigned long code,
 	struct vm_area_struct *vma, *prev_vma;
 	struct task_struct *tsk = current;
 	struct mm_struct *mm = tsk->mm;
-	unsigned long acc_type;
+	vm_flags_t acc_type;
 	int fault;
 
 	if (in_atomic() || !mm)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab2EaLwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 07:52:33 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:56309 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab2EaLwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 07:52:31 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>
Date: Thu, 31 May 2012 17:16:30 +0530
Message-Id: <20120531114630.23691.33166.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH 1/3] uprobes/core: Remove redundant lock_page/unlock_page
x-cbid: 12053102-3568-0000-0000-000001E7C02D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

No need to lock the page when copying the opcode in read_opcode().

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/events/uprobes.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 42b21eb..b3f3095 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -315,12 +315,10 @@ static int read_opcode(struct mm_struct *mm, unsigned long vaddr, uprobe_opcode_
 	if (ret <= 0)
 		return ret;
 
-	lock_page(page);
 	vaddr_new = kmap_atomic(page);
 	vaddr &= ~PAGE_MASK;
 	memcpy(opcode, vaddr_new + vaddr, UPROBE_SWBP_INSN_SIZE);
 	kunmap_atomic(vaddr_new);
-	unlock_page(page);
 
 	put_page(page);
 



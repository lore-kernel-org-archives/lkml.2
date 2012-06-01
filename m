Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225Ab2FAJWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:22:21 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60455 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758513Ab2FAJWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:22:20 -0400
Date: Fri, 1 Jun 2012 14:49:50 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>
Subject: [RESEND PATCH 1/3] uprobes: Remove redundant lock_page/unlock_page
Message-ID: <20120601091950.GF24279@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120531114630.23691.33166.sendpatchset@srdronam.in.ibm.com>
 <1338465518.28384.55.camel@twins>
 <20120531150756.GC24279@linux.vnet.ibm.com>
 <1338483372.28384.65.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1338483372.28384.65.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060109-3534-0000-0000-000008F2FBFD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Since read_opcode() reads from the referenced page and doesnt modify
the page contents nor the page attributes, there is no need to lock
the page.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 Modified changelog based on comments from Peter Zijlstra

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
 


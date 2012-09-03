Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab2ICPYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 11:24:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab2ICPYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 11:24:09 -0400
Date: Mon, 3 Sep 2012 17:26:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] uprobes: Make arch_uprobe_task->saved_trap_nr
	"unsigned int"
Message-ID: <20120903152620.GA9088@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120903152525.GA9028@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make arch_uprobe_task->saved_trap_nr "unsigned int" and move it down
after ->saved_scratch_register, this changes sizeof() from 24 to 16.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/uprobes.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index d561ff5..8ff8be7 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -42,10 +42,10 @@ struct arch_uprobe {
 };
 
 struct arch_uprobe_task {
-	unsigned long			saved_trap_nr;
 #ifdef CONFIG_X86_64
 	unsigned long			saved_scratch_register;
 #endif
+	unsigned int			saved_trap_nr;
 	unsigned int			saved_tf;
 };
 
-- 
1.5.5.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab2J1Rif (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 13:38:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab2J1Rie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 13:38:34 -0400
Date: Sun, 28 Oct 2012 18:39:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] uprobes/powerpc: Don't clear TIF_UPROBE in
	do_notify_resume()
Message-ID: <20121028173925.GA14642@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121028173900.GA14621@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup. No need to clear TIF_UPROBE, do_notify_resume() does this.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/powerpc/kernel/signal.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index a2dc757..3b99711 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -158,10 +158,8 @@ static int do_signal(struct pt_regs *regs)
 
 void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
 {
-	if (thread_info_flags & _TIF_UPROBE) {
-		clear_thread_flag(TIF_UPROBE);
+	if (thread_info_flags & _TIF_UPROBE)
 		uprobe_notify_resume(regs);
-	}
 
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
-- 
1.5.5.1


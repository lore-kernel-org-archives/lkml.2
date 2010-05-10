Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab0EJRs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:48:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426Ab0EJRsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:48:46 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 1/5] [CLEANUP] kprobes: Remove redundant text_mutex lock
	in optimize
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Mon, 10 May 2010 13:53:20 -0400
Message-ID: <20100510175320.27396.49896.stgit@localhost6.localdomain6>
In-Reply-To: <20100510175313.27396.34605.stgit@localhost6.localdomain6>
References: <20100510175313.27396.34605.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove text_mutex locking in optimize_all_kprobes, because
that function doesn't modify text but just order optimization
to worker.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---

 kernel/kprobes.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 282035f..1d34eef 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -606,14 +606,12 @@ static void __kprobes optimize_all_kprobes(void)
 		return;
 
 	kprobes_allow_optimization = true;
-	mutex_lock(&text_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist)
 			if (!kprobe_disabled(p))
 				optimize_kprobe(p);
 	}
-	mutex_unlock(&text_mutex);
 	printk(KERN_INFO "Kprobes globally optimized\n");
 }
 


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com

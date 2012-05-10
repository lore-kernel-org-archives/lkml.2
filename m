Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab2EJMUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:20:10 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47374 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755015Ab2EJMUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:20:08 -0400
Subject: [PATCH v2] sched: taint kernel with TAINT_WARN after sleep-in-atomic
 bug
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 10 May 2012 16:20:04 +0400
Message-ID: <20120510122004.4873.12726.stgit@zurg>
In-Reply-To: <1336650398.27020.91.camel@laptop>
References: <1336650398.27020.91.camel@laptop>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually sleep-in-atomic bugs are followed by dozens other warnings.
This patch should help to figure out original source of problem.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 kernel/sched/core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0533a68..b6458e4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3113,6 +3113,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
 	dump_stack();
+	add_taint(TAINT_WARN);
 }
 
 /*


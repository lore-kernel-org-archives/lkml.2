Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab1FJNac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:30:32 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40858 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814Ab1FJNaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:30:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TQShAsugVED7ajPEZHpCg6CLqYhm7lKmCCUmKJS2HlQWvkwLkUU8e2ByQQFIpiHDqH
         +nUQZftgNKQult+x9I4MusClcaY+jG1RL88kWEGZlFNqVuY04N1tMJLdgQ5rs+1Ay5dz
         gxmZ+swVy+xt4U8VCow7L5horyUYBwgEpqtfE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/4] sched: Remove pointless in_atomic() definition check
Date: Fri, 10 Jun 2011 15:30:19 +0200
Message-Id: <1307712622-11104-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1307712622-11104-1-git-send-email-fweisbec@gmail.com>
References: <1307712622-11104-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's really supposed to be defined here. If it's not then
we actually want the build to crash so that we know it,
and not keep it silent.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index fd18f39..01d9536 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8028,7 +8028,6 @@ static inline int preempt_count_equals(int preempt_offset)
 
 void __might_sleep(const char *file, int line, int preempt_offset)
 {
-#ifdef in_atomic
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
 	if ((preempt_count_equals(preempt_offset) && !irqs_disabled()) ||
@@ -8050,7 +8049,6 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 	if (irqs_disabled())
 		print_irqtrace_events(current);
 	dump_stack();
-#endif
 }
 EXPORT_SYMBOL(__might_sleep);
 #endif
-- 
1.7.5.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1FHRss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 13:48:48 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35125 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab1FHRsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:48:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uI8YlZqK0nMg6ObFzpmToQDh1GZoiaEKO40kTDlUH5jYy4sEsGCumXkKFuPfGwGHLl
         FyXKQ2c7DlwpH4rqOZjcf0OWEnUtEUSQKINXTI9IsR3L6xO/aztZtFc0Vf88jtdzYKnQ
         XSJhIED27L3q0wNhw6gSb7c7LdGOxEJsIxUUE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/4] sched: Remove pointless in_atomic() definition check
Date: Wed,  8 Jun 2011 19:48:32 +0200
Message-Id: <1307555315-30989-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1307555315-30989-1-git-send-email-fweisbec@gmail.com>
References: <1307555315-30989-1-git-send-email-fweisbec@gmail.com>
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


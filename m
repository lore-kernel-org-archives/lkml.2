Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab0CXRfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:35:21 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:38549 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab0CXRfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=DRqBAUTQwFxCoaN4oGjnKcF10GVvZ5PEZmtY7GGnvLJM15aquNmm5u7sOwjxJrt55d
         k3zTWLiGrdSjwXV3rK+8BfuwV1C6FfwX0jVc/oyw9q6QHCnYE97Q37MZebkCasP7ESYM
         Pgkut0jTIUyw/rFgSNAnaTnb8aDlMTuUlihLc=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       John Kacur <jkacur@redhat.com>, Clark Williams <williams@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/2] Revert "rt: trivial fix to REMINDER block in init/main.c"
Date: Wed, 24 Mar 2010 18:35:06 +0100
Message-Id: <1269452107-28655-2-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1269452107-28655-1-git-send-email-jkacur@redhat.com>
References: <1269452107-28655-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 3e39399ef4a742d994570488994be93ef17d4ef5.

CONFIG_STACK_TRACER really should not be in the reminder block.
By default it is not enabled, and has negligible impact.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 init/main.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/init/main.c b/init/main.c
index 48393c0..aa48b7b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -928,9 +928,6 @@ static int __init kernel_init(void * unused)
 #ifdef CONFIG_PREEMPT_TRACER
 	printk(KERN_ERR "*        CONFIG_PREEMPT_TRACER                                              *\n");
 #endif
-#ifdef CONFIG_STACK_TRACER
-	printk(KERN_ERR "*        CONFIG_STACK_TRACER                                                *\n");
-#endif
 #if defined(CONFIG_FTRACE) && !defined(CONFIG_FTRACE_MCOUNT_RECORD)
 	printk(KERN_ERR "*        CONFIG_FTRACE                                                      *\n");
 #endif
-- 
1.6.6.1


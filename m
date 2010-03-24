Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab0CXQpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:45:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756147Ab0CXQpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:45:44 -0400
Date: Wed, 24 Mar 2010 17:42:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm]
	signals-clear-signal-tty-when-the-last-thread-exits.fix
Message-ID: <20100324164255.GA7472@redhat.com>
References: <20100319184020.GA519@redhat.com> <20100324142348.GA8117@redhat.com> <20100324074149.8d4e96e6.akpm@linux-foundation.org> <20100324160242.GA32557@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324160242.GA32557@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't get this warning, but the old gcc complains

	kernel/exit.c: In function 'release_task':
	kernel/exit.c:85: warning: 'tty' may be used uninitialized in this function

This clearly wrong, to the point it blames release_task() instead of
__exit_signal(). But let's make compiler happy anyway.

Thanks Andrew, now I know we have the handy uninitialized_var() helper ;)

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 34-rc1/kernel/exit.c~FIX_EXIT_SIGNAL_TTY_WARNING	2010-03-21 18:36:44.000000000 +0100
+++ 34-rc1/kernel/exit.c	2010-03-24 17:36:32.000000000 +0100
@@ -82,7 +82,7 @@ static void __exit_signal(struct task_st
 	struct signal_struct *sig = tsk->signal;
 	bool group_dead = thread_group_leader(tsk);
 	struct sighand_struct *sighand;
-	struct tty_struct *tty;
+	struct tty_struct *uninitialized_var(tty);
 
 	BUG_ON(!sig);
 	BUG_ON(!atomic_read(&sig->count));


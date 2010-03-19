Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0CSSmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 14:42:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab0CSSmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 14:42:24 -0400
Date: Fri, 19 Mar 2010 19:40:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] make task_struct->signal stable
Message-ID: <20100319184013.GA504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depends on

	[PATCH 1/4] exit: exit_notify() can trust signal->notify_count < 0
	[PATCH 2/4] exit: change zap_other_threads() to count sub-threads
	[PATCH 3/4] exit: avoid sig->count in de_thread/__exit_signal synchronization
	[PATCH 4/4] exit: avoid sig->count in __exit_signal() to detect the group-dead case

	[PATCH 1/2] posix-cpu-timers: avoid "task->signal != NULL" checks
	[PATCH 2/2] ia64: ptrace_attach_sync_user_rbs: avoid "task->signal != NULL" checks

	[PATCH] move tty_kref_put() outside of __cleanup_signal()

See the changelog in 1/3. IIRC, this was suggested by Ingo a long ago.

Note! This series is not complete, it needs some conclusive cleanups and
a lot more cleanups are possible because task->signal is never NULL. 3/3
is the "random" example.

Oleg.


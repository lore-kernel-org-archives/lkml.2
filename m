Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934939Ab1ETQJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:09:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934583Ab1ETQJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:09:38 -0400
Date: Fri, 20 May 2011 18:07:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ptrace/signal changes for v2.6.40
Message-ID: <20110520160733.GA24897@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc.git ptrace

This starts the Tejun's ptrace/jobctl rework, initial fixes and cleanups.
Plus sigprocmask fixes, those which were reviewed/acked.

Oleg Nesterov (19):
      signal: prepare_signal(SIGCONT) shouldn't play with TIF_SIGPENDING
      signal: do_signal_stop: Remove the unneeded task_clear_group_stop_pending()
      signal: Turn SIGNAL_STOP_DEQUEUED into GROUP_STOP_DEQUEUED
      ptrace: ptrace_check_attach() should not do s/STOPPED/TRACED/
      signal: introduce retarget_shared_pending()
      signal: retarget_shared_pending: consider shared/unblocked signals only
      signal: retarget_shared_pending: optimize while_each_thread() loop
      signal: sigprocmask: narrow the scope of ->siglock
      signal: sigprocmask() should do retarget_shared_pending()
      x86: signal: handle_signal() should use set_current_blocked()
      x86: signal: sys_rt_sigreturn() should use set_current_blocked()
      signal: cleanup sys_rt_sigprocmask()
      signal: sys_rt_sigtimedwait: simplify the timeout logic
      signal: introduce do_sigtimedwait() to factor out compat/native code
      signal: do_sigtimedwait() needs retarget_shared_pending()
      signal: rename signandsets() to sigandnsets()
      signal: cleanup sys_sigprocmask()
      signal: sys_sigprocmask() needs retarget_shared_pending()
      signal: trivial, fix the "timespec declared inside parameter list" warning

Tejun Heo (22):
      signal: Fix SIGCONT notification code
      ptrace: Remove the extra wake_up_state() from ptrace_detach()
      signal: Remove superflous try_to_freeze() loop in do_signal_stop()
      ptrace: Kill tracehook_notify_jctl()
      ptrace: Add @why to ptrace_stop()
      signal: Fix premature completion of group stop when interfered by ptrace
      signal: Use GROUP_STOP_PENDING to stop once for a single group stop
      ptrace: Participate in group stop from ptrace_stop() iff the task is trapping for group stop
      ptrace: Make do_signal_stop() use ptrace_stop() if the task is being ptraced
      ptrace: Clean transitions between TASK_STOPPED and TRACED
      ptrace: Collapse ptrace_untrace() into __ptrace_unlink()
      ptrace: Always put ptracee into appropriate execution state
      job control: Don't set group_stop exit_code if re-entering job control stop
      job control: Small reorganization of wait_consider_task()
      job control: Fix ptracer wait(2) hang and explain notask_error clearing
      job control: Allow access to job control events through ptracees
      job control: Add @for_ptrace to do_notify_parent_cldstop()
      job control: Job control stop notifications should always go to the real parent
      job control: Notify the real parent of job control events regardless of ptrace
      job control: Don't send duplicate job control stop notification while ptraced
      ptrace: fix signal->wait_chldexit usage in task_clear_group_stop_trapping()
      job control: reorganize wait_task_stopped()

 arch/x86/kernel/signal.c  |   14 +-
 fs/exec.c                 |    1 +
 include/linux/sched.h     |   17 +-
 include/linux/signal.h    |   13 +-
 include/linux/tracehook.h |   27 --
 kernel/compat.c           |   47 +---
 kernel/exit.c             |  110 ++++++--
 kernel/ptrace.c           |  118 ++++++---
 kernel/signal.c           |  678 ++++++++++++++++++++++++++++++---------------
 9 files changed, 659 insertions(+), 366 deletions(-)


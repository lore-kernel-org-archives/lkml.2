Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933854Ab1KCP5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 11:57:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38477 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933689Ab1KCP5W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 11:57:22 -0400
MIME-Version: 1.0
Date: Thu, 3 Nov 2011 11:57:20 -0400
Message-ID: <CAHFgRy8S0xLfhZxTUOEH5A0PL_Fb79-0-gmbQ=9h2D-xMqt1hA@mail.gmail.com>
Subject: Linus GIT - INFO: possible circular locking dependency detected
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ec7ae517537ae5c7b0b2cd7f562dfa3e7a05b954
43672a0784707d795556b1f93925da8b8e797d03 root <root@Hogwarts.(none)>
1320325324 -0400	pull : Fast-forward

[ INFO: possible circular locking dependency detected ]
 3.1.0+ #22
 -------------------------------------------------------
 udevd/844 is trying to acquire lock:
  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff8113b0a5>]
lock_trace+0x1f/0x54

 but task is already holding lock:
  (&sb->s_type->i_mutex_key#6){+.+.+.}, at: [<ffffffff810f7554>]
walk_component+0x1f5/0x3ef

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 (&sb->s_type->i_mutex_key#6){+.+.+.}:
        [<ffffffff810687ad>] lock_acquire+0x130/0x155
        [<ffffffff8140f5a7>] __mutex_lock_common+0x64/0x413
        [<ffffffff8140f9b5>] mutex_lock_nested+0x16/0x18
        [<ffffffff810f7554>] walk_component+0x1f5/0x3ef
        [<ffffffff810f7deb>] link_path_walk+0x17c/0x41f
        [<ffffffff810f9d3a>] path_openat+0xad/0x30b
        [<ffffffff810fa081>] do_filp_open+0x33/0x81
        [<ffffffff810f1f19>] open_exec+0x20/0x96
        [<ffffffff810f3a45>] do_execve_common.isra.31+0xf7/0x2e2
        [<ffffffff810f3c46>] do_execve+0x16/0x18
        [<ffffffff81008c30>] sys_execve+0x3e/0x55
        [<ffffffff81416c1c>] stub_execve+0x6c/0xc0

 -> #0 (&sig->cred_guard_mutex){+.+.+.}:
        [<ffffffff81067f6b>] __lock_acquire+0xa81/0xd75
        [<ffffffff810687ad>] lock_acquire+0x130/0x155
        [<ffffffff8140f5a7>] __mutex_lock_common+0x64/0x413
        [<ffffffff8140f984>] mutex_lock_killable_nested+0x16/0x18
        [<ffffffff8113b0a5>] lock_trace+0x1f/0x54
        [<ffffffff8113b493>] proc_lookupfd_common+0x48/0x8c
        [<ffffffff8113b4f9>] proc_lookupfd+0x10/0x12
        [<ffffffff810f66a0>] d_alloc_and_lookup+0x40/0x67
        [<ffffffff810f757a>] walk_component+0x21b/0x3ef
        [<ffffffff810f7784>] lookup_last+0x36/0x38
        [<ffffffff810f844f>] path_lookupat+0x7d/0x297
        [<ffffffff810f868b>] do_path_lookup+0x22/0x91
        [<ffffffff810fa001>] user_path_at_empty+0x4e/0x8d
        [<ffffffff810fa04c>] user_path_at+0xc/0xe
        [<ffffffff810f16f4>] vfs_fstatat+0x35/0x5f
        [<ffffffff810f174f>] vfs_stat+0x16/0x18
        [<ffffffff810f1835>] sys_newstat+0x15/0x2e
        [<ffffffff8141677b>] system_call_fastpath+0x16/0x1b

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&sb->s_type->i_mutex_key);
                                lock(&sig->cred_guard_mutex);
                                lock(&sb->s_type->i_mutex_key);
   lock(&sig->cred_guard_mutex);

  *** DEADLOCK ***

 1 lock held by udevd/844:
  #0:  (&sb->s_type->i_mutex_key#6){+.+.+.}, at: [<ffffffff810f7554>]
walk_component+0x1f5/0x3ef

 stack backtrace:
 Pid: 844, comm: udevd Not tainted 3.1.0+ #22
 Call Trace:
  [<ffffffff81408043>] print_circular_bug+0x1f8/0x209
  [<ffffffff81067f6b>] __lock_acquire+0xa81/0xd75
  [<ffffffff8106611e>] ? mark_lock+0x2d/0x258
  [<ffffffff81068250>] ? __lock_acquire+0xd66/0xd75
  [<ffffffff8113b0a5>] ? lock_trace+0x1f/0x54
  [<ffffffff810687ad>] lock_acquire+0x130/0x155
  [<ffffffff8113b0a5>] ? lock_trace+0x1f/0x54
  [<ffffffff8140f5a7>] __mutex_lock_common+0x64/0x413
  [<ffffffff8113b0a5>] ? lock_trace+0x1f/0x54
  [<ffffffff8104f57c>] ? free_pidmap+0x2e/0x2e
  [<ffffffff8113b0a5>] ? lock_trace+0x1f/0x54
  [<ffffffff8113bc10>] ? proc_fdinfo_instantiate+0x81/0x81
  [<ffffffff8113bc10>] ? proc_fdinfo_instantiate+0x81/0x81
  [<ffffffff8140f984>] mutex_lock_killable_nested+0x16/0x18
  [<ffffffff8113b0a5>] lock_trace+0x1f/0x54
  [<ffffffff8113b493>] proc_lookupfd_common+0x48/0x8c
  [<ffffffff8113b4f9>] proc_lookupfd+0x10/0x12
  [<ffffffff810f66a0>] d_alloc_and_lookup+0x40/0x67
  [<ffffffff810f757a>] walk_component+0x21b/0x3ef
  [<ffffffff810f7784>] lookup_last+0x36/0x38
  [<ffffffff810f844f>] path_lookupat+0x7d/0x297
  [<ffffffff810cf9f6>] ? might_fault+0x3b/0x8b
  [<ffffffff810f6d90>] ? getname_flags+0x2b/0x204
  [<ffffffff81204810>] ? __strncpy_from_user+0x19/0x43
  [<ffffffff810f868b>] do_path_lookup+0x22/0x91
  [<ffffffff810fa001>] user_path_at_empty+0x4e/0x8d
  [<ffffffff814138b9>] ? sub_preempt_count+0x8f/0xa2
  [<ffffffff81410aad>] ? _raw_spin_unlock_irqrestore+0x5b/0x69
  [<ffffffff8140aceb>] ? __slab_free+0x14f/0x19e
  [<ffffffff810fa04c>] user_path_at+0xc/0xe
  [<ffffffff810f16f4>] vfs_fstatat+0x35/0x5f
  [<ffffffff81066582>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff810f174f>] vfs_stat+0x16/0x18
  [<ffffffff810f1835>] sys_newstat+0x15/0x2e
  [<ffffffff8106652f>] ? trace_hardirqs_on_caller+0x151/0x197
  [<ffffffff812044be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff8141677b>] system_call_fastpath+0x16/0x1b

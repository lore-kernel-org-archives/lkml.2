Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132Ab2EKPnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:43:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35205 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab2EKPng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:43:36 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 11 May 2012 08:43:14 -0700
X-Google-Sender-Auth: kOvNisXsDGRY5bz9blqa4rzSWCw
Message-ID: <CA+55aFzNQqa9nuhZUog-+B0SfU6ip_QSt73R=2Du=M2ua1cFBA@mail.gmail.com>
Subject: Perf events warning..
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, Ingo, Arnaldo,
 google doesn't find a warning like this, so it can't be *too*
commonly reported.

Anyway, doing some profiling of git "make test" (wonderful load for
doing lots of small processes that do lots of page faults etc), this
WARN_ON_ONCE() triggered:

    ------------[ cut here ]------------
    WARNING: at kernel/events/core.c:2066 task_ctx_sched_out+0x63/0x70()
    Hardware name: System Product Name
    Pid: 18120, comm: git Not tainted 3.4.0-rc6-00089-g4a01c681d58f-dirty #3
    Call Trace:
     [<ffffffff810308c5>] warn_slowpath_common+0x75/0xb0
     [<ffffffff810309c5>] warn_slowpath_null+0x15/0x20
     [<ffffffff81096d63>] task_ctx_sched_out+0x63/0x70
     [<ffffffff8109af06>] perf_event_comm+0x1d6/0x2e0
     [<ffffffff81368ba8>] ? get_random_int+0x88/0xb0
     [<ffffffff8102e1e2>] ? __mmdrop+0x62/0x90
     [<ffffffff810e1f93>] set_task_comm+0x63/0x80
     [<ffffffff810e3206>] setup_new_exec+0x86/0x250
     [<ffffffff81126b69>] load_elf_binary+0x389/0x1930
     [<ffffffff81125222>] ? load_misc_binary+0x292/0x390
     [<ffffffff810bcbdd>] ? get_user_pages+0x4d/0x50
     [<ffffffff810e13b2>] ? get_arg_page+0xa2/0xd0
     [<ffffffff810e2b65>] search_binary_handler+0xd5/0x200
     [<ffffffff811267e0>] ? elf_map+0x170/0x170
     [<ffffffff810e300d>] do_execve_common.clone.39+0x37d/0x430
     [<ffffffff810e30d6>] do_execve+0x16/0x20
     [<ffffffff8100ab75>] sys_execve+0x45/0x70
     [<ffffffff816b10ac>] stub_execve+0x6c/0xc0
    ---[ end trace 6fccf3db70f1b560 ]---

any comments/ideas?

(That kernel version isn't one you'd find in any git tree - it's a
throw-away tree with some experimental patches for dcache cleanups
etc. But those patches should not matter at all for this kind of
thing)

                          Linus

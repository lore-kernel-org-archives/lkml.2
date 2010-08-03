Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab0HCA4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 20:56:37 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56753 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab0HCA4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 20:56:34 -0400
Message-Id: <201008030055.o730tgXK091413@www262.sakura.ne.jp>
Subject: Re: [PATCH 2/2] CRED: Fix __task_cred()'s lockdep check and banner comment
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: paulmck@linux.vnet.ibm.com
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        David Howells <dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 03 Aug 2010 09:55:42 +0900
References: <20100729114549.29508.44899.stgit@warthog.procyon.org.uk> <20100729114555.29508.4525.stgit@warthog.procyon.org.uk> <20100802204000.GH2405@linux.vnet.ibm.com>
In-Reply-To: <20100802204000.GH2405@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 27072010 #3944634, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got below warning. Is this related to this patch?

[  140.173556] ===================================================
[  140.215379] [ INFO: suspicious rcu_dereference_check() usage. ]
[  140.216461] ---------------------------------------------------
[  140.217530] kernel/signal.c:660 invoked rcu_dereference_check() without protection!
[  140.218937] 
[  140.218938] other info that might help us debug this:
[  140.218939] 
[  140.220508] 
[  140.220509] rcu_scheduler_active = 1, debug_locks = 1
[  140.221991] 1 lock held by init/1:
[  140.222668]  #0:  (tasklist_lock){.+.+..}, at: [<c104a0ac>] kill_something_info+0x7c/0x160
[  140.224709] 
[  140.224711] stack backtrace:
[  140.225661] Pid: 1, comm: init Not tainted 2.6.35 #1
[  140.226576] Call Trace:
[  140.227111]  [<c103cca8>] ? printk+0x18/0x20
[  140.227908]  [<c1069884>] lockdep_rcu_dereference+0x94/0xb0
[  140.228931]  [<c104936a>] check_kill_permission+0x15a/0x170
[  140.229932]  [<c104a0ac>] ? kill_something_info+0x7c/0x160
[  140.230921]  [<c1049cca>] group_send_sig_info+0x1a/0x50
[  140.231866]  [<c1049d36>] __kill_pgrp_info+0x36/0x60
[  140.232780]  [<c104a0d0>] kill_something_info+0xa0/0x160
[  140.233740]  [<c10831c5>] ? __call_rcu+0xa5/0x110
[  140.234596]  [<c104b7ee>] sys_kill+0x5e/0x70
[  140.235387]  [<c10d1eee>] ? mntput_no_expire+0x1e/0xa0
[  140.236329]  [<c10bbd10>] ? __fput+0x170/0x220
[  140.257756]  [<c10bbdd9>] ? fput+0x19/0x20
[  140.258529]  [<c137ad94>] ? restore_all_notrace+0x0/0x18
[  140.259496]  [<c11bfb04>] ? trace_hardirqs_on_thunk+0xc/0x10
[  140.260531]  [<c137ad61>] syscall_call+0x7/0xb
[  144.627841] nfsd: last server has exited, flushing export cache
[  154.040420] Restarting system.
[  154.041061] machine restart

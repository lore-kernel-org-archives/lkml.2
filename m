Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab2EOEly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 00:41:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab2EOElw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 00:41:52 -0400
Date: Tue, 15 May 2012 00:41:45 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: sds@tycho.nsa.gov, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: suspicious RCU usage in security/selinux/netnode.c
Message-ID: <20120515044145.GA21910@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, sds@tycho.nsa.gov,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just triggered this on Linus' current tree.

	Dave

 ===============================
 [ INFO: suspicious RCU usage. ]
 3.4.0-rc7+ #93 Not tainted
 -------------------------------
 security/selinux/netnode.c:178 suspicious rcu_dereference_check() usage!
 
 other info that might help us debug this:
 
 
 rcu_scheduler_active = 1, debug_locks = 0
 1 lock held by trinity/25132:
  #0:  (sel_netnode_lock){+.....}, at: [<ffffffff812db738>] sel_netnode_sid+0x148/0x3c0
 
 stack backtrace:
 Pid: 25132, comm: trinity Not tainted 3.4.0-rc7+ #93
 Call Trace:
  [<ffffffff810cc7cd>] lockdep_rcu_suspicious+0xfd/0x130
  [<ffffffff812db981>] sel_netnode_sid+0x391/0x3c0
  [<ffffffff812db5f0>] ? sel_netnode_find+0x1a0/0x1a0
  [<ffffffff812d4a84>] selinux_socket_bind+0x104/0x350
  [<ffffffff810a6648>] ? sched_clock_cpu+0xb8/0x130
  [<ffffffff816a47b9>] ? sub_preempt_count+0xa9/0xe0
  [<ffffffff812cb3e6>] security_socket_bind+0x16/0x20
  [<ffffffff815468aa>] sys_bind+0x7a/0x100
  [<ffffffff816a8795>] ? sysret_check+0x22/0x5d
  [<ffffffff810d149d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
  [<ffffffff810fc18c>] ? __audit_syscall_entry+0xcc/0x310
  [<ffffffff8133839e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff816a8769>] system_call_fastpath+0x16/0x1b


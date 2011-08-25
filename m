Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1HYD5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 23:57:51 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:58931 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750795Ab1HYD5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 23:57:47 -0400
Date: Wed, 24 Aug 2011 20:57:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Bug: ACPI, scheduling while atomic (was Re: [PATCH 0/4] sched:
 Make sleep inside atomic detection work on !PREEMPT)
Message-Id: <20110824205745.cd3f5f6c.rdunlap@xenotime.net>
In-Reply-To: <20110608224939.GC25771@somewhere.redhat.com>
References: <1307555315-30989-1-git-send-email-fweisbec@gmail.com>
	<20110608224939.GC25771@somewhere.redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011 00:49:41 +0200 Frederic Weisbecker wrote:

> On Wed, Jun 08, 2011 at 07:48:31PM +0200, Frederic Weisbecker wrote:
> > Aside it may mostly avoid the need for a specific PROVE_RCU
> > check when we sleep inside an rcu read side critical section.
> > 
> > Better make sleeping inside atomic sections work everywhere.
> 
> BTW, it has led to detect a bug in the ACPI code. It happens in
> !CONFIG_PREEMPT:
> 
> [    0.160187] BUG: scheduling while atomic: swapper/0/0x10000002
> [    0.166016] no locks held by swapper/0.
> [    0.170014] Modules linked in:
> [    0.173107] Pid: 0, comm: swapper Not tainted 2.6.39+ #124
> [    0.180014] Call Trace:
> [    0.182481]  [<ffffffff81048685>] __schedule_bug+0x85/0x90
> [    0.187967]  [<ffffffff817da98c>] schedule+0x75c/0xa40
> [    0.190022]  [<ffffffff8109a1fd>] ? trace_hardirqs_on+0xd/0x10
> [    0.200023]  [<ffffffff813879c0>] ? acpi_ps_free_op+0x22/0x24
> [    0.205776]  [<ffffffff810554a5>] __cond_resched+0x25/0x40
> [    0.210022]  [<ffffffff817daf3b>] _cond_resched+0x2b/0x40
> [    0.215420]  [<ffffffff81386cbe>] acpi_ps_complete_op+0x262/0x278
> [    0.220023]  [<ffffffff813874df>] acpi_ps_parse_loop+0x80b/0x960
> [    0.230023]  [<ffffffff81386607>] acpi_ps_parse_aml+0x98/0x274
> [    0.235859]  [<ffffffff81384cbb>] acpi_ns_one_complete_parse+0x103/0x120
> [    0.240021]  [<ffffffff810886da>] ? up+0x2a/0x50
> [    0.244641]  [<ffffffff81384cf3>] acpi_ns_parse_table+0x1b/0x34
> [    0.250022]  [<ffffffff8138242a>] acpi_ns_load_table+0x4a/0x8c
> [    0.260023]  [<ffffffff8138947c>] acpi_load_tables+0x9c/0x15d
> [    0.265774]  [<ffffffff81d0b0f8>] acpi_early_init+0x6c/0xf7
> [    0.270022]  [<ffffffff81cd8d31>] start_kernel+0x400/0x415
> [    0.275508]  [<ffffffff81cd8346>] x86_64_start_reservations+0x131/0x135
> [    0.280022]  [<ffffffff81cd844d>] x86_64_start_kernel+0x103/0x112
> 
> ACPI_PREEMPTION_POINT() is called from acpi_ps_complete_op() and schedules
> if !PREEMPT. But preemption is disabled as we are in early bootup.

This still happens in 3.1-rc[123].
Was there a patch for it?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

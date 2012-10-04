Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965310Ab2JDOlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 10:41:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965130Ab2JDOlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 10:41:13 -0400
Date: Thu, 4 Oct 2012 10:41:06 -0400
From: Dave Jones <davej@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: RCU_USER_QS traces.
Message-ID: <20121004144106.GB11191@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > We have CONFIG_RCU_USER_QS that is a specific case. It's an intermediate state
 > before we implement a true CONFIG_NO_HZ_FULL. But the option is useless on its
 > own for users. Worse, it introduces a real overhead. OTOH we want it to be upstream
 > to make the development of full tickless feature more incremental.

I couldn't resist trying it.. Did these get reported yet ?


WARNING: at kernel/rcutree.c:377 rcu_eqs_enter+0x93/0xa0()
Pid: 0, comm: swapper/1 Not tainted 3.6.0+ #24
Call Trace:
 [<ffffffff810678af>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8106790a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8111a383>] rcu_eqs_enter+0x93/0xa0
 [<ffffffff8111af0b>] rcu_idle_enter+0x2b/0x70
 [<ffffffff8102460f>] cpu_idle+0xbf/0x140
 [<ffffffff816ad18d>] start_secondary+0x252/0x254

WARNING: at kernel/rcutree.c:352 rcu_eqs_enter_common.isra.37+0x1c6/0x1e0()
Pid: 0, comm: swapper/1 Tainted: G        W    3.6.0+ #24
Call Trace:
 [<ffffffff810678af>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8106790a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8111a2d6>] rcu_eqs_enter_common.isra.37+0x1c6/0x1e0
 [<ffffffff8111a355>] rcu_eqs_enter+0x65/0xa0
 [<ffffffff8111af0b>] rcu_idle_enter+0x2b/0x70
 [<ffffffff8102460f>] cpu_idle+0xbf/0x140
 [<ffffffff816ad18d>] start_secondary+0x252/0x254

WARNING: at kernel/rcutree.c:539 rcu_eqs_exit+0x99/0xb0()
Pid: 0, comm: swapper/1 Tainted: G        W    3.6.0+ #24
Call Trace:
 [<ffffffff810678af>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8106790a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8111a0f9>] rcu_eqs_exit+0x99/0xb0
 [<ffffffff8111ae9b>] rcu_idle_exit+0x2b/0x70
 [<ffffffff8102461e>] cpu_idle+0xce/0x140
 [<ffffffff816ad18d>] start_secondary+0x252/0x254

WARNING: at kernel/rcutree.c:513 rcu_eqs_exit_common.isra.35+0xd4/0xe0()
Pid: 0, comm: swapper/1 Tainted: G        W    3.6.0+ #24
Call Trace:
 [<ffffffff810678af>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8106790a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8111a054>] rcu_eqs_exit_common.isra.35+0xd4/0xe0
 [<ffffffff8111a0bc>] rcu_eqs_exit+0x5c/0xb0
 [<ffffffff8111ae9b>] rcu_idle_exit+0x2b/0x70
 [<ffffffff8102461e>] cpu_idle+0xce/0x140
 [<ffffffff816ad18d>] start_secondary+0x252/0x254

	Dave


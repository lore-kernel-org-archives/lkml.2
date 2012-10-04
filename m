Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab2JDPwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 11:52:51 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55970 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab2JDPwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 11:52:49 -0400
Date: Thu, 4 Oct 2012 08:46:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: RCU_USER_QS traces.
Message-ID: <20121004154636.GC2464@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121004144106.GB11191@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004144106.GB11191@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100415-5518-0000-0000-0000082419B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 10:41:06AM -0400, Dave Jones wrote:
>  > We have CONFIG_RCU_USER_QS that is a specific case. It's an intermediate state
>  > before we implement a true CONFIG_NO_HZ_FULL. But the option is useless on its
>  > own for users. Worse, it introduces a real overhead. OTOH we want it to be upstream
>  > to make the development of full tickless feature more incremental.
> 
> I couldn't resist trying it.. Did these get reported yet ?

News to me...  Thank you for the testing!

And yes, please do not enable CONFIG_RCU_USER_QS in your distro.  ;-)

							Thanx, Paul

> WARNING: at kernel/rcutree.c:377 rcu_eqs_enter+0x93/0xa0()
> Pid: 0, comm: swapper/1 Not tainted 3.6.0+ #24
> Call Trace:
>  [<ffffffff810678af>] warn_slowpath_common+0x7f/0xc0
>  [<ffffffff8106790a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff8111a383>] rcu_eqs_enter+0x93/0xa0
>  [<ffffffff8111af0b>] rcu_idle_enter+0x2b/0x70
>  [<ffffffff8102460f>] cpu_idle+0xbf/0x140
>  [<ffffffff816ad18d>] start_secondary+0x252/0x254
> 
> WARNING: at kernel/rcutree.c:352 rcu_eqs_enter_common.isra.37+0x1c6/0x1e0()
> Pid: 0, comm: swapper/1 Tainted: G        W    3.6.0+ #24
> Call Trace:
>  [<ffffffff810678af>] warn_slowpath_common+0x7f/0xc0
>  [<ffffffff8106790a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff8111a2d6>] rcu_eqs_enter_common.isra.37+0x1c6/0x1e0
>  [<ffffffff8111a355>] rcu_eqs_enter+0x65/0xa0
>  [<ffffffff8111af0b>] rcu_idle_enter+0x2b/0x70
>  [<ffffffff8102460f>] cpu_idle+0xbf/0x140
>  [<ffffffff816ad18d>] start_secondary+0x252/0x254
> 
> WARNING: at kernel/rcutree.c:539 rcu_eqs_exit+0x99/0xb0()
> Pid: 0, comm: swapper/1 Tainted: G        W    3.6.0+ #24
> Call Trace:
>  [<ffffffff810678af>] warn_slowpath_common+0x7f/0xc0
>  [<ffffffff8106790a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff8111a0f9>] rcu_eqs_exit+0x99/0xb0
>  [<ffffffff8111ae9b>] rcu_idle_exit+0x2b/0x70
>  [<ffffffff8102461e>] cpu_idle+0xce/0x140
>  [<ffffffff816ad18d>] start_secondary+0x252/0x254
> 
> WARNING: at kernel/rcutree.c:513 rcu_eqs_exit_common.isra.35+0xd4/0xe0()
> Pid: 0, comm: swapper/1 Tainted: G        W    3.6.0+ #24
> Call Trace:
>  [<ffffffff810678af>] warn_slowpath_common+0x7f/0xc0
>  [<ffffffff8106790a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff8111a054>] rcu_eqs_exit_common.isra.35+0xd4/0xe0
>  [<ffffffff8111a0bc>] rcu_eqs_exit+0x5c/0xb0
>  [<ffffffff8111ae9b>] rcu_idle_exit+0x2b/0x70
>  [<ffffffff8102461e>] cpu_idle+0xce/0x140
>  [<ffffffff816ad18d>] start_secondary+0x252/0x254
> 
> 	Dave
> 


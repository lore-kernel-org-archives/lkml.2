Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab2E3BwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:52:07 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59463 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab2E3BwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:52:04 -0400
Date: Tue, 29 May 2012 18:51:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] uprobes: kill uprobes_srcu/uprobe_srcu_id
Message-ID: <20120530015157.GB2357@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120529192721.GA8048@redhat.com>
 <20120529193008.GG8057@redhat.com>
 <1338332687.26856.189.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338332687.26856.189.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053001-2398-0000-0000-0000070A8996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 01:04:47AM +0200, Peter Zijlstra wrote:
> On Tue, 2012-05-29 at 21:30 +0200, Oleg Nesterov wrote:
> > Kill the no longer needed uprobes_srcu/uprobe_srcu_id code.
> > 
> > It doesn't really work anyway. synchronize_srcu() can only synchronize
> > with the code "inside" the srcu_read_lock/srcu_read_unlock section,
> > while uprobe_pre_sstep_notifier() does srcu_read_lock() _after_ we
> > already hit the breakpoint.
> > 
> > I guess this probably works "in practice". synchronize_srcu() is slow
> > and it implies synchronize_sched(), and the probed task enters the non-
> > preemptible section at the start of exception handler. Still this is not
> > right at least in theory, and task->uprobe_srcu_id blows task_struct.
> 
> This kills the only user of srcu_read_{,un}lock_raw(), so I guess we
> could also make:
> 
>   9ceae0e2
>   101db7b4
>   0c53dd8b
> 
> go away.. 

If it is still unused in a few months, I will get rid of them.

							Thanx, Paul


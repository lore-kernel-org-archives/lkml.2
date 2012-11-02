Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934822Ab2KBSfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:35:54 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:54104 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab2KBSfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:35:52 -0400
Date: Fri, 2 Nov 2012 11:35:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 00/32] [RFC] nohz/cpuset: Start discussions on nohz CPUs
Message-ID: <20121102183544.GZ3027@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121029202711.062749374@goodmis.org>
 <0000013ac180f152-79f05c71-4d38-43b0-9b62-8a71c00dfda7-000000@email.amazonses.com>
 <1351867045.4004.141.camel@gandalf.local.home>
 <0000013ac1a58555-bea33420-d101-4e86-abc5-11dd6863b7a8-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013ac1a58555-bea33420-d101-4e86-abc5-11dd6863b7a8-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110218-7408-0000-0000-000009EA3BC6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 03:03:01PM +0000, Christoph Lameter wrote:
> On Fri, 2 Nov 2012, Steven Rostedt wrote:
> 
> > > also it would be best to sync this conceptually with the processors
> > > enabled for rcu processing.
> >
> > Processors can be disabled for rcu processing? Or are you talking about
> > Paul's new work of offloading rcu callbacks?
> 
> Yes. Paul's new work to remove rcu processing from processors. That needs
> to be synced configuration wise somehow. It does not make sense to process
> rcu callbacks on processors where the timer tick does not work anymore.

In kernels built with CONFIG_FAST_NO_HZ=n, if there are callbacks,
then there will be a tick, with or without Frederic's adaptive ticks.
If CONFIG_FAST_NO_HZ=y, if there are callbacks but no tick, RCU will
arrange for a timer to allow RCU processing to proceed as needed, but
much longer than one tick in duration, and only until such time as the
RCU callbacks drain.

So, yes, people who need absolutely all jitter to be banished at whatever
cost would want both adaptive ticks and no-CBs CPUs, but not everyone
who wants adaptive ticks would necessarily want the burden of choosing
which CPUs get callbacks offloaded from and where they should be executed.

So I believe that these need to be controlled separately for the immediate
future.

							Thanx, Paul


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab1LFQGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:06:18 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:36604 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1LFQGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:06:17 -0500
Date: Tue, 6 Dec 2011 08:04:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 7/7] rcu: Quiet RCU-lockdep warnings
 involving interrupt disabling
Message-ID: <20111206160455.GC2325@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111203183417.GA18914@linux.vnet.ibm.com>
 <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111205091924.GA28117@zhy>
 <20111205164505.GB2326@linux.vnet.ibm.com>
 <20111206012635.GA32498@zhy>
 <1323165152.32012.51.camel@twins>
 <20111206100537.GA5203@zhy>
 <1323167527.32012.61.camel@twins>
 <1323174405.30977.86.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323174405.30977.86.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11120616-2398-0000-0000-0000028A520C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 07:26:45AM -0500, Steven Rostedt wrote:
> On Tue, 2011-12-06 at 11:32 +0100, Peter Zijlstra wrote:
> 
> > > > 
> > > > > Maybe we could teach might_sleep() about this special case?
> > > > 
> > > > Sounds horrid.
> > > 
> > > Maybe, any alternative?
> > 
> > Maybe someone explain this mess first?
> 
> Me too, because this looks like a hack that's just like a lie. The first
> lie to be said gets you out of a bit of trouble, but then something else
> happens based on that lie, in which you need to make another bigger lie.
> This new lie affects more people and requires new more ingenious lies to
> control the chaos. But eventually the lies required to keep everything
> going become so overwhelming that it all blows up in your face and you
> end up looking like a jackass.
> 
> Why is rcu using rt_mutex_lock() in strange ways? It's lying about its
> use. And now this patch is the bigger lie to get around the issues of
> the first lie. Eventually this code will continue to expand largely
> based on these lies and will explode in our faces, and I feel sorry for
> the poor jackass that needs to fix it.
> 
> Perhaps the real answer is that we need to create an API for priority
> inheritance, that things like RCU could use. Attach a task that another
> task requires to finish something and boost the priority of that task.
> Maybe even completions could use such a thing?

I would be OK with that -- that was in fact the approach I was taking
when I was advised to use mutexes instead.  ;-)

							Thanx, Paul


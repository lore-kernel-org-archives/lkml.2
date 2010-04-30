Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144Ab0D3TJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:09:33 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:53372 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933985Ab0D3TJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:09:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACbE2ktGGNqG/2dsb2JhbACdI3K+X4JmgiwE
Date: Fri, 30 Apr 2010 15:09:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Valdis.Kletnieks@vt.edu, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/urgent] fix several lockdep splats, allow
	multiple splats
Message-ID: <20100430190917.GB6926@Krystal>
References: <20100421200150.GA3818@linux.vnet.ibm.com> <20100430100749.GC14202@elte.hu> <20100430153334.GA19672@Krystal> <10035.1272644205@localhost> <20100430180247.GA2482@linux.vnet.ibm.com> <20100430181201.GB1704@Krystal> <20100430183226.GB2482@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100430183226.GB2482@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 15:08:58 up 23 days,  5:02,  3 users,  load average: 0.06, 0.08,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Fri, Apr 30, 2010 at 02:12:01PM -0400, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Fri, Apr 30, 2010 at 12:16:45PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > > > On Fri, 30 Apr 2010 11:33:34 EDT, Mathieu Desnoyers said:
> > > > 
> > > > > I recommend creating a kernel command line parameter that would tweak
> > > > > the number of messages printed by lockdep. The default would indeed by 1
> > > > > message, but people in a debugging marathon can specify a larger value
> > > > > so they won't have to reboot between each individual lockdep error.
> > > > 
> > > > Yeah, that would rock for development kernels - playing whack-a-mole with
> > > > a half-dozen new lockdep whinges can easily stretch out for quite some time.
> > > 
> > > The RCU-lockdep splats are a bit different in nature than the
> > > deadlock-related splats that lockdep normally prints.  The RCU-lockdep
> > > splats are transient in nature, and it is easy to apply WARN_ON_ONCE().
> > > In contrast, if you permit multiple deadlock-related lockdep splats,
> > > you tend to get lots of warnings about the same deadlock cycle.
> > > 
> > > So how about an additional kernel configuration variable, default
> > > disabled, perhaps named CONFIG_PROVE_RCU_MULTIPLE, that allows a
> > > single boot to see multiple messages?  Unlike the dyntick-idle
> > > WARN_ON()s that generated multi-gigabyte console logs in a great
> > > hurry, I haven't yet seen excessive quantities of RCU-lockdep splats,
> > > so I don't see the need for an integer limit.
> > > 
> > > Thoughts?
> > 
> > Ideally we don't want to flood the console with thousands of instances
> > of the same RCU-lockdep splat (think of a missing read lock on a common
> > code path). Therefore I think keeping an integer limit is relevant here.
> > I agree that this integer limit could be selected by a CONFIG_ option
> > rather than by a kernel parameter, as it will typically only be used on
> > development kernels with "kernel hacking" enabled anyway. There is not
> > much point in bloating the kernel code with an extra debug-only kernel
> > parameter parsing.
> 
> We already limit via WARN_ON_ONCE(), and there are fewer than 500 lines
> of code in the kernel that can give RCU lockdep splats, so I really believe
> that we are OK without an overall limit for the foreseeable future.

Your idea makes sense then.

Thanks,

Mathieu

> 
> 							Thanx, Paul

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

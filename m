Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab3AGWT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:19:27 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:46269 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3AGWT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:19:26 -0500
Date: Mon, 7 Jan 2013 14:19:15 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 1/1] Tiny RCU changes for 3.9
Message-ID: <20130107221915.GA2525@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130105175059.GA15961@linux.vnet.ibm.com>
 <20130107155810.GC11145@leaf>
 <20130107165748.GF2525@linux.vnet.ibm.com>
 <20130107175606.GA9962@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107175606.GA9962@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010722-5406-0000-0000-000003F9108E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 09:56:06AM -0800, Josh Triplett wrote:
> On Mon, Jan 07, 2013 at 08:57:48AM -0800, Paul E. McKenney wrote:
> > On Mon, Jan 07, 2013 at 07:58:10AM -0800, Josh Triplett wrote:
> > > On Sat, Jan 05, 2013 at 09:50:59AM -0800, Paul E. McKenney wrote:
> > > > rcu: Provide RCU CPU stall warnings for tiny RCU
> > > > 
> > > > Tiny RCU has historically omitted RCU CPU stall warnings in order to
> > > > reduce memory requirements, however, lack of these warnings caused Thomas
> > > > Gleixner some debugging pain recently.  Therefore, this commit adds RCU
> > > > CPU stall warnings to tiny RCU if RCU_TRACE=y.  This keeps the memory
> > > > footprint small, while still enabling CPU stall warnings in kernels
> > > > built to enable them.
> > > > 
> > > > This is still a bit on the high-risk side, so running this will likely
> > > > be a debugging exercise.
> > > > 
> > > > Reported-by: Thomas Gleixner <tglx@linutronix.de>
> > > > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > 
> > > Did you generate this patch with something other than git?  The
> > > formatting seems a bit off: it doesn't have a diffstat or the usual
> > > "---" line between the commit message and the patch.
> > 
> > Indeed I did -- couldn't see the point of sending a 0/1 and 1/1
> > series of patches.  ;-)
> 
> Just don't pass --cover-letter to git format-patch and you won't get the
> 0/1.

Ah, good point!  Thank you!

> > > This patch seems reasonable to me, but the repeated use of #if
> > > defined(CONFIG_SMP) || defined(CONFIG_RCU_TRACE) seems somewhat
> > > annoying, and fragile if you ever decide to change the conditions.  How
> > > about defining an appropriate symbol in Kconfig for stall warnings, and
> > > using that?
> > 
> > But I only just removed the config option for SMP RCU stall warnings.  ;-)
> > 
> > But I must agree that "defined(CONFIG_SMP) || defined(CONFIG_RCU_TRACE)"
> > is a bit obscure.  The rationale is that RCU stall warnings are
> > unconditionally enabled in SMP kernels, but don't want to be in
> > TINY_RCU kernels due to size constraints.  I therefore put it under
> > CONFIG_RCU_TRACE, which also contains other TINY_RCU debugging-style
> > options.  Would adding a comment to this effect help?
> 
> I understand the rationale; I just think it would become clearer if you
> added an internal-only Kconfig symbol selected in both cases and change
> the conditionals to use that.

My concern was that this would confuse people into thinking that the
code under those #ifdefs was all the stall-warning code that there was.

I suppose this could be forestalled with a suitably clever name...
CONFIG_RCU_CPU_STALL_TINY_TOO?  Better names?

							Thanx, Paul


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab0GNXae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:30:34 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39059 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776Ab0GNXad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:30:33 -0400
Date: Wed, 14 Jul 2010 16:30:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 29/30] rcu: add boot parameter to
 suppress RCU CPU stall warning messages
Message-ID: <20100714233029.GK2417@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100714200945.GA10535@linux.vnet.ibm.com>
 <1279138204-12849-29-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100714211606.GB4624@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714211606.GB4624@feather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 02:16:06PM -0700, Josh Triplett wrote:
> On Wed, Jul 14, 2010 at 01:10:03PM -0700, Paul E. McKenney wrote:
> > Although the RCU CPU stall warning messages are a very good way to alert
> > people to a problem, once alerted, it is sometimes helpful to shut them
> > off in order to avoid obscuring other messages that might be being used
> > to track down the problem.  Although you can rebuild the kernel with
> > CONFIG_RCU_CPU_STALL_DETECTOR=n, this is sometimes inconvenient.  This
> > commit therefore adds a boot parameter named "rcu_cpu_stall_suppress"
> > that shuts these messages off without requiring a rebuild (though a
> > reboot might be needed for those not brave enough to patch their kernel
> > while it is running).
> > 
> > This message-suppression was already in place for the panic case, so this
> > commit need only rename the variable and export it via module_param().
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree.c |   11 ++++++++---
> >  1 files changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 5b1c3c2..f3d5906 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -143,6 +143,11 @@ module_param(blimit, int, 0);
> >  module_param(qhimark, int, 0);
> >  module_param(qlowmark, int, 0);
> >  
> > +#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
> > +int rcu_cpu_stall_suppress __read_mostly;
> > +module_param(rcu_cpu_stall_suppress, int, 0);
> > +#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
> 
> In theory, you could change the permissions on this module_param from 0
> to 0644, making it appear under /sys as a writable file.  That would
> allow changing it at runtime rather than just at boot time.  Looking at
> the use of this variable, changing it dynamically should work.

Will give it a try!

							Thanx, Paul

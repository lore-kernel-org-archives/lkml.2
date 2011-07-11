Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab1GKQiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 12:38:54 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47724 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758083Ab1GKQix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:38:53 -0400
Date: Mon, 11 Jul 2011 09:38:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 0/6] Check for use of RCU from
 dyntick-idle mode
Message-ID: <20110711163848.GF2245@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110708154331.GA20161@linux.vnet.ibm.com>
 <20110711160330.GC4109@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711160330.GC4109@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 06:03:32PM +0200, Frederic Weisbecker wrote:
> On Fri, Jul 08, 2011 at 08:43:31AM -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > This set of patches adds checks for use of RCU from "extended quiescent
> > states" such as dyntick-idle mode.  Such use is grossly illegal because
> > RCU by definition ignores CPUs that are in extended quiescent states.
> > In the case of dyntick-idle mode, the only way for RCU to avoid ignoring
> > such CPUs would be to wake them up periodically, which would defeat the
> > whole purpose of dyntick-idle mode.
> > 
> > The good news is that Frederic got this effort started.  The bad news is
> > that there are several cases where RCU read-side critical sections appear
> > in dyntick-idle mode.
> 
> Ok, let me send to you the patch that splits up rcu/tickless logic and I'll try
> to fix up what you reported to me in ppc.

Very good, thank you!

> BTW, are you aware of other cases? You mentioned "several" :)

PowerPC's hypercall-exit trace event will also cause this complaint.
Plus I thought you saw some others.

							Thanx, Paul

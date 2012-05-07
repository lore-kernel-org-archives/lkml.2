Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2EGFYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 01:24:17 -0400
Received: from ozlabs.org ([203.10.76.45]:46075 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab2EGFYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 01:24:15 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: paulmck@linux.vnet.ibm.com,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>, venki@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH RFC tip/core/rcu 1/6] rcu: Stabilize use of num_online_cpus() for GP short circuit
In-Reply-To: <20120424165056.GB2403@linux.vnet.ibm.com>
References: <20120423164159.GA13819@linux.vnet.ibm.com> <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com> <4F96C838.3090309@linux.vnet.ibm.com> <20120424165056.GB2403@linux.vnet.ibm.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 07 May 2012 13:17:23 +0930
Message-ID: <87mx5kfy9g.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2012 09:50:56 -0700, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Apr 24, 2012 at 09:05:20PM +0530, Srivatsa S. Bhat wrote:
> 
> Thank you for looking this over!
> 
> > On 04/23/2012 10:12 PM, Paul E. McKenney wrote:
> > 
> > > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > > 
> > > The rcu_blocking_is_gp() function tests to see if there is only one
> > > online CPU, and if so, synchronize_sched() and friends become no-ops.
> > > However, for larger systems, num_online_cpus() scans a large vector,
> > 
> > 
> > Venki had posted a patch to optimize that by using a variable, so that we
> > don't calculate the value each and every time.
> > http://thread.gmane.org/gmane.linux.kernel/1240569/focus=1246659
> > 
> > However, unfortunately there was some confusion around that patch and
> > even though it made it to akpm's tree and stayed there briefly, it didn't
> > go upstream. Venki had attempted to resolve the confusion here:
> > http://thread.gmane.org/gmane.linux.kernel/1240569/focus=1260702
> 
> Having a single variable tracking the online state would be good,
> but as you say it isn't there yet.

I think you could have a flag set by a notifier, but you'd have to
re-think the races...

Cheers,
Rusty.

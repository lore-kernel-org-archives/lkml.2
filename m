Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab2CWX2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 19:28:20 -0400
Received: from ozlabs.org ([203.10.76.45]:60560 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903Ab2CWX2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 19:28:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo\@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: CPU Hotplug rework
In-Reply-To: <20120322224919.GW2450@linux.vnet.ibm.com>
References: <4F674649.2000300@linux.vnet.ibm.com> <87aa3cqht9.fsf@rustcorp.com.au> <1332240151.18960.401.camel@twins> <874ntic1ze.fsf@rustcorp.com.au> <1332320519.18960.466.camel@twins> <87d3859s9r.fsf@rustcorp.com.au> <20120322224919.GW2450@linux.vnet.ibm.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sat, 24 Mar 2012 09:57:32 +1030
Message-ID: <877gya99uj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2012 15:49:20 -0700, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Mar 22, 2012 at 02:55:04PM +1030, Rusty Russell wrote:
> > On Wed, 21 Mar 2012 10:01:59 +0100, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > Thing is, if its really too much for some people, they can orchestrate
> > > it such that its not. Just move everybody in a cpuset, clear the to be
> > > offlined cpu from the cpuset's mask -- this will migrate everybody away.
> > > Then hotplug will find an empty runqueue and its fast, no?
> > 
> > I like this solution better.
> 
> As long as we have some way to handle kthreads that are algorithmically
> tied to a given CPU.  There are coding conventions to handle this, for
> example, do everything with preemption disabled and just after each
> preempt_disable() verify that you are in fact running on the correct
> CPU, but it is easy to imagine improvements.

I don't think we should move per-cpu kthreads at all.  Let's stop trying
to save a few bytes of memory, and just leave them frozen.  They'll run
again if/when the CPU returns.

Cheers,
Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org

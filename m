Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944Ab2DKBAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 21:00:35 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40710 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab2DKBAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 21:00:33 -0400
Date: Tue, 10 Apr 2012 18:00:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: CPU Hotplug rework
Message-ID: <20120411010015.GA2402@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4F674649.2000300@linux.vnet.ibm.com>
 <4F67474A.20707@linux.vnet.ibm.com>
 <20120405173918.GC8194@linux.vnet.ibm.com>
 <4F7F4977.4000302@linux.vnet.ibm.com>
 <1334102999.23924.232.camel@gandalf.stny.rr.com>
 <20120411002836.GM2428@linux.vnet.ibm.com>
 <1334104638.23924.233.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334104638.23924.233.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041101-3352-0000-0000-000003EFD0B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 08:37:18PM -0400, Steven Rostedt wrote:
> On Tue, 2012-04-10 at 17:28 -0700, Paul E. McKenney wrote:
> 
> > > Just to throw out the stupid silly approach.
> > > 
> > > What about creating a "__register_cpu_notifier()" that just does:
> > > 
> > > int __ref __register_cpu_notifier(struct notifier_block *nb)
> > > {
> > > 	return raw_notifier_chain_register(&cpu_chain, nb);
> > > }
> > > 
> > > Also making cpu_maps_update_begin/done() global (and probably rename
> > > them).
> 
> I just noticed that the cpu_maps_update_begin/done() are already global.
> 
> > > 
> > > and then in the above code do:
> > > 
> > > 	cpu_maps_update_begin();
> > > 	__register_cpu_notifier(nb);
> > > 	do_setup();
> > > 	cpu_maps_update_done();
> > > 
> > > 
> > > Just saying,
> > 
> > That does have some attractive properties, now that you mention it.  ;-)
> 
> Which property? Stupid or Silly ;-)

As with any piece of software, no matter how small, both.  ;-)

Of course, __register_cpu_notifier() would need lockdep checking to make
sure that it wasn't called without the benefit of cpu_maps_update_begin().
I might be missing something, but as long as that was in place, seems
like it is a lot simpler and easier to use than the alternatives that
Srivatsa and I were kicking around.

							Thanx, Paul


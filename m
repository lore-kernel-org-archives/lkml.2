Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab2CZN4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 09:56:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41881 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab2CZN4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 09:56:41 -0400
Message-ID: <1332769098.16159.111.camel@twins>
Subject: Re: CPU Hotplug rework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, paulmck@linux.vnet.ibm.com,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Date: Mon, 26 Mar 2012 15:38:18 +0200
In-Reply-To: <1332767386.23924.75.camel@gandalf.stny.rr.com>
References: <4F674649.2000300@linux.vnet.ibm.com>
	 <87aa3cqht9.fsf@rustcorp.com.au> <1332240151.18960.401.camel@twins>
	 <874ntic1ze.fsf@rustcorp.com.au> <1332320519.18960.466.camel@twins>
	 <87d3859s9r.fsf@rustcorp.com.au> <20120322224919.GW2450@linux.vnet.ibm.com>
	 <877gya99uj.fsf@rustcorp.com.au> <20120324002347.GD2450@linux.vnet.ibm.com>
	 <87bonkchxk.fsf@rustcorp.com.au> <1332748920.16159.65.camel@twins>
	 <1332767386.23924.75.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 09:09 -0400, Steven Rostedt wrote:
> On Mon, 2012-03-26 at 10:02 +0200, Peter Zijlstra wrote:
> > On Mon, 2012-03-26 at 11:11 +1030, Rusty Russell wrote:
> > > Obviously, having callbacks hanging around until the CPU comes back is
> > > not viable, nor is blocking preempt during the callbacks.  Calling
> > > get_online_cpus() is too heavy. 
> > 
> > -rt has patches (albeit somewhat ugly) to make get_online_cpus() a br
> > style rw-lock. 
> 
> Unfortunately, -rt still has broken cpu hotplug.

This is still the issue where we take the hotplug lock for write, but
then rely on other threads to complete -- say CPU_DOWN_PREPARE notifiers
doing flush_workqueue(), and the worker kthread needing to acquire the
hotplug lock for read, right?

Yes, that is bothersome, but doesn't hinder the work required to get
get_online_cpus() usably fast, right?

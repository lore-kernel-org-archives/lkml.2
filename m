Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1GLUxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:53:05 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47721 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab1GLUxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:53:03 -0400
Date: Tue, 12 Jul 2011 13:52:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org, chengxu@linux.vnet.ibm.com,
        peterz@infradead.org
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110712205258.GN2326@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110711201508.GN2245@linux.vnet.ibm.com>
 <20110711210954.GA15745@dumpdata.com>
 <20110712105506.GB2253@linux.vnet.ibm.com>
 <20110712141228.GA7831@dumpdata.com>
 <20110712144936.GD2326@linux.vnet.ibm.com>
 <20110712160324.GA1186@dumpdata.com>
 <20110712163947.GF2326@linux.vnet.ibm.com>
 <20110712180151.GA18257@dumpdata.com>
 <20110712185907.GJ2326@linux.vnet.ibm.com>
 <20110712190756.GB4766@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712190756.GB4766@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 03:07:56PM -0400, Konrad Rzeszutek Wilk wrote:
> > > > Disabling CONFIG_NO_HZ would be an interesting test case.
> > > 
> > > Hadn't done that yet. Compiling a kernel with "# CONFIG_NO_HZ is not set"
> > > right now.
> 
> Log: http://darnok.org/xen/loop_cnt-extra-patch-no-hz-disabled.log
> config:http://darnok.org/xen/loop_cnt-extra-patch-no-hz-disabled+.config
> Patch: http://darnok.org/xen/loop_cnt-extra-patch-no-hz-disabled.patch

OK, thank you for trying this out.  No joy, but to be expected given
Peter's later email.

							Thanx, Paul

> > > > > > But the loop in task_waking_fair() looks like the most prominent smoking
> > > > > > gun at the moment.
> > > > 
> > > > And could you also please try out the patch that I posted earlier?
> > > 
> > > With the previous patch and the .. this is getting confusing. With this patch:
> > > http://darnok.org/xen/loop_cnt-extra.patch
> > 
> > That is indeed the patch I intended.
> 
> <nods>
> > 
> > > I get this output: http://darnok.org/xen/log.loop_cnt-extra-patch (one guest
> > > with 4 VCPUS) and http://darnok.org/xen/loop_cnt-extra-patch.log (the guest with 16 VCPUs)
> > 
> > OK, so the infinite loop in task_waking_fair() happens even if RCU callbacks
> > are deferred until after the scheduler is fully initialized.  Sounds like
> > one for the scheduler guys.  ;-)
> 
> Yikes. Well, in the meantime let me check the IPI part and see if there is something
> busted that could trigger softirq to be invoked directly.
> 
> And also compile the kernel with the CONFIG_RCU_PROVE_LOCKING with some extra
> git tree you pointed me to.
> > 
> > 							Thanx, Paul

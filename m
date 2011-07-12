Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab1GLTJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 15:09:31 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31393 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab1GLTJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 15:09:30 -0400
Date: Tue, 12 Jul 2011 15:07:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org, chengxu@linux.vnet.ibm.com,
        peterz@infradead.org
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110712190756.GB4766@dumpdata.com>
References: <20110711193021.GA2996@dumpdata.com>
 <20110711201508.GN2245@linux.vnet.ibm.com>
 <20110711210954.GA15745@dumpdata.com>
 <20110712105506.GB2253@linux.vnet.ibm.com>
 <20110712141228.GA7831@dumpdata.com>
 <20110712144936.GD2326@linux.vnet.ibm.com>
 <20110712160324.GA1186@dumpdata.com>
 <20110712163947.GF2326@linux.vnet.ibm.com>
 <20110712180151.GA18257@dumpdata.com>
 <20110712185907.GJ2326@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712185907.GJ2326@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E1C9B99.00B8:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Disabling CONFIG_NO_HZ would be an interesting test case.
> > 
> > Hadn't done that yet. Compiling a kernel with "# CONFIG_NO_HZ is not set"
> > right now.

Log: http://darnok.org/xen/loop_cnt-extra-patch-no-hz-disabled.log
config:http://darnok.org/xen/loop_cnt-extra-patch-no-hz-disabled+.config
Patch: http://darnok.org/xen/loop_cnt-extra-patch-no-hz-disabled.patch

> > > > > But the loop in task_waking_fair() looks like the most prominent smoking
> > > > > gun at the moment.
> > > 
> > > And could you also please try out the patch that I posted earlier?
> > 
> > With the previous patch and the .. this is getting confusing. With this patch:
> > http://darnok.org/xen/loop_cnt-extra.patch
> 
> That is indeed the patch I intended.

<nods>
> 
> > I get this output: http://darnok.org/xen/log.loop_cnt-extra-patch (one guest
> > with 4 VCPUS) and http://darnok.org/xen/loop_cnt-extra-patch.log (the guest with 16 VCPUs)
> 
> OK, so the infinite loop in task_waking_fair() happens even if RCU callbacks
> are deferred until after the scheduler is fully initialized.  Sounds like
> one for the scheduler guys.  ;-)

Yikes. Well, in the meantime let me check the IPI part and see if there is something
busted that could trigger softirq to be invoked directly.

And also compile the kernel with the CONFIG_RCU_PROVE_LOCKING with some extra
git tree you pointed me to.
> 
> 							Thanx, Paul

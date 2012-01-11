Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab2AKDwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 22:52:17 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:40098 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669Ab2AKDwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 22:52:14 -0500
Date: Wed, 11 Jan 2012 09:22:01 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Youquan Song <youquan.song@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        arjan@linux.intel.com, len.brown@intel.com, anhua.xu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
Message-ID: <20120111035156.GB7988@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
 <1326103578.2442.50.camel@twins>
 <20120110001445.GA20542@linux-youquan.bj.intel.com>
 <1326107156.2442.59.camel@twins>
 <20120110055856.GA23741@linux-youquan.bj.intel.com>
 <1326153163.2366.7.camel@sbsiddha-mobl2>
 <20120110165426.GA20681@linux-youquan.bj.intel.com>
 <20120110165129.GC17432@dirshya.in.ibm.com>
 <1326222073.6283.9.camel@sbsiddha-mobl2>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1326222073.6283.9.camel@sbsiddha-mobl2>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12011103-2000-0000-0000-000005FF9F32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha <suresh.b.siddha@intel.com> [2012-01-10 11:01:13]:

> On Tue, 2012-01-10 at 22:21 +0530, Vaidyanathan Srinivasan wrote:
> > * Youquan Song <youquan.song@intel.com> [2012-01-10 11:54:26]:
> > 
> > > 
> > > > Youquan, As far as I know both the
> > > > sched_smt_power_savings/sched_mc_power_savings are broken for atleast an
> > > > year.
> > > > 
> > > > Have you checked the state of 'sched_mc_power_savings' to see if it is
> > > > working or gets addressed with your proposed patches?
> > > Thanks Suresh!
> > > 
> > > We have verified that sched_mc_power_savings works well in mainline and
> > > -tip tree, only sched_smt_power_savings broken.
> > 
> > Hi Suresh,
> > 
> > My testing also shows that sched_mc works find and only sched_smt
> > suffers from the group capacity problem at the core level.
> > 
> 
> No. I just checked and it doesn't work as intended.
> 
> On a 2 socket 8-core SMT system, I ran 8 cpu hoggers and just toggled
> 'sched_mc_power_savings' between 0 and 1 multiple times. Irrespective of
> the value, those 8 hoggers are distributed evenly between two sockets -
> 4 each and doesn't change their positions.
> 
> So I can bet it doesn't work.

Hi Suresh,

I had tested sched_mc_powersavings=2 on dual socket quad core HT
nehalem.  It worked as expected.  Let me check the
sched_mc_powersavings=1 case.  I will not be surprised if it is
broken.

--Vaidy


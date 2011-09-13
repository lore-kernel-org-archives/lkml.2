Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab1IMQgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 12:36:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:39545 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab1IMQgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 12:36:44 -0400
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Paul Turner <pjt@google.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Date: Tue, 13 Sep 2011 18:36:15 +0200
In-Reply-To: <20110913162119.GA3045@linux.vnet.ibm.com>
References: <1315423342.11101.25.camel@twins>
	 <20110908151433.GB6587@linux.vnet.ibm.com> <1315571462.26517.9.camel@twins>
	 <20110912101722.GA28950@linux.vnet.ibm.com>
	 <1315830943.26517.36.camel@twins>
	 <20110913041545.GD11100@linux.vnet.ibm.com>
	 <20110913050306.GB7254@linux.vnet.ibm.com> <1315906788.575.3.camel@twins>
	 <20110913112852.GE7254@linux.vnet.ibm.com> <1315922848.5977.11.camel@twins>
	 <20110913162119.GA3045@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1315931775.5977.29.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 21:51 +0530, Srivatsa Vaddagiri wrote:
> > I can't read it seems.. I thought you were talking about increasing the
> > period,
> 
> Mm ..I brought up the increased lock contention with reference to this
> experimental result that I posted earlier:
> 
>   > Tuning min_interval and max_interval of various sched_domains to 1
>   > and also setting sched_cfs_bandwidth_slice_us to 500 does cut down idle
>   > time further to 2.7%

Yeah, that's the not being able to read part..

> Value of sched_cfs_bandwidth_slice_us was reduced from default of 5000us
> to 500us, which (along with reduction of min/max interval) helped cut down
> idle time further (3.9% -> 2.7%). I was commenting that this may not necessarily
> be optimal (as for example low 'sched_cfs_bandwidth_slice_us' could result
> in all cpus contending for cfs_b->lock very frequently). 

Right.. so this seems to suggest you're migrating a lot.

Also what workload are we talking about? the insane one with 5 groups of
weight 1024?

Ramping up the frequency of the load-balancer and giving out smaller
slices is really anti-scalability.. I bet a lot of that 'reclaimed' idle
time is spend in system time. 

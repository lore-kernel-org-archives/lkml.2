Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1IMFDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 01:03:18 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41947 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1IMFDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 01:03:17 -0400
Date: Tue, 13 Sep 2011 10:33:06 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
Message-ID: <20110913050306.GB7254@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <BANLkTimE1b8HP-q4jgsv5jPD5S-dRoUi_g@mail.gmail.com>
 <20110615053716.GA390@linux.vnet.ibm.com>
 <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com>
 <20110907152009.GA3868@linux.vnet.ibm.com>
 <1315423342.11101.25.camel@twins>
 <20110908151433.GB6587@linux.vnet.ibm.com>
 <1315571462.26517.9.camel@twins>
 <20110912101722.GA28950@linux.vnet.ibm.com>
 <1315830943.26517.36.camel@twins>
 <20110913041545.GD11100@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110913041545.GD11100@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11091305-7282-0000-0000-00000168EE67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> [2011-09-13 09:45:45]:

> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-12 14:35:43]:
> 
> > Of course it does.. and I bet you can improve that slightly if you
> > manage to fix some of the numerical nightmares that live in the cgroup
> > load-balancer (Paul, care to share your WIP?)
> 
> Booting with "nohz=off" also helps significantly.
> 
> With nohz=on, average idle time (over 1 min) is 10.3%
> With nohz=off, average idle time (over 1 min) is 3.9%

Tuning min_interval and max_interval of various sched_domains to 1 [a]
and also setting sched_cfs_bandwidth_slice_us to 500 does cut down idle
time further to 2.7% ..

This is perhaps not optimal (as it may lead to more lock contentions), but 
something to note for those who care for both capping and utilization in
equal measure!

- vatsa


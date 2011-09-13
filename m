Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1IMOIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:08:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49956 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab1IMOIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:08:10 -0400
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
Date: Tue, 13 Sep 2011 16:07:28 +0200
In-Reply-To: <20110913112852.GE7254@linux.vnet.ibm.com>
References: <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com>
	 <20110907152009.GA3868@linux.vnet.ibm.com>
	 <1315423342.11101.25.camel@twins>
	 <20110908151433.GB6587@linux.vnet.ibm.com> <1315571462.26517.9.camel@twins>
	 <20110912101722.GA28950@linux.vnet.ibm.com>
	 <1315830943.26517.36.camel@twins>
	 <20110913041545.GD11100@linux.vnet.ibm.com>
	 <20110913050306.GB7254@linux.vnet.ibm.com> <1315906788.575.3.camel@twins>
	 <20110913112852.GE7254@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1315922848.5977.11.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 16:58 +0530, Srivatsa Vaddagiri wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-13 11:39:48]:
> 
> > On Tue, 2011-09-13 at 10:33 +0530, Srivatsa Vaddagiri wrote:
> > > 
> > > This is perhaps not optimal (as it may lead to more lock contentions), but 
> > > something to note for those who care for both capping and utilization in
> > > equal measure!
> > 
> > You meant lock inversion, which leads to more idle time :-)
> 
> I think 'cfs_b->lock' contention would go up significantly when reducing
> sysctl_sched_cfs_bandwidth_slice, while for something like 'balancing' lock 
> (taken with SD_SERIALIZE set and more frequently when tuning down
> max_interval?), yes it may increase idle time! Did you have any other
> lock in mind when speaking of inversion?

I can't read it seems.. I thought you were talking about increasing the
period, which increases the time you force a task to sleep that's
holding locks etc..

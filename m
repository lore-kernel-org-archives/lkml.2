Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1IMSCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:02:19 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47074 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab1IMSCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:02:18 -0400
Date: Tue, 13 Sep 2011 23:31:46 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
Message-ID: <20110913180146.GA12723@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20110615053716.GA390@linux.vnet.ibm.com>
 <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com>
 <20110907152009.GA3868@linux.vnet.ibm.com>
 <1315423342.11101.25.camel@twins>
 <20110908151433.GB6587@linux.vnet.ibm.com>
 <1315571462.26517.9.camel@twins>
 <20110912101722.GA28950@linux.vnet.ibm.com>
 <1315830943.26517.36.camel@twins>
 <20110913041545.GD11100@linux.vnet.ibm.com>
 <1315923579.5977.14.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1315923579.5977.14.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-13 16:19:39]:

> > Booting with "nohz=off" also helps significantly.
> > 
> > With nohz=on, average idle time (over 1 min) is 10.3%
> > With nohz=off, average idle time (over 1 min) is 3.9%
>
> So we should put the cpufreq/idle governor into the nohz/idle path, it
> already tries to predict the idle duration in order to pick a C state,
> that same prediction should be used to determine if stopping the tick is
> worth it.

Hmm ..I tried performance governor and found that it slightly increases
idle time.

  With nohz=off && ondemand governor, idle time = 4%
  With nohz=off && performance governor on all cpus, idle time = 6%

I can't see obvious reasons for that ..afaict bandwidth capping should
be independent of frequency (i.e task gets capped by "used" time,
irrespective of frequency at which it was "using" the cpu)?

- vatsa

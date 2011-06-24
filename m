Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451Ab1FXPFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 11:05:50 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:52185 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753Ab1FXPFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 11:05:42 -0400
Date: Fri, 24 Jun 2011 20:35:33 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Pavel Emelianov <xemul@parallels.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinned
Message-ID: <20110624150533.GB1519@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20110503092846.022272244@google.com>
 <20110607154542.GA2991@linux.vnet.ibm.com>
 <1307529966.4928.8.camel@dhcp-10-30-22-158.sw.ru>
 <20110608163234.GA23031@linux.vnet.ibm.com>
 <BANLkTim7a9uhH_K6sw4YdqWB6frT+HUqqQ@mail.gmail.com>
 <20110610181719.GA30330@linux.vnet.ibm.com>
 <BANLkTimE1b8HP-q4jgsv5jPD5S-dRoUi_g@mail.gmail.com>
 <20110615053716.GA390@linux.vnet.ibm.com>
 <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Turner <pjt@google.com> [2011-06-21 12:48:17]:

> Hi Kamalesh,
> 
> Can you see what things look like under v7?
> 
> There's been a few improvements to quota re-distribution that should
> hopefully help your test case.
> 
> The remaining idle% I see on my machines appear to be a product of
> load-balancer inefficiency.
> 
> Thanks!
> 
> - Paul
(snip)

Hi Paul,

Sorry for the delay in the response. I tried the V7 patchset on 
top of tip. Patchset passed different combinations build and boot 
tests. 

I have re-run the tests with couple of combinations on the same 
2 socket,4 core, HT box. The test data was collected for 60 seconds
run

un-pinned and cpu shares of 1024
-------------------------------------------------
Top five cgroups and its sub-cgroups were assigned default
cpu shares of 1024.

Average CPU Idle percentage 21.8333%
Bandwidth shared with remaining non-Idle 78.1667%


un-pinned and cpu shares are proportional 
--------------------------------------------------
Top five cgroups were assigned cpu shares proportional to 
no of sub-cgroups it has under its hierarchy. 
For example cgroup1's share is (1024*2) = 2048 and each sub-cgroups 
has shares of 1024.

Average CPU Idle percentage 14.2%
Bandwidth shared with remaining non-Idle 85.8%


pinned and cpu shares of 1024
--------------------------------------------------
Average CPU Idle percentage 0.0666667%
Bandwidth shared with remaining non-Idle 99.9333333%


pinned and cpu shares are proportional
--------------------------------------------------
Average CPU Idle percentage 0%
Bandwidth shared with remaining non-Idle 100%


I have captured the perf sched stats for every run. Let me
know if that will help. I can mail them to you privately.

Thanks,
Kamalesh.

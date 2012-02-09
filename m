Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab2BIPMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:12:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42600 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab2BIPMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:12:34 -0500
Date: Thu, 9 Feb 2012 16:11:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paul@paulmenage.org, rjw@sisk.pl,
        tj@kernel.org, frank.rowand@am.sony.com, pjt@google.com,
        tglx@linutronix.de, lizf@cn.fujitsu.com, prashanth@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] CPU hotplug, cpusets: Fix CPU online handling
 related to cpusets
Message-ID: <20120209151158.GA22489@elte.hu>
References: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
 <1328671335.2482.72.camel@laptop>
 <4F32174E.2050207@linux.vnet.ibm.com>
 <20120209075701.GE18387@elte.hu>
 <4F3386E9.7090606@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3386E9.7090606@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:

> Hi Ingo,
> 
> On 02/09/2012 01:27 PM, Ingo Molnar wrote:
> 
> > 
> > * Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> > 
> >> IOW, consider:
> >>
> >> cpuset A has 0-10
> >>
> >> - Take CPU 10 offline
> >>   [We are forced to remove CPU 10 from cpuset A, which becomes 0-9 now]
> >>
> >>
> >>    <Userspace didn't request any change to cpuset A>
> >>
> >>
> >> - Bring back CPU 10 online
> >>
> >> Now cpuset A is still 0-9! IMO, it should have been 0-10.
> > 
> > Why is CPU 10 taken out of the cpuset to begin with?
> > 
> > The cpuset code should be fixed to work with offline CPUs as 
> > well - it can obviously not schedule to them, but otherwise 
> > it should be fine to have a wider cpuset than the hw can 
> > support.
> 
> My understanding of the code is that when a CPU is taken 
> offline, it is removed from all the cpusets and then the 
> scan_for_empty_cpusets() function is run to move tasks from 
> empty cpusets to their parent cpusets.

Why is that done that way? offlining a CPU should be an 
invariant as far as cpusets are concerned.

Not touching the cpuset would avoid the hot-replug complications 
as well.

Thanks,

	Ingo

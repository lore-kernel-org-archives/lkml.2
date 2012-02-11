Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab2BKNkG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 08:40:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35091 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab2BKNkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 08:40:04 -0500
Date: Sat, 11 Feb 2012 14:39:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, paul@paulmenage.org,
        rjw@sisk.pl, tj@kernel.org, frank.rowand@am.sony.com, pjt@google.com,
        tglx@linutronix.de, lizf@cn.fujitsu.com, prashanth@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] CPU hotplug, cpusets: Fix CPU online handling
 related to cpusets
Message-ID: <20120211133929.GB28098@elte.hu>
References: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
 <1328671335.2482.72.camel@laptop>
 <4F32174E.2050207@linux.vnet.ibm.com>
 <20120209075701.GE18387@elte.hu>
 <4F3386E9.7090606@linux.vnet.ibm.com>
 <20120209151158.GA22489@elte.hu>
 <1328889127.25989.14.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328889127.25989.14.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2012-02-09 at 16:11 +0100, Ingo Molnar wrote:
> 
> > > My understanding of the code is that when a CPU is taken 
> > > offline, it is removed from all the cpusets and then the 
> > > scan_for_empty_cpusets() function is run to move tasks from 
> > > empty cpusets to their parent cpusets.
> > 
> > Why is that done that way? offlining a CPU should be an 
> > invariant as far as cpusets are concerned.
> 
> Can't, tasks need to run someplace. There's two choices, add a 
> still online cpu to the now empty cpuset or move the tasks to 
> a parent that still has online cpus.
> 
> Both are destructive.

You aren't thinking hard enough ;-) There's several solutions 
off the top of my mind:

1) refuse the "impossible" offlining of the CPU, with a clear 
   enough error to make it actionable

2) offer a 'forced' offlinign of a CPU that will SIGTERM all 
   tasks that are on the now offline CPU and can only be there.

3) offer a 'nice' offlining variant that moves all orphan tasks
   to their or any other well-defined fallback CPU.

4) *allow* 'impossible' cpusets and just run them on CPU#0 or 
   any other natural approximation. Don't touch the cpuset!

All of these would be exception mechanisms with no need to do 
anything at hot-replug time.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2E3Pan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:30:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36902 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab2E3Pal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:30:41 -0400
Date: Wed, 30 May 2012 17:30:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 00/35] AutoNUMA alpha14
Message-ID: <20120530153034.GB4341@gmail.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
 <4FC112AB.1040605@redhat.com>
 <CA+55aFxpD+LsE+aNvDJtz9sGsGMvdusisgOY3Csbzyx1mEqW-w@mail.gmail.com>
 <1338389200.26856.273.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338389200.26856.273.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> So the thing is, my homenode-per-process approach should work 
> for everything except the case where a single process 
> out-strips a single node in either cpu utilization or memory 
> consumption.
> 
> Now I claim such processes are rare since nodes are big, 
> typically 6-8 cores. Writing anything that can sustain 
> parallel execution larger than that is very specialist (and 
> typically already employs strong data separation).
> 
> Yes there are such things out there, some use JVMs some are 
> virtual machines some regular applications, but by and large 
> processes are small compared to nodes.
> 
> So my approach is focus on the normal case, and provide 2 
> system calls to replace sched_setaffinity() and mbind() for 
> the people who use those.

We could certainly strike those from the first version, if Linus 
agrees with the general approach.

This gives us degrees freedom as it's an obvious on/off kernel 
feature which we fix or remove if it does not work.

I'd even venture that it should be on by default, it's an 
obvious placement strategy for everything sane that does not try 
to nest some other execution environment within Linux (i.e. 
specialist runtimes).

Thanks,

	Ingo

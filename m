Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab2GIO4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:56:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41874 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab2GIO4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:56:35 -0400
Message-ID: <1341845758.3462.84.camel@twins>
Subject: Re: [RFC][PATCH 25/26] sched, numa: Only migrate long-running
 entities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Mon, 09 Jul 2012 16:55:58 +0200
In-Reply-To: <4FFAF067.3050905@redhat.com>
References: <20120316144028.036474157@chello.nl>
	  <20120316144241.749359061@chello.nl> <4FF9D29D.8030903@redhat.com>
	 <1341836787.3462.64.camel@twins> <4FFAF067.3050905@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 10:53 -0400, Rik van Riel wrote:
> On 07/09/2012 08:26 AM, Peter Zijlstra wrote:
> > On Sun, 2012-07-08 at 14:34 -0400, Rik van Riel wrote:
> 
> >> Do we really want to calculate the amount of CPU time used
> >> by a process, and start migrating after just one second?
> >>
> >> Or would it be ok to start migrating once a process has
> >> been scanned once or twice by the NUMA code?
> >
> > You mean, the 2-3rd time we try and migrate this task, not the memory
> > scanning thing as per Andrea, right?
> 
> Indeed.  That way we can simply keep a flag somewhere,
> instead of iterating over the threads in a process.

Note that the code in -tip needs to iterate over all tasks in order to
test all cpus_allowed and mems_allowed masks. But we could keep a
process wide intersection of those masks around as well I guess,
updating them is a slow path anyway.

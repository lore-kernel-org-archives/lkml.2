Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab2GIMk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:40:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57005 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab2GIMk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:40:58 -0400
Message-ID: <1341837624.3462.68.camel@twins>
Subject: Re: [RFC][PATCH 14/26] sched, numa: Numa balancer
From: Peter Zijlstra <peterz@infradead.org>
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
Date: Mon, 09 Jul 2012 14:40:24 +0200
In-Reply-To: <1341836629.3462.60.camel@twins>
References: <20120316144028.036474157@chello.nl>
	 <20120316144241.012558280@chello.nl> <4FF87F5F.30106@redhat.com>
	 <1341836629.3462.60.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 14:23 +0200, Peter Zijlstra wrote:
> > It is not yet clear to me how and why your code converges.
> 
> I don't think it does.. but since the scheduler interaction is fairly
> weak it doesn't matter too much from that pov.
> 
That is,.. it slowly moves along with the cpu usage, only if there's a
lot of remote memory allocations (memory pressure) things get funny. 

It'll try and rotate all tasks around a bit trying, but there's no good
solution for a memory hole on one node and a cpu hole on another, you're
going to have to take the remote hits.

Again.. what do we want it to do?

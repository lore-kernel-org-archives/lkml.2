Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2C0IkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 04:40:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51105 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab2C0IkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 04:40:21 -0400
Message-ID: <1332837595.16159.208.camel@twins>
Subject: Re: [PATCH 11/39] autonuma: CPU follow memory algorithm
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dan Smith <danms@us.ibm.com>, Paul Turner <pjt@google.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>, Bharata B Rao <bharata.rao@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Date: Tue, 27 Mar 2012 10:39:55 +0200
In-Reply-To: <20120326203951.GZ5906@redhat.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
	 <1332783986-24195-12-git-send-email-aarcange@redhat.com>
	 <1332786353.16159.173.camel@twins> <4F70C365.8020009@redhat.com>
	 <20120326194435.GW5906@redhat.com>
	 <CA+55aFwk0Etg_UhoZcKsfFJ7PQNLdQ58xxXiwcA-jemuXdZCZQ@mail.gmail.com>
	 <20120326203951.GZ5906@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 22:39 +0200, Andrea Arcangeli wrote:

> > No, you can't just say that it's limited to some large constant, and thus
> > the same as O(1).
> 
> I pointed out it is O(1) just because if we use the O notation we may
> as well do the math right about it.

I think you have a fundamental mis-understanding of the concepts here.
You do not get to fill in n for whatever specific instance of the
problem you have.

The traveling salesman problem can be solved in O(n!), simply because
you know your route will not be larger than 10 houses doesn't mean you
can say your algorithm will be O(10!) and thus O(1).

That's simply not how it works.

You can talk pretty much anything down to O(1) that way. Take an
algorithm that is O(n) in the number of tasks, since you know you have a
pid-space constraint of 30bits you can never have more than 2^30 (aka
1Gi) tasks, hence your algorithm is O(2^30) aka O(1).

> I also would welcome people who knows the scheduler so much better
> than me to rewrite or fix it as they like it.

Again, you seem unclear on how things work, you want this nonsense, you
get to write it.

I am most certainly not going to fix your mess as I completely disagree
with the approach taken.

> I probably wasn't clear enough, but I already implicitly meant it
> shall be optimized further later.

You're in fact very unclear. You post patches without the RFC tag,
meaning you think they're ready to be considered. You write huge
misleading comments instead of /* XXX crap, needs fixing */.

Also, I find your language to be overly obtuse and hard to parse, but
that could be my fault, we're both non-native speakers.

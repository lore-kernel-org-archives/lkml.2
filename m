Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab2GIMHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:07:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34716 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab2GIMHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:07:16 -0400
Message-ID: <1341835552.3462.50.camel@twins>
Subject: Re: [RFC][PATCH 14/26] sched, numa: Numa balancer
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
Date: Mon, 09 Jul 2012 14:05:52 +0200
In-Reply-To: <4FF87F5F.30106@redhat.com>
References: <20120316144028.036474157@chello.nl>
	 <20120316144241.012558280@chello.nl> <4FF87F5F.30106@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-07 at 14:26 -0400, Rik van Riel wrote:
> > +/*
> > + * Assumes symmetric NUMA -- that is, each node is of equal size.
> > + */
> > +static void set_max_mem_load(unsigned long load)
> > +{
> > +     unsigned long old_load;
> > +
> > +     spin_lock(&max_mem_load.lock);
> > +     old_load = max_mem_load.load;
> > +     if (!old_load)
> > +             old_load = load;
> > +     max_mem_load.load = (old_load + load) >> 1;
> > +     spin_unlock(&max_mem_load.lock);
> > +}
> 
> The above in your patch kind of conflicts with this bit
> from patch 6/26:

Yeah,.. its pretty broken. Its also effectively disabled, but yeah.


> Looking at how the memory load code is used, I wonder
> if it would make sense to count "zone size - free - inactive
> file" pages instead? 

Something like that, although I guess we'd want a sum over all zones in
a node for that.

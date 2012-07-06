Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab2GFPBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:01:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39309 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2GFPBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:01:40 -0400
Message-ID: <1341586848.7709.54.camel@twins>
Subject: Re: [RFC][PATCH 02/26] mm, mpol: Remove NUMA_INTERLEAVE_HIT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kyungmin Park <kmpark@infradead.org>
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
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Fri, 06 Jul 2012 17:00:48 +0200
In-Reply-To: <CAH9JG2U-_RzDQ9TgjXWSBFjscCKn0oKp1mhvOsRVoxR7hsSxHA@mail.gmail.com>
References: <20120316144028.036474157@chello.nl>
	 <20120316144240.234456258@chello.nl>
	 <CAH9JG2U-_RzDQ9TgjXWSBFjscCKn0oKp1mhvOsRVoxR7hsSxHA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 23:54 +0900, Kyungmin Park wrote:
> >  static struct zonelist *policy_zonelist(gfp_t gfp, struct mempolicy *policy,
> >         int nd)
> >  {
> >         switch (policy->mode) {
> > +       case MPOL_INTERLEAVE:
> > +               nd = interleave_nodes(policy);
> Jut nitpick,
> Original code also uses the 'unsigned nid' but now it assigned
> 'unsigned nid' to 'int nd' at here. does it right? 

node id is generally signed, we use -1 as a special value indicating no
node preference in a number of places. Not sure why it was unsigned
here. Also I think even SGI isn't anywhere near 2^31 nodes.

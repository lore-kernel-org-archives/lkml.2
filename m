Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab2FZFYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 01:24:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61296 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2FZFYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 01:24:47 -0400
Date: Mon, 25 Jun 2012 22:24:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 09/11] memcg: propagate kmem limiting information to
 children
In-Reply-To: <20120625162352.51997c5a.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1206252224350.30072@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-10-git-send-email-glommer@parallels.com> <20120625162352.51997c5a.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012, Andrew Morton wrote:

> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -287,7 +287,11 @@ struct mem_cgroup {
> >  	 * Should the accounting and control be hierarchical, per subtree?
> >  	 */
> >  	bool use_hierarchy;
> > -	bool kmem_accounted;
> > +	/*
> > +	 * bit0: accounted by this cgroup
> > +	 * bit1: accounted by a parent.
> > +	 */
> > +	volatile unsigned long kmem_accounted;
> 
> I suggest
> 
> 	unsigned long kmem_accounted;	/* See KMEM_ACCOUNTED_*, below */
> 
> >  	bool		oom_lock;
> >  	atomic_t	under_oom;
> > @@ -340,6 +344,9 @@ struct mem_cgroup {
> >  #endif
> >  };
> >  
> > +#define KMEM_ACCOUNTED_THIS	0
> > +#define KMEM_ACCOUNTED_PARENT	1
> 
> And then document the fields here.
> 

In hex, please?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab2FZJDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:03:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56859 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2FZJDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:03:16 -0400
Date: Tue, 26 Jun 2012 02:03:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 05/11] Add a __GFP_KMEMCG flag
In-Reply-To: <4FE95FF0.3000300@parallels.com>
Message-ID: <alpine.DEB.2.00.1206260202190.16020@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206252123230.26640@chino.kir.corp.google.com> <4FE95FF0.3000300@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2012, Glauber Costa wrote:

> > > >This flag is used to indicate to the callees that this allocation will be
> > > >serviced to the kernel. It is not supposed to be passed by the callers
> > > >of kmem_cache_alloc, but rather by the cache core itself.
> > > >
> > Not sure what "serviced to the kernel" means, does this mean that the
> > memory will not be accounted for to the root memcg?
> > 
> In this context, it means that is a kernel allocation, not a userspace one
> (but in process context, of course), *and* it is to be accounted a
> specific memcg.
> 

Ah, that makes sense.  I think it would help if this was included in the 
changelog as well as a specifying that it is accounted to current's memcg 
at the time of the allocation in a comment in the code.

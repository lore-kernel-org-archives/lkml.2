Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab2FYSiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 14:38:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35909 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab2FYSiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:38:23 -0400
Date: Mon, 25 Jun 2012 11:38:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 11/11] protect architectures where THREAD_SIZE >=
 PAGE_SIZE against fork bombs
Message-ID: <20120625183818.GH3869@google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
 <1340633728-12785-12-git-send-email-glommer@parallels.com>
 <4FE89807.50708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE89807.50708@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 06:55:35PM +0200, Frederic Weisbecker wrote:
> On 06/25/2012 04:15 PM, Glauber Costa wrote:
> 
> > Because those architectures will draw their stacks directly from
> > the page allocator, rather than the slab cache, we can directly
> > pass __GFP_KMEMCG flag, and issue the corresponding free_pages.
> > 
> > This code path is taken when the architecture doesn't define
> > CONFIG_ARCH_THREAD_INFO_ALLOCATOR (only ia64 seems to), and has
> > THREAD_SIZE >= PAGE_SIZE. Luckily, most - if not all - of the
> > remaining architectures fall in this category.
> > 
> > This will guarantee that every stack page is accounted to the memcg
> > the process currently lives on, and will have the allocations to fail
> > if they go over limit.
> > 
> > For the time being, I am defining a new variant of THREADINFO_GFP, not
> > to mess with the other path. Once the slab is also tracked by memcg,
> > we can get rid of that flag.
> > 
> > Tested to successfully protect against :(){ :|:& };:
> > 
> > Signed-off-by: Glauber Costa <glommer@parallels.com>
> > CC: Christoph Lameter <cl@linux.com>
> > CC: Pekka Enberg <penberg@cs.helsinki.fi>
> > CC: Michal Hocko <mhocko@suse.cz>
> > CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > CC: Johannes Weiner <hannes@cmpxchg.org>
> > CC: Suleiman Souhlal <suleiman@google.com>
> 
> 
> Acked-by: Frederic Weisbecker <fweisbec@redhat.com>

Frederic, does this (with proper slab accounting added later) achieve
what you wanted with the task counter?

Thanks.

-- 
tejun

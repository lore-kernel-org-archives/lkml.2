Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2FYSHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 14:07:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51594 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2FYSHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:07:53 -0400
Date: Mon, 25 Jun 2012 11:07:47 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 07/11] mm: Allocate kernel pages to the right memcg
Message-ID: <20120625180747.GE3869@google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
 <1340633728-12785-8-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340633728-12785-8-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 06:15:24PM +0400, Glauber Costa wrote:
> When a process tries to allocate a page with the __GFP_KMEMCG flag,
> the page allocator will call the corresponding memcg functions to
> validate the allocation. Tasks in the root memcg can always proceed.
> 
> To avoid adding markers to the page - and a kmem flag that would
> necessarily follow, as much as doing page_cgroup lookups for no
> reason, whoever is marking its allocations with __GFP_KMEMCG flag
> is responsible for telling the page allocator that this is such an
> allocation at free_pages() time. This is done by the invocation of
> __free_accounted_pages() and free_accounted_pages().

Shouldn't we be documenting that in the code somewhere, preferably in
the function comments?

-- 
tejun

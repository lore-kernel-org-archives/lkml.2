Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab2JSTry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:47:54 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:38650 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754950Ab2JSTrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:47:53 -0400
Date: Fri, 19 Oct 2012 19:47:51 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        kamezawa.hiroyu@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, devel@openvz.org,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 14/18] memcg/sl[au]b: shrink dead caches
In-Reply-To: <1350656442-1523-15-git-send-email-glommer@parallels.com>
Message-ID: <0000013a7a9144d1-de184c46-2a7d-4e6c-8606-927cc1f48969-000000@email.amazonses.com>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com> <1350656442-1523-15-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012, Glauber Costa wrote:

> An unlikely branch is used to make sure this case does not affect
> performance in the usual slab_free path.
>
> The slab allocator has a time based reaper that would eventually get rid
> of the objects, but we can also call it explicitly, since dead caches
> are not a likely event.

This is also something that could be done from slab_common since all
allocators have kmem_cache_shrink and kmem_cache_shrink can be used to
drain the caches and free up empty slab pages.


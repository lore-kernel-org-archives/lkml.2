Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab2KFA5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 19:57:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2KFA5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 19:57:07 -0500
Date: Mon, 5 Nov 2012 16:57:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v6 26/29] Aggregate memcg cache values in slabinfo
Message-Id: <20121105165706.f2f37f46.akpm@linux-foundation.org>
In-Reply-To: <1351771665-11076-27-git-send-email-glommer@parallels.com>
References: <1351771665-11076-1-git-send-email-glommer@parallels.com>
	<1351771665-11076-27-git-send-email-glommer@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Nov 2012 16:07:42 +0400
Glauber Costa <glommer@parallels.com> wrote:

> When we create caches in memcgs, we need to display their usage
> information somewhere. We'll adopt a scheme similar to /proc/meminfo,
> with aggregate totals shown in the global file, and per-group
> information stored in the group itself.
> 
> For the time being, only reads are allowed in the per-group cache.
> 
> ...
>
> +#define for_each_memcg_cache_index(_idx)	\
> +	for ((_idx) = 0; i < memcg_limited_groups_array_size; (_idx)++)

Use of this requires slab_mutex, yes?

Please add a comment, and confirm that all callers do indeed hold the
correct lock.


We could add a mutex_is_locked() check to the macro perhaps, but this
isn't the place to assume the presence of slab_mutex, so it gets messy.

>
> ...
>

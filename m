Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab2FZJRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:17:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46837 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab2FZJRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:17:47 -0400
Date: Tue, 26 Jun 2012 02:17:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        Tejun Heo <tj@kernel.org>, Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 02/11] memcg: Reclaim when more than one page needed.
In-Reply-To: <4FE97C20.8010500@parallels.com>
Message-ID: <alpine.DEB.2.00.1206260214310.16020@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-3-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206252106430.26640@chino.kir.corp.google.com> <4FE960D6.4040409@parallels.com>
 <alpine.DEB.2.00.1206260146010.16020@chino.kir.corp.google.com> <4FE97C20.8010500@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2012, Glauber Costa wrote:

> > Nope, have you checked the output of /sys/kernel/slab/.../order when
> > running slub?  On my workstation 127 out of 316 caches have order-2 or
> > higher by default.
> > 
> 
> Well, this is still on the side of my argument, since this is still a majority
> of them being low ordered.

Ok, so what happens if I pass slub_min_order=2 on the command line?  We 
never retry?

> The code here does not necessarily have to retry -
> if I understand it correctly - we just retry for very small allocations
> because that is where our likelihood of succeeding is.
> 

Well, the comment for NR_PAGES_TO_RETRY says

	/*
	 * We need a number that is small enough to be likely to have been
	 * reclaimed even under pressure, but not too big to trigger unnecessary 
	 * retries
	 */

and mmzone.h says

	/*
	 * PAGE_ALLOC_COSTLY_ORDER is the order at which allocations are deemed
	 * costly to service.  That is between allocation orders which should
	 * coalesce naturally under reasonable reclaim pressure and those which
	 * will not.
	 */
	#define PAGE_ALLOC_COSTLY_ORDER 3

so I'm trying to reconcile which one is correct.

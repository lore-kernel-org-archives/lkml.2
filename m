Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab2ECP2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:28:51 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:46653 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992Ab2ECP2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:28:50 -0400
Date: Thu, 3 May 2012 17:28:41 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Miller <davem@davemloft.net>
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] mm: nobootmem: Correct alloc_bootmem semantics.
Message-ID: <20120503152841.GA19918@cmpxchg.org>
References: <20120425.161050.1011838269798884593.davem@davemloft.net>
 <CAE9FiQWYPPXA0YmgBP6SkKiEaLJJnzxMqPn2_VwOKoYSKGwULQ@mail.gmail.com>
 <20120425.190034.632638679653622318.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120425.190034.632638679653622318.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 07:00:34PM -0400, David Miller wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> Date: Wed, 25 Apr 2012 15:46:42 -0700
> 
> > On Wed, Apr 25, 2012 at 1:10 PM, David Miller <davem@davemloft.net> wrote:
> >> @@ -298,13 +298,19 @@ void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
> >>        if (WARN_ON_ONCE(slab_is_available()))
> >>                return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
> >>
> >> +again:
> >>        ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
> >>                                         goal, -1ULL);
> >>        if (ptr)
> >>                return ptr;
> > 
> > If you want to be consistent to bootmem version.
> > 
> > again label should be here instead.
> 
> It is merely an artifact of implementation that the bootmem version
> doesn't try to respect the given node if the goal cannot be satisfied,
> and in fact I would classify that as a bug that needs to be fixed.
> 
> Therefore, I believe the bootmem case is what needs to be adjusted
> instead.

Now it does: node+goal, goal, node, anywhere

whereas the memblock version of __alloc_bootmem_node_nopanic() also
still does: node+goal, goal, anywhere

Your description suggests that the node should be higher prioritized
than the goal, which I understand as: node+goal, node, anywhere.

Which do we actually want?

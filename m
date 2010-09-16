Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab0IPRtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:49:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755822Ab0IPRta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:49:30 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1009161209240.22849@router.home>
References: <1284490101-2362-1-git-send-email-penberg@kernel.org>
 <1284490101-2362-2-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1009141243290.1470@chino.kir.corp.google.com>
 <AANLkTinj2P_QbdgdLS3BweSMDzhQH5g4p2B3SqS=CNYc@mail.gmail.com>
 <alpine.DEB.2.00.1009141320090.7123@chino.kir.corp.google.com>
 <4C8FE263.5070101@kernel.org> <alpine.DEB.2.00.1009141646350.26982@chino.kir.corp.google.com>
 <1097CAA8-8234-4FE2-BAA1-9C7D9FA01CEC@mit.edu> <alpine.DEB.2.00.1009151322370.29425@chino.kir.corp.google.com>
 <20100915222509.GE3730@thunk.org> <alpine.DEB.2.00.1009151537080.15256@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1009161209240.22849@router.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Sep 2010 10:49:01 -0700
Message-ID: <AANLkTinPEWHmPsjyfJ-nez9yCdHKgCU3oVhNo0gdMpj6@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
To: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>, "Ted Ts'o" <tytso@mit.edu>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 10:39 AM, Christoph Lameter <cl@linux.com> wrote:
>
> The main point of merging slabs is to reduce memory footprint and
> avoid the overhead of managing more slab caches. Performance is a side
> effect that may come about due to a reduced cache footprint if multiple
> caches that are mapped to the same merged cache are used in the same
> context.

The thing is, if we were to be able to separate the _accounting_ from
the allocation, we'd get the best of both worlds.

Maybe slub could have separate 'struct kmem_cache' structures for each
slab, and not merge at that level, but then have a merged _allocator_.
We already have a level of indirection there due to the whole per-cpu
front-end, so maybe it wouldn't even cause any extra pointer chasing.

That would allow slabtop etc to show the number of actual allocations
at the granularity that we want (ie you'd see who is the real user),
but still then use the same slab pages and avoid the slab
fragmentation.

How painful would it be to try to re-organize things like this?
Impossible? Very hard? Or just "need to think about it a bit"?

                                    Linus

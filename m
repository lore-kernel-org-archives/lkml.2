Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab0IAKG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 06:06:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42115 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab0IAKGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 06:06:54 -0400
Subject: Re: [PATCH V2 0/4] sched: add new 'book' scheduling domain
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <20100831082814.501484459@de.ibm.com>
References: <20100831082814.501484459@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Sep 2010 12:06:41 +0200
Message-ID: <1283335601.2059.880.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 10:28 +0200, Heiko Carstens wrote:
> This patch set adds (yet) another scheduling domain to the scheduler. The
> reason for this is that the recent (s390) z196 architecture has four cache
> levels and uniform memory access (sort of -- see below).
> The cpu/cache/memory hierarchy is as follows:
> 
> Each cpu has its private L1 (64KB I-cache + 128KB D-cache) and L2 (1.5MB)
> cache.
> A core consists of four cpus with a 24MB shared L3 cache.
> A book consists of six cores with a 192MB shared L4 cache.
> 
> The z196 architecture has no SMT.
> Also the statement that we have uniform memory access is not entirely
> correct. Actually the machine uses memory striping, so it "looks" like
> we have UMA until the next slice of memory gets accessed.
> However there is no interface which tells us which piece of memory is local
> or remote. So we (have to) simplify and assume that the cost of each memory
> access with L4 cache miss is the same.
> 
> In order to somehow use the information about the cache hierarchy so that
> the scheduler can make some decisions that improves cache hits I added the
> 'BOOK' scheduling domain between the MC and CPU domains.

Took the patches, but the description of the main patch is a bit
wanting, it implies books are useful for NUMA like things when there
isn't any information on where the node boundaries are, which isn't what
you say here, which is that a book is the L4 cache level.

<rant>
Ideally we'd kill all the sd->level stuff and rework the domain creation
like outlined before and simply go by sd->flags domain properties. At
that point you can simply tag this as yet another cache level.
</rant>




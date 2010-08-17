Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab0HQIAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:00:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:33632 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab0HQIAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:00:03 -0400
Message-ID: <4C6A408C.6040203@kernel.org>
Date: Tue, 17 Aug 2010 09:55:56 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q3 00/23] SLUB: The Unified slab allocator (V3)
References: <20100804024514.139976032@linux.com> <alpine.DEB.2.00.1008032138160.20049@chino.kir.corp.google.com> <alpine.DEB.2.00.1008041115500.11084@router.home> <alpine.DEB.2.00.1008050136340.30889@chino.kir.corp.google.com> <alpine.DEB.2.00.1008051231400.6787@router.home> <alpine.DEB.2.00.1008151627450.27137@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1008151627450.27137@chino.kir.corp.google.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 17 Aug 2010 07:59:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/17/2010 06:56 AM, David Rientjes wrote:
> I'm adding Tejun Heo to the cc because of another thing that may be 
> problematic: alloc_percpu() allocates GFP_KERNEL memory, so when we try to 
> allocate kmem_cache_cpu for a DMA cache we may be returning memory from a 
> node that doesn't include lowmem so there will be no affinity between the 
> struct and the slab.  I'm wondering if it would be better for the percpu 
> allocator to be extended for kzalloc_node(), or vmalloc_node(), when 
> allocating memory after the slab layer is up.

Hmmm... do you mean adding @gfp_mask to percpu allocation function?
I've been thinking about adding it for atomic allocations (Christoph,
do you still want it?).  I've been sort of against it because I
primarily don't really like atomic allocations (it often just pushes
error handling complexities elsewhere where it becomes more complex)
and it would also require making vmalloc code do atomic allocations.

Most of percpu use cases seem pretty happy with GFP_KERNEL allocation,
so I'm still quite reluctant to change that.  We can add a semi
internal interface w/ @gfp_mask but w/o GFP_ATOMIC support, which is a
bit ugly.  How important would this be?

Thanks.

-- 
tejun

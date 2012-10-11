Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2JKXfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 19:35:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:47237 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab2JKXfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 19:35:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,573,1344236400"; 
   d="scan'208";a="232947011"
Date: Thu, 11 Oct 2012 16:35:41 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v3
Message-ID: <20121011233541.GN2095@tassilo.jf.intel.com>
References: <1349303063-12766-1-git-send-email-andi@firstfloor.org>
 <1349303063-12766-2-git-send-email-andi@firstfloor.org>
 <20121009151907.3f61ebca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009151907.3f61ebca.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alas, include/asm-generic/mman.h doesn't exist now.

git resolved it automagically

> 
> Does this change touch all the hugetlb-capable architectures?

I took a look at this again. So not every hugetlb capable architecture
needs it, only architectures with multiple hugetlb page sizes.

This is only x86, tile, powerpc

I looked at tile and powerpc and they both have configurable
hugetlb page sizes. So it's somewhat awkward to add defines
for them.

One disadvantage of this is also the user programs would need
to know the page sizes that are configured. That is definitely
awkward, but I don't know of any way around that.

Luckily there's a way in /sys to query this.

-Andi

> 
> z:/usr/src/linux-3.6> grep -rl MAP_HUGETLB arch
> arch/alpha/include/asm/mman.h
> arch/xtensa/include/asm/mman.h
> arch/parisc/include/asm/mman.h
> arch/tile/include/asm/mman.h
> arch/sparc/include/asm/mman.h
> arch/powerpc/include/asm/mman.h
> arch/mips/include/asm/mman.h

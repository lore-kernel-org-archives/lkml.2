Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab2E3UhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:37:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:57860 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab2E3UhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:37:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158853553"
From: Andi Kleen <andi@firstfloor.org>
To: kosaki.motohiro@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, stable@vger.kernel.org,
        hughd@google.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miao Xie <miaox@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 5/6] mempolicy: fix a memory corruption by refcount imbalance in alloc_pages_vma()
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com>
	<1338368529-21784-6-git-send-email-kosaki.motohiro@gmail.com>
Date: Wed, 30 May 2012 13:37:03 -0700
In-Reply-To: <1338368529-21784-6-git-send-email-kosaki.motohiro@gmail.com>
	(kosaki motohiro's message of "Wed, 30 May 2012 05:02:08 -0400")
Message-ID: <m2r4u1jths.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kosaki.motohiro@gmail.com writes:

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> commit cc9a6c8776 (cpuset: mm: reduce large amounts of memory barrier related
> damage v3) introduced a memory corruption.
>
> shmem_alloc_page() passes pseudo vma and it has one significant unique
> combination, vma->vm_ops=NULL and (vma->policy->flags & MPOL_F_SHARED).
>
> Now, get_vma_policy() does NOT increase a policy ref when vma->vm_ops=NULL
> and mpol_cond_put() DOES decrease a policy ref when a policy has MPOL_F_SHARED.
> Therefore, when cpuset race is happen and alloc_pages_vma() fall in
> 'goto retry_cpuset' path, a policy refcount will be decreased too much and
> therefore it will make memory corruption.
>
> This patch fixes it.

Looks good.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

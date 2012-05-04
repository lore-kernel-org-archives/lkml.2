Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab2EDH1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 03:27:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:51320 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab2EDH13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 03:27:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="96294896"
Message-ID: <4FA38495.1020207@intel.com>
Date: Fri, 04 May 2012 15:26:13 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
        mgorman@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] THP: need is_vma_temporary_stack() when reference transparent_hugepage_enabled
References: <1335594795-30876-1-git-send-email-alex.shi@intel.com> <20120430160520.4c1cc05c.akpm@linux-foundation.org> <4FA0A743.2070904@intel.com> <20120502175508.GC2410@redhat.com> <4FA1D7D9.1050402@intel.com> <20120503112530.GE2410@redhat.com>
In-Reply-To: <20120503112530.GE2410@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 07:25 PM, Andrea Arcangeli wrote:

> Hi,
> 
> On Thu, May 03, 2012 at 08:56:57AM +0800, Alex Shi wrote:
>>
>>> My preference would still be to remove the is_vma_temporary_stack and
>>> use two vmas during mremap of execve, that would remove the "vma"
>>> parameter from transparent_hugepage_enabled() but others prefers to
>>> skip a vma allocation in execve and stick to is_vma_temporary_stack,
>>> which is fair enough argument.
>>
>>
>> Actually, current transparent_hugepage_enabled just means the vma is in
>> THP enable ENV, the vma is just possibly has some large page, no grantee
>> really has.  But in lots situations, user wants to know if a vma or a
>> part of memory really include a large page. not the possibility.
>>
>> So, it will be great to see a real large page checking function appearing.
> 
> Well, to know if a VMA (or a memory range) really includes a THP, it'd
> require to hold the page_table_lock and a loop on all pmds in the
> range, but by the time you relase the lock things may have already
> changed as split_huge_page can run at any time, madvise(MADV_DONTNEED)
> too if you only hold the mmap_sem in read mode and the THP page
> fault. In fact while holding the mmap_sem in read mode (the usual read
> lock you need to take to lookup and stabilize the vma) a THP can be
> freed and reallocated under it, and that's what pmd_trans_unstable is
> about.


Appreciate for explanation!

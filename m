Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab2ECA6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 20:58:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:46671 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab2ECA6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 20:58:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95759756"
Message-ID: <4FA1D7D9.1050402@intel.com>
Date: Thu, 03 May 2012 08:56:57 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
        mgorman@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] THP: need is_vma_temporary_stack() when reference transparent_hugepage_enabled
References: <1335594795-30876-1-git-send-email-alex.shi@intel.com> <20120430160520.4c1cc05c.akpm@linux-foundation.org> <4FA0A743.2070904@intel.com> <20120502175508.GC2410@redhat.com>
In-Reply-To: <20120502175508.GC2410@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> My preference would still be to remove the is_vma_temporary_stack and
> use two vmas during mremap of execve, that would remove the "vma"
> parameter from transparent_hugepage_enabled() but others prefers to
> skip a vma allocation in execve and stick to is_vma_temporary_stack,
> which is fair enough argument.


Actually, current transparent_hugepage_enabled just means the vma is in
THP enable ENV, the vma is just possibly has some large page, no grantee
really has.  But in lots situations, user wants to know if a vma or a
part of memory really include a large page. not the possibility.

So, it will be great to see a real large page checking function appearing.

> 
>> Oh, yes. Since is_vma_temporay_stack is just used in rmap.c and huge_memory.c
>> . is it better to move it to huge_mm.h?
> 
> I guess it was cleaner on rmap.h as this is not related to THP, but
> clearly it works better in huge_mm.h (and rmap.h->mm.h->huge_mm.h is
> included automatically) so the patch looks fine to me.


Thanks for point out.

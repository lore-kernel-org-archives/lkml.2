Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab2KPT2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:28:41 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39631 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2KPT2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:28:39 -0500
Date: Fri, 16 Nov 2012 11:28:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] thp: fix update_mmu_cache_pmd() calls
In-Reply-To: <1353059717-9850-1-git-send-email-kirill.shutemov@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1211161126450.2788@chino.kir.corp.google.com>
References: <1353059717-9850-1-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2012, Kirill A. Shutemov wrote:

> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> update_mmu_cache_pmd() takes pointer to pmd_t as third, not pmd_t.
> 
> mm/huge_memory.c: In function 'do_huge_pmd_numa_page':
> mm/huge_memory.c:825:2: error: incompatible type for argument 3 of 'update_mmu_cache_pmd'
> In file included from include/linux/mm.h:44:0,
>                  from mm/huge_memory.c:8:
> arch/mips/include/asm/pgtable.h:385:20: note: expected 'struct pmd_t *' but argument is of type 'pmd_t'
> mm/huge_memory.c:895:2: error: incompatible type for argument 3 of 'update_mmu_cache_pmd'
> In file included from include/linux/mm.h:44:0,
>                  from mm/huge_memory.c:8:
> arch/mips/include/asm/pgtable.h:385:20: note: expected 'struct pmd_t *' but argument is of type 'pmd_t'
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

[routing to Ingo for numa/core, which this is based on]

Acked-by: David Rientjes <rientjes@google.com>

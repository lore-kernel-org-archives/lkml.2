Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab2JEWBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 18:01:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab2JEWBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 18:01:11 -0400
Date: Fri, 5 Oct 2012 15:01:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: linux-mm@kvack.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        aarcange@redhat.com, hannes@cmpxchg.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH v2 5/7] mm: Add and use update_mmu_cache_pmd() in
 transparent huge page code.
Message-Id: <20121005150110.fdf08c96.akpm@linux-foundation.org>
In-Reply-To: <20121004.154738.461031090401264236.davem@davemloft.net>
References: <20121004.154738.461031090401264236.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Oct 2012 15:47:38 -0400 (EDT)
David Miller <davem@davemloft.net> wrote:

> The transparent huge page code passes a PMD pointer in as the third
> argument of update_mmu_cache(), which expects a PTE pointer.
> 
> This never got noticed because X86 implements update_mmu_cache() as a
> macro and thus we don't get any type checking, and X86 is the only
> architecture which supports transparent huge pages currently.
> 
> Before oter architectures can support transparent huge pages properly
> we need to add a new interface which will take a PMD pointer as the
> third argument rather than a PTE pointer.

I'll toss this on top:

--- a/arch/s390/include/asm/pgtable.h~mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix
+++ a/arch/s390/include/asm/pgtable.h
@@ -42,6 +42,7 @@ extern void fault_init(void);
  * tables contain all the necessary information.
  */
 #define update_mmu_cache(vma, address, ptep)     do { } while (0)
+#define update_mmu_cache_pmd(vma, address, ptep) do { } while (0)
 
 /*
  * ZERO_PAGE is a global shared page that is always zero; used
_

and I trust that Gerald will be able to review test the result once all
this has landed, please.


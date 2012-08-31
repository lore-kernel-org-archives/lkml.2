Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab2HaHKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 03:10:22 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:47358 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2HaHKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 03:10:19 -0400
Date: Fri, 31 Aug 2012 09:10:12 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC v2 PATCH 1/7] thp: remove assumptions on pgtable_t type
Message-ID: <20120831091012.7b710326@de.ibm.com>
In-Reply-To: <877gsf633x.fsf@linux.vnet.ibm.com>
References: <1346254384-30046-1-git-send-email-gerald.schaefer@de.ibm.com>
	<1346254384-30046-2-git-send-email-gerald.schaefer@de.ibm.com>
	<877gsf633x.fsf@linux.vnet.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12083107-1948-0000-0000-000002D16110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2012 10:59:38 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> Gerald Schaefer <gerald.schaefer@de.ibm.com> writes:
> 
> > The thp page table pre-allocation code currently assumes that pgtable_t
> > is of type "struct page *". This may not be true for all architectures,
> > so this patch removes that assumption by replacing the functions
> > prepare_pmd_huge_pte() and get_pmd_huge_pte() with two new functions
> > that can be defined architecture-specific.
> >
> > It also removes two VM_BUG_ON checks for page_count() and page_mapcount()
> > operating on a pgtable_t. Apart from the VM_BUG_ON removal, there will
> > be no functional change introduced by this patch.
> 
> Why is that VM_BUG_ON not needed any more ? What is that changed which break
> that requirement ?

Because pgtable_t for s390 is not a page and there simply is no page_count or
page_mapcount.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


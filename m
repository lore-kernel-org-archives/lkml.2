Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab2HaFwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 01:52:39 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:33806 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2HaFwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 01:52:38 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [RFC v2 PATCH 1/7] thp: remove assumptions on pgtable_t type
In-Reply-To: <1346254384-30046-2-git-send-email-gerald.schaefer@de.ibm.com>
References: <1346254384-30046-1-git-send-email-gerald.schaefer@de.ibm.com> <1346254384-30046-2-git-send-email-gerald.schaefer@de.ibm.com>
User-Agent: Notmuch/0.13.2+63~g548a9bf (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 31 Aug 2012 10:59:38 +0530
Message-ID: <877gsf633x.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12083105-7014-0000-0000-000001D11435
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerald Schaefer <gerald.schaefer@de.ibm.com> writes:

> The thp page table pre-allocation code currently assumes that pgtable_t
> is of type "struct page *". This may not be true for all architectures,
> so this patch removes that assumption by replacing the functions
> prepare_pmd_huge_pte() and get_pmd_huge_pte() with two new functions
> that can be defined architecture-specific.
>
> It also removes two VM_BUG_ON checks for page_count() and page_mapcount()
> operating on a pgtable_t. Apart from the VM_BUG_ON removal, there will
> be no functional change introduced by this patch.

Why is that VM_BUG_ON not needed any more ? What is that changed which break
that requirement ?

-aneesh


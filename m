Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab2HYMgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 08:36:46 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62780 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2HYMgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 08:36:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120823171854.473831303@de.ibm.com>
References: <20120823171733.595087166@de.ibm.com>
	<20120823171854.473831303@de.ibm.com>
Date: Sat, 25 Aug 2012 20:36:37 +0800
Message-ID: <CAJd=RBBQJCxgdrEnAdoVu+PLjkzTOBnDyJX_bqUdbQdo5TQoJw@mail.gmail.com>
Subject: Re: [RFC patch 2/7] thp: introduce pmdp_invalidate()
From: Hillf Danton <dhillf@gmail.com>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
        ak@linux.intel.com, hughd@google.com, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 1:17 AM, Gerald Schaefer
<gerald.schaefer@de.ibm.com> wrote:

> +#ifndef __HAVE_ARCH_PMDP_INVALIDATE
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +static inline void pmdp_invalidate(struct vm_area_struct *vma,
> +                                  unsigned long address, pmd_t *pmdp)
> +{
> +       set_pmd_at(vma->vm_mm, address, pmd, pmd_mknotpresent(*pmd));

	set_pmd_at(vma->vm_mm, address, pmdp, pmd_mknotpresent(*pmdp));  yes?

> +       flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
> +}

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab2IDW4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:56:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab2IDW4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:56:40 -0400
Date: Wed, 5 Sep 2012 00:56:33 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC v2 PATCH 1/7] thp: remove assumptions on pgtable_t type
Message-ID: <20120904225632.GN3334@redhat.com>
References: <1346254384-30046-1-git-send-email-gerald.schaefer@de.ibm.com>
 <1346254384-30046-2-git-send-email-gerald.schaefer@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346254384-30046-2-git-send-email-gerald.schaefer@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerald,

On Wed, Aug 29, 2012 at 05:32:58PM +0200, Gerald Schaefer wrote:
> +#ifndef __HAVE_ARCH_PGTABLE_DEPOSIT
> +extern void pgtable_deposit(struct mm_struct *mm, pgtable_t pgtable);
> +#endif

One minor nitpick on the naming of the two functions: considering that
those are global exports, that they can only be used by THP and they
mangle internally with the mm->pmd_huge_pte field (also only defined
if TRANSPARENT_HUGEPAGE=y), a more specific THP naming may be clearer.

If the current prepare_pmd_huge_pte/get_pmd_huge_pte wasn't good other
options could be pgtable_trans_huge_deposit/withdraw.

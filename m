Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015Ab2IERMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 13:12:24 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:56273 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2IERMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 13:12:22 -0400
Date: Wed, 5 Sep 2012 19:12:13 +0200
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC v2 PATCH 1/7] thp: remove assumptions on pgtable_t type
Message-ID: <20120905191213.694d201f@thinkpad>
In-Reply-To: <20120904225632.GN3334@redhat.com>
References: <1346254384-30046-1-git-send-email-gerald.schaefer@de.ibm.com>
	<1346254384-30046-2-git-send-email-gerald.schaefer@de.ibm.com>
	<20120904225632.GN3334@redhat.com>
Reply-To: gerald.schaefer@de.ibm.com
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12090517-0342-0000-0000-000002C2CC07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2012 00:56:33 +0200
Andrea Arcangeli <aarcange@redhat.com> wrote:

> Hi Gerald,
> 
> On Wed, Aug 29, 2012 at 05:32:58PM +0200, Gerald Schaefer wrote:
> > +#ifndef __HAVE_ARCH_PGTABLE_DEPOSIT
> > +extern void pgtable_deposit(struct mm_struct *mm, pgtable_t pgtable);
> > +#endif
> 
> One minor nitpick on the naming of the two functions: considering that
> those are global exports, that they can only be used by THP and they
> mangle internally with the mm->pmd_huge_pte field (also only defined
> if TRANSPARENT_HUGEPAGE=y), a more specific THP naming may be clearer.
> 
> If the current prepare_pmd_huge_pte/get_pmd_huge_pte wasn't good other
> options could be pgtable_trans_huge_deposit/withdraw.
> 

Thanks for your feedback. I'll send a new patch series with those
functions renamed, as it has impact on 3 of the 7 patches, and also
including the Kconfig change using HAVE_ARCH_TRANSPARENT_HUGEPAGE.


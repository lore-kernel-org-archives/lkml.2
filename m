Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab2DAMdJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 08:33:09 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49537 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2DAMdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 08:33:07 -0400
MIME-Version: 1.0
In-Reply-To: <201203311612.q2VGCqPA012710@farm-0012.internal.tilera.com>
References: <201203302018.q2UKIFH5020745@farm-0012.internal.tilera.com>
	<CAJd=RBCoLNB+iRX1shKGAwSbE8PsZXyk9e3inPTREcm2kk3nXA@mail.gmail.com>
	<201203311334.q2VDYGiL005854@farm-0012.internal.tilera.com>
	<CAJd=RBDEAMgDviSwugt7dHKPGXCCF5jQSDtHdXvt5VnSBmK3bA@mail.gmail.com>
	<201203311612.q2VGCqPA012710@farm-0012.internal.tilera.com>
Date: Sun, 1 Apr 2012 20:33:05 +0800
Message-ID: <CAJd=RBDqQ2jwxyVgn-WwoJfu0vOs9YUHfKxkcqUczr=cnk+8wg@mail.gmail.com>
Subject: Re: [PATCH v3] arch/tile: support multiple huge page sizes dynamically
From: Hillf Danton <dhillf@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 3:37 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> This change adds support for a new "super" bit in the PTE, and a
> new arch_make_huge_pte() method called from make_huge_pte().
> The Tilera hypervisor sees the bit set at a given level of the page
> table and gangs together 4, 16, or 64 consecutive pages from
> that level of the hierarchy to create a larger TLB entry.
>
> One extra "super" page size can be specified at each of the
> three levels of the page table hierarchy on tilegx, using the
> "hugepagesz" argument on the boot command line.  A new hypervisor
> API is added to allow Linux to tell the hypervisor how many PTEs
> to gang together at each level of the page table.
>
> To allow pre-allocating huge pages larger than the buddy allocator
> can handle, this change modifies the Tilera bootmem support to
> put all of memory on tilegx platforms into bootmem.
>
> As part of this change I eliminate the vestigial CONFIG_HIGHPTE
> support, which never worked anyway, and eliminate the hv_page_size()
> API in favor of the standard vma_kernel_pagesize() API.
>
> Reviewed-by: Hillf Danton <dhillf@gmail.com>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> This version of the patch adds a generic no-op definition to
> <linux/hugetlb.h> if "arch_make_huge_pte" is not #defined.  I'm following
> Linus's model in https://lkml.org/lkml/2012/1/19/443 which says you create
> the inline, then "#define func func" to indicate that the function exists.
>
> Hillf, let me know if you want to provide an Acked-by, or I'll leave it
> as Reviewed-by.  I'm glad you didn't like the v2 patch;
>
Frankly I like this work, if merged, many tile users benefit.

And a few more words,
1, the Reviewed-by tag does not match what I did, really, and
over 98% of this work should be reviewed by tile gurus IMO.

2, this work was delivered in a monolithic huge patch, and it is hard
to be reviewed. The rule of thumb is to split it into several parts, then
reviewers read a good story, chapter after another.

3, I look forward to reading the mm/hugetlb.c chapter.

Good weekend
-hd

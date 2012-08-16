Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2HPMkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 08:40:31 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56602 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab2HPMkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:40:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120815160342.5b77bd3b.akpm@linux-foundation.org>
References: <CAJd=RBC9HhKh5Q0-yXi3W0x3guXJPFz4BNsniyOFmp0TjBdFqg@mail.gmail.com>
	<20120806132410.GA6150@dhcp22.suse.cz>
	<CAJd=RBCuvpG49JcTUY+qw-tTdH_vFLgOfJDE3sW97+M04TR+hg@mail.gmail.com>
	<20120815160342.5b77bd3b.akpm@linux-foundation.org>
Date: Thu, 16 Aug 2012 20:40:07 +0800
Message-ID: <CAJd=RBBeoxCu-LQf1p3d26Aah1HvJV-q-ePT-qDc=nY5F+XR1g@mail.gmail.com>
Subject: Re: [patch v2] hugetlb: correct page offset index for sharing pmd
From: Hillf Danton <dhillf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 7:03 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:

> Don't be too concerned about the size of a change - it's the end result
> which matters.  If a larger patch results in a better end result, then
> do the larger patch.

Hi Andrew,

This work was triggered by the fact that huge_pmd_share mismatches
unmap_ref_private. But it does match hugetlb_vmtruncate_list.

Plus RADIX_INDEX and HEAP_INDEX are defined, and used when inserting
vma into prio tree.
===
/*
 * The following macros are used for implementing prio_tree for i_mmap
 */

#define RADIX_INDEX(vma)  ((vma)->vm_pgoff)
#define VMA_SIZE(vma)	  (((vma)->vm_end - (vma)->vm_start) >> PAGE_SHIFT)
/* avoid overflow */
#define HEAP_INDEX(vma)	  ((vma)->vm_pgoff + (VMA_SIZE(vma) - 1))
===

Thus it is incorrect to use huge pgoff in searching vma in prio tree, and
I have to withdraw this work.

Thanks,
		Hillf

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2BWVuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:50:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab2BWVuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:50:09 -0500
Date: Thu, 23 Feb 2012 13:50:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>, hughd@google.com,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: Re: [PATCH -mm 1/2] mm: fix quadratic behaviour in
 get_unmapped_area_topdown
Message-Id: <20120223135007.a4dceeb2.akpm@linux-foundation.org>
In-Reply-To: <20120223145636.616bef1c@cuia.bos.redhat.com>
References: <20120223145417.261225fd@cuia.bos.redhat.com>
	<20120223145636.616bef1c@cuia.bos.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012 14:56:36 -0500
Rik van Riel <riel@redhat.com> wrote:

> When we look for a VMA smaller than the cached_hole_size, we set the
> starting search address to mm->mmap_base, to try and find our hole.
> 
> However, even in the case where we fall through and found nothing at
> the mm->free_area_cache, we still reset the search address to mm->mmap_base.
> This bug results in quadratic behaviour, with observed mmap times of 0.4
> seconds for processes that have very fragmented memory.
> 
> If there is no hole small enough for us to fit the VMA, and we have
> no good spot for us right at mm->free_area_cache, we are much better
> off continuing the search down from mm->free_area_cache, instead of
> all the way from the top.

This has been at least partially addressed in recent patches from Xiao
Guangrong.  Please review his five-patch series starting with "[PATCH
1/5] hugetlbfs: fix hugetlb_get_unmapped_area".

I've already merged those patches and we need to work out what way to
go.


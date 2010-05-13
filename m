Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab0EMJSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 05:18:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34667 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab0EMJSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 05:18:08 -0400
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Mel Gorman <mel@csn.ul.ie>,
       aarcange@redhat.com, lwoodman@redhat.com, Lee.Schermerhorn@hp.com
Subject: Re: [PATCH 1/7] hugetlb, rmap: add reverse mapping for hugepage
From: Andi Kleen <andi@halobates.de>
References: <1273737326-21211-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1273737326-21211-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Date: Thu, 13 May 2010 11:18:04 +0200
In-Reply-To: <1273737326-21211-2-git-send-email-n-horiguchi@ah.jp.nec.com> (Naoya Horiguchi's message of "Thu\, 13 May 2010 16\:55\:20 +0900")
Message-ID: <87zl04tb1v.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

Adding a few more recent hugetlb hackers in cc. Folks, please consider
reviewing the hugetlb.c parts of the original patch kit in linux-mm.

> While hugepage is not currently swappable, rmapping can be useful
> for memory error handler.
> Using rmap, memory error handler can collect processes affected
> by hugepage errors and unmap them to contain error's effect.

Thanks.

I reviewed all the patches and they look good to me. I can merge
them through the hwpoison git tree.

But before merging it there I would like to have some review
and acks from mm hackers on the mm/hugetlb.c parts, which
do (relatively minor) changes outside memory-failure.c

I think you also had a patch for mce-test, can you send me that
one too?

BTW I wonder: did you verify that the 1GB page support works?
I would expect it does, but it would be good to double check.
One would need a Westmere server or AMD Family10h+ system to test that.

> Current status of hugepage rmap differs depending on mapping mode:
> - for shared hugepage:
>   we can collect processes using a hugepage through pagecache,
>   but can not unmap the hugepage because of the lack of mapcount.
> - for privately mapped hugepage:
>   we can neither collect processes nor unmap the hugepage.

I hope these points can be eventually addressed too, but this
is a good first step and closes an important hole in hwpoison
coverage.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.

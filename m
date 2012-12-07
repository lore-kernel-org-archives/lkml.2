Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab2LGGOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:14:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab2LGGOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:14:53 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: aneesh.kumar@linux.vnet.ibm.com
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi.kleen@intel.com>, Tony Luck <tony.luck@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/3] HWPOISON, hugetlbfs: fix warning on freeing hwpoisoned hugepage
Date: Fri,  7 Dec 2012 01:14:42 -0500
Message-Id: <1354860882-14567-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <87ehj2ctjq.fsf@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 11:06:41AM +0530, Aneesh Kumar K.V wrote:
...
> > From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > Date: Thu, 6 Dec 2012 20:54:30 -0500
> > Subject: [PATCH v2] HWPOISON, hugetlbfs: fix warning on freeing hwpoisoned
> >  hugepage
> >
> > This patch fixes the warning from __list_del_entry() which is triggered
> > when a process tries to do free_huge_page() for a hwpoisoned hugepage.
> 
> 
> Can you get a dump stack for that. I am confused because the page was
> already in freelist, and we deleted it from the list and set the
> refcount to 1. So how are we reaching free_huge_page() again ?

free_huge_page() can be called for hwpoisoned hugepage from unpoison_memory().
This function gets refcount once and clears PageHWPoison, and then puts
refcount twice to return the hugepage back to free pool.
The second put_page() finally reaches free_huge_page().

Thanks,
Naoya

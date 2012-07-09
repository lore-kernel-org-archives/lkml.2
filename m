Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab2GIKuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:50:44 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42494 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab2GIKun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:50:43 -0400
Date: Mon, 9 Jul 2012 11:50:40 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: split out
 is_hugetlb_entry_migration_or_hwpoison
Message-ID: <20120709105040.GT13141@csn.ul.ie>
References: <1341828761-11195-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1341828761-11195-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 06:12:41PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Code was duplicated in two functions, clean it up.
> 
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>

is_hugetlb_entry_migration() now returns true for hwpoisoned pages. In
this block

                if (unlikely(is_hugetlb_entry_migration(entry))) {
                        migration_entry_wait(mm, (pmd_t *)ptep, address);
                        return 0;

we now will call migration_entry_wait and return 0 to the fault handler
instead of VM_FAULT_HWPOISON_LARGE | VM_FAULT_SET_HINDEX(h - hstates).
By co-incidence this might work because migration of hugetlb happens for
poisoned pages but it would be just a co-incidence. Some other change in
the future such as better support for memory hotplug of regions backed
by hugetlbfs may break it again.

Superficially, this patch looks broken and the changelog contains
no motivation as to why this patch should be merged such as being a
pre-requisite for another fix or feature.  It just looks like churn for
the sake of churn. It might be just me but it feels like I'm seeing a lot
more of this style of patch recently on linux-mm and review bandwidth is
not infinite :(

Nak.

-- 
Mel Gorman
SUSE Labs

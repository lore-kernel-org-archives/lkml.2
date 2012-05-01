Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab2EANx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:53:59 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40322 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab2EANx6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:53:58 -0400
MIME-Version: 1.0
In-Reply-To: <201205011333.q41DXsK7026759@farm-0013.internal.tilera.com>
References: <201204291936.q3TJa4Mv008924@farm-0027.internal.tilera.com>
	<alpine.LSU.2.00.1204301308090.2829@eggly.anvils>
	<20120501131413.GA11435@suse.de>
	<201205011333.q41DXsK7026759@farm-0013.internal.tilera.com>
Date: Tue, 1 May 2012 21:53:58 +0800
Message-ID: <CAJd=RBCWcAU17tHofjcGsKPk6M4PxuvDBp9zgmhpJnZHu7hKpA@mail.gmail.com>
Subject: Re: [PATCH] hugetlb: avoid gratuitous BUG_ON in hugetlb_fault() -> hugetlb_cow()
From: Hillf Danton <dhillf@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 3:04 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> Commit 66aebce747eaf added code to avoid a race condition by
> elevating the page refcount in hugetlb_fault() while calling
> hugetlb_cow().  However, one code path in hugetlb_cow() includes
> an assertion that the page count is 1, whereas it may now also
> have the value 2 in this path.  Consensus is that this BUG_ON
> has served its purpose, so rather than extending it to cover both
> cases, we just remove it.
>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---

Acked-by: Hillf Danton <dhillf@gmail.com>

>  mm/hugetlb.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index cd65cb1..baaad5d 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2498,7 +2498,6 @@ retry_avoidcopy:
>                if (outside_reserve) {
>                        BUG_ON(huge_pte_none(pte));
>                        if (unmap_ref_private(mm, vma, old_page, address)) {
> -                               BUG_ON(page_count(old_page) != 1);
>                                BUG_ON(huge_pte_none(pte));
>                                spin_lock(&mm->page_table_lock);
>                                ptep = huge_pte_offset(mm, address & huge_page_mask(h));
> --
> 1.6.5.2
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab2CMNNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:13:04 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36814 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2CMNNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:13:01 -0400
MIME-Version: 1.0
In-Reply-To: <1331622432-24683-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1331622432-24683-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Date: Tue, 13 Mar 2012 21:13:00 +0800
Message-ID: <CAJd=RBA+D0MyjwuCNp3WtKRq-d3F_t9rKHLgmyLhznhZ9HjG4g@mail.gmail.com>
Subject: Re: [PATCH -V3 1/8] hugetlb: rename max_hstate to hugetlb_max_hstate
From: Hillf Danton <dhillf@gmail.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        aarcange@redhat.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 3:07 PM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>
> We will be using this from other subsystems like memcg
> in later patches.
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---

Acked-by: Hillf Danton <dhillf@gmail.com>

>  mm/hugetlb.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 5f34bd8..d623e71 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -34,7 +34,7 @@ const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
>  static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
>  unsigned long hugepages_treat_as_movable;
>
> -static int max_hstate;
> +static int hugetlb_max_hstate;
>  unsigned int default_hstate_idx;
>  struct hstate hstates[HUGE_MAX_HSTATE];
>
> @@ -46,7 +46,7 @@ static unsigned long __initdata default_hstate_max_huge_pages;
>  static unsigned long __initdata default_hstate_size;
>
>  #define for_each_hstate(h) \
> -       for ((h) = hstates; (h) < &hstates[max_hstate]; (h)++)
> +       for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
>
>  /*
>  * Protects updates to hugepage_freelists, nr_huge_pages, and free_huge_pages
> @@ -1808,9 +1808,9 @@ void __init hugetlb_add_hstate(unsigned order)
>                printk(KERN_WARNING "hugepagesz= specified twice, ignoring\n");
>                return;
>        }
> -       BUG_ON(max_hstate >= HUGE_MAX_HSTATE);
> +       BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
>        BUG_ON(order == 0);
> -       h = &hstates[max_hstate++];
> +       h = &hstates[hugetlb_max_hstate++];
>        h->order = order;
>        h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
>        h->nr_huge_pages = 0;
> @@ -1831,10 +1831,10 @@ static int __init hugetlb_nrpages_setup(char *s)
>        static unsigned long *last_mhp;
>
>        /*
> -        * !max_hstate means we haven't parsed a hugepagesz= parameter yet,
> +        * !hugetlb_max_hstate means we haven't parsed a hugepagesz= parameter yet,
>         * so this hugepages= parameter goes to the "default hstate".
>         */
> -       if (!max_hstate)
> +       if (!hugetlb_max_hstate)
>                mhp = &default_hstate_max_huge_pages;
>        else
>                mhp = &parsed_hstate->max_huge_pages;
> @@ -1853,7 +1853,7 @@ static int __init hugetlb_nrpages_setup(char *s)
>         * But we need to allocate >= MAX_ORDER hstates here early to still
>         * use the bootmem allocator.
>         */
> -       if (max_hstate && parsed_hstate->order >= MAX_ORDER)
> +       if (hugetlb_max_hstate && parsed_hstate->order >= MAX_ORDER)
>                hugetlb_hstate_alloc_pages(parsed_hstate);
>
>        last_mhp = mhp;
> --
> 1.7.9
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1FTQzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:55:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab1FTQy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:54:59 -0400
Date: Mon, 20 Jun 2011 18:54:25 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm: print information when THP is disabled
 automatically
Message-ID: <20110620165425.GF20843@redhat.com>
References: <1308587683-2555-1-git-send-email-amwang@redhat.com>
 <1308587683-2555-3-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308587683-2555-3-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 12:34:30AM +0800, Amerigo Wang wrote:
> Print information when THP is disabled automatically so that
> users can find this info in dmesg.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> ---
>  mm/huge_memory.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 7fb44cc..07679da 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -544,8 +544,11 @@ static int __init hugepage_init(void)
>  	 * where the extra memory used could hurt more than TLB overhead
>  	 * is likely to save.  The admin can still enable it through /sys.
>  	 */
> -	if (totalram_pages < (CONFIG_TRANSPARENT_HUGEPAGE_THRESHOLD << (20 - PAGE_SHIFT)))
> +	if (totalram_pages < (CONFIG_TRANSPARENT_HUGEPAGE_THRESHOLD
> +					<< (20 - PAGE_SHIFT))) {
> +		printk(KERN_INFO "hugepage: disabled auotmatically\n");

typo automatically. I'd suggest to change the prefix from "hugepage:"
to "THP:" to avoid the risk of possible confusion with hugetlbfs
support. Maybe you could print the minimal threshold too ("disabled
automatically with less than %dMB of RAM").

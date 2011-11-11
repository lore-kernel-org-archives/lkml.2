Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab1KKRXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:23:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736Ab1KKRXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:23:09 -0500
Date: Fri, 11 Nov 2011 18:23:01 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] hugetlb: release pages in the error path of hugetlb_cow()
Message-ID: <20111111172301.GB4479@redhat.com>
References: <CAJd=RBC5Q48r0sYeqF9bucaBJPv3LR4UTAannUZ8KXxoXY_Qcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBC5Q48r0sYeqF9bucaBJPv3LR4UTAannUZ8KXxoXY_Qcw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 09:01:20PM +0800, Hillf Danton wrote:
> If fail to prepare anon_vma, {new, old}_page should be released, or they will
> escape the track and/or control of memory management.
> 
> Thanks
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/mm/hugetlb.c	Fri Nov 11 20:36:32 2011
> +++ b/mm/hugetlb.c	Fri Nov 11 20:43:06 2011
> @@ -2422,6 +2422,8 @@ retry_avoidcopy:
>  	 * anon_vma prepared.
>  	 */
>  	if (unlikely(anon_vma_prepare(vma))) {
> +		page_cache_release(new_page);
> +		page_cache_release(old_page);
>  		/* Caller expects lock to be held */
>  		spin_lock(&mm->page_table_lock);
>  		return VM_FAULT_OOM;

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>

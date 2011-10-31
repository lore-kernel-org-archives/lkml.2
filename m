Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab1JaKIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 06:08:18 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:34058 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753432Ab1JaKIR convert rfc822-to-8bit
	(ORCPT <rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 31 Oct 2011 06:08:17 -0400
X-Greylist: delayed 1203 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Oct 2011 06:08:17 EDT
Message-Id: <4EAEDA630200001600008EF7@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 Beta 
Date: Mon, 31 Oct 2011 03:26:59 -0600
From: "Guan Jun He" <gjhe@suse.com>
To: <torvalds@linux-foundation.org>, "Guan Jun He" <GJHe@suse.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][mm/memory.c]: transparent hugepage check condition
 missed
References: <1320051775-13992-1-git-send-email-gjhe@suse.com>
In-Reply-To: <1320051775-13992-1-git-send-email-gjhe@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Excuse me! I got the one email sent 6 times!

best,
Guanjun

>>> On 10/31/2011 at 05:02 PM, in message
<1320051775-13992-1-git-send-email-gjhe@suse.com>, Guanjun He <gjhe@suse.com>
wrote: 
> For the transparent hugepage module still does not support
> tmpfs and cache,the check condition should always be checked 
> to make sure that it only affect the anonymous maps, the 
> original check condition missed this, this patch is to fix this.
> Otherwise,the hugepage may affect the file-backed maps,
> then the cache for the small-size pages will be unuseful,
> and till now there is still no implementation for hugepage's cache.
> 
> Signed-off-by: Guanjun He <gjhe@suse.com>
> ---
>  mm/memory.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index a56e3ba..79b85fe 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3475,7 +3475,8 @@ int handle_mm_fault(struct mm_struct *mm, struct 
> vm_area_struct *vma,
>  		if (pmd_trans_huge(orig_pmd)) {
>  			if (flags & FAULT_FLAG_WRITE &&
>  			    !pmd_write(orig_pmd) &&
> -			    !pmd_trans_splitting(orig_pmd))
> +			    !pmd_trans_splitting(orig_pmd) &&
> +			    !vma->vm_ops)
>  				return do_huge_pmd_wp_page(mm, vma, address,
>  							   pmd, orig_pmd);
>  			return 0;



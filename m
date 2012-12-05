Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2LEWOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 17:14:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab2LEWOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 17:14:46 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi.kleen@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] HWPOISON, hugetlbfs: fix RSS-counter warning
Date: Wed,  5 Dec 2012 17:14:33 -0500
Message-Id: <1354745673-31035-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1C963B15@ORSMSX108.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Wed, Dec 05, 2012 at 10:04:50PM +0000, Luck, Tony wrote:
> 	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
> -		if (PageAnon(page))
> +		if (PageHuge(page))
> +			;
> +		else if (PageAnon(page))
>  			dec_mm_counter(mm, MM_ANONPAGES);
>  		else
>  			dec_mm_counter(mm, MM_FILEPAGES);
> 
> This style minimizes the "diff" ... but wouldn't it be nicer to say:
> 
> 		if (!PageHuge(page)) {
> 			old code in here
> 		}
> 

I think this need more lines in diff because old code should be
indented without any logical change.

Thanks,
Naoya

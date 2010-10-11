Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab0JKUYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 16:24:10 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:50724 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab0JKUYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 16:24:09 -0400
Subject: Re: [PATCH] staging: tidspbridge: fix signess error
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: segooon@gmail.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1286827491.2762.69.camel@dan>
References: <1286827491.2762.69.camel@dan>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 16:24:03 -0400
Message-ID: <1286828643.2762.76.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems to me that in a lot of cases, signed types were used initially
with checks that the value was not below zero, but then unsigned types
were substituted due to problems later on (potentially security
related), and the checks were never removed.  Just because a check
doesn't make sense doesn't necessarily mean it's safe to revert an
unsigned type to a signed one - just be careful to make sure you're not
introducing any problems when you make these kinds of changes.  I have
no idea whether or not this is the case in this particular example.

> i was unsigned, so check for (i < 0) made no sense.  Made it signed.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  I cannot compile this driver, so it is not tested.
>  drivers/staging/tidspbridge/core/dsp-mmu.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> diff --git a/drivers/staging/tidspbridge/core/dsp-mmu.c b/drivers/staging/tidspbridge/core/dsp-mmu.c
> index 3c978f9..983c95a 100644
> --- a/drivers/staging/tidspbridge/core/dsp-mmu.c
> +++ b/drivers/staging/tidspbridge/core/dsp-mmu.c
> @@ -219,7 +219,8 @@ u32 user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
>  				struct page **usr_pgs)
>  {
>  	int res, w;
> -	unsigned pages, i;
> +	unsigned pages;
> +	int i;
>  	struct vm_area_struct *vma;
>  	struct mm_struct *mm = current->mm;
>  	struct sg_table *sgt;
> -- 
> 1.7.0.4



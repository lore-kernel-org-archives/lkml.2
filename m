Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab2BRQJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 11:09:40 -0500
Received: from queue01.mail.zen.net.uk ([212.23.3.234]:56211 "EHLO
	queue01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab2BRQJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 11:09:38 -0500
Message-ID: <1329580086.2448.12.camel@computer2.home>
Subject: Re: [PATCH 1/2] ARM: dma-mapping: its array of pointer
From: Tixy <tixy@yxit.co.uk>
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sumit Bhattacharya <sumitb@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 18 Feb 2012 15:48:06 +0000
In-Reply-To: <1329484170-26329-1-git-send-email-ajeet.yadav.77@gmail.com>
References: <1329484170-26329-1-git-send-email-ajeet.yadav.77@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Originating-Smarthost03-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 18:39 +0530, Ajeet Yadav wrote:
> To be consistant with declaration and usage of
        ^^^^^^^^^^
Spelling mistake, should be 'consistent'

> consistent_pte it need to be an array of (pte *)
                    ^^^^
Grammar mistake, should be 'needs'.

> 
> Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>

The title of this patch is a bit vague, perhaps something like:
"ARM: dma-mapping: Fix the type used for consistent_pte size
calculation"

The actual patch looks correct.

-- 
Tixy

> ---
>  arch/arm/mm/dma-mapping.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 1aa664a..04bfa76 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -170,7 +170,7 @@ static int __init consistent_init(void)
>  	unsigned long base = consistent_base;
>  	unsigned long num_ptes = (CONSISTENT_END - base) >> PMD_SHIFT;
>  
> -	consistent_pte = kmalloc(num_ptes * sizeof(pte_t), GFP_KERNEL);
> +	consistent_pte = kmalloc(num_ptes * sizeof(pte_t *), GFP_KERNEL);
>  	if (!consistent_pte) {
>  		pr_err("%s: no memory\n", __func__);
>  		return -ENOMEM;




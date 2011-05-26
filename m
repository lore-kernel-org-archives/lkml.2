Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab1EZEik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 00:38:40 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:57342 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1EZEik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 00:38:40 -0400
Message-ID: <4DDDD96E.3020604@snapgear.com>
Date: Thu, 26 May 2011 14:39:10 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Greg Ungerer <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <uclinux-dev@uclinux.org>
Subject: Re: [PATCH 3/4] m68knommu: Make empty_zero_page "void *", like on
 m68k
References: <1306314660-19288-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1306314660-19288-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 25/05/11 19:10, Geert Uytterhoeven wrote:
> This allows to get rid of the casts.
>
> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>

Looks good:

Acked-by: Greg Ungerer <gerg@uclinux.org>

Do you want me to add to the m68knommu git tree?
Or are these part of a series you intend pushing yourself?

Regards
Greg



> ---
>   arch/m68k/mm/init_no.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/m68k/mm/init_no.c b/arch/m68k/mm/init_no.c
> index 7cbd7bd..fdbe679 100644
> --- a/arch/m68k/mm/init_no.c
> +++ b/arch/m68k/mm/init_no.c
> @@ -42,7 +42,7 @@
>    * ZERO_PAGE is a special page that is used for zero-initialized
>    * data and COW.
>    */
> -unsigned long empty_zero_page;
> +void *empty_zero_page;
>
>   extern unsigned long memory_start;
>   extern unsigned long memory_end;
> @@ -62,8 +62,8 @@ void __init paging_init(void)
>   	unsigned long end_mem   = memory_end&  PAGE_MASK;
>   	unsigned long zones_size[MAX_NR_ZONES] = {0, };
>
> -	empty_zero_page = (unsigned long)alloc_bootmem_pages(PAGE_SIZE);
> -	memset((void *)empty_zero_page, 0, PAGE_SIZE);
> +	empty_zero_page = alloc_bootmem_pages(PAGE_SIZE);
> +	memset(empty_zero_page, 0, PAGE_SIZE);
>
>   	/*
>   	 * Set up SFC/DFC registers (user data space).


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com

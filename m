Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210Ab1EZErV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 00:47:21 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:46991 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1EZErU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 00:47:20 -0400
Message-ID: <4DDDD9FE.7040002@snapgear.com>
Date: Thu, 26 May 2011 14:41:34 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Greg Ungerer <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <uclinux-dev@uclinux.org>
Subject: Re: [PATCH 4/4] m68knommu: Fix printk() format in free_initrd_mem()
References: <1306314660-19288-1-git-send-email-geert@linux-m68k.org> <1306314660-19288-2-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1306314660-19288-2-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 25/05/11 19:11, Geert Uytterhoeven wrote:
> arch/m68k/mm/init_no.c:123: warning: format æ%dÆ expects type æintÆ, but argument 2 has type ælong unsigned intÆ
>
> And use pr_notice() while we're at it.
>
> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>

Regards
Greg


> ---
>   arch/m68k/mm/init_no.c |    5 +++--
>   1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/m68k/mm/init_no.c b/arch/m68k/mm/init_no.c
> index fdbe679..50cd12c 100644
> --- a/arch/m68k/mm/init_no.c
> +++ b/arch/m68k/mm/init_no.c
> @@ -120,7 +120,8 @@ void free_initrd_mem(unsigned long start, unsigned long end)
>   		totalram_pages++;
>   		pages++;
>   	}
> -	printk (KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages * (PAGE_SIZE / 1024));
> +	pr_notice("Freeing initrd memory: %luk freed\n",
> +		  pages * (PAGE_SIZE / 1024));
>   }
>   #endif
>
> @@ -141,7 +142,7 @@ void free_initmem(void)
>   		free_page(addr);
>   		totalram_pages++;
>   	}
> -	printk(KERN_NOTICE "Freeing unused kernel memory: %ldk freed (0x%x - 0x%x)\n",
> +	pr_notice("Freeing unused kernel memory: %luk freed (0x%x - 0x%x)\n",
>   			(addr - PAGE_ALIGN((long)&__init_begin))>>  10,
>   			(int)(PAGE_ALIGN((unsigned long)(&__init_begin))),
>   			(int)(addr - PAGE_SIZE));


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com

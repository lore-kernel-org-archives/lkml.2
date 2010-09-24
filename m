Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab0IXQJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:09:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38405 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab0IXQJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:09:44 -0400
Message-ID: <4C9CCD1B.506@mvista.com>
Date: Fri, 24 Sep 2010 20:08:59 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] MIPS: Add a platform hook for swiotlb setup.
References: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com> <1285281496-24696-9-git-send-email-ddaney@caviumnetworks.com>
In-Reply-To: <1285281496-24696-9-git-send-email-ddaney@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

David Daney wrote:

> This allows platforms that are using the swiotlb to initialize it.

> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> ---
>  arch/mips/include/asm/bootinfo.h |    5 +++++
>  arch/mips/kernel/setup.c         |    5 +++++
>  2 files changed, 10 insertions(+), 0 deletions(-)

> diff --git a/arch/mips/include/asm/bootinfo.h b/arch/mips/include/asm/bootinfo.h
> index 15a8ef0..b3cf989 100644
> --- a/arch/mips/include/asm/bootinfo.h
> +++ b/arch/mips/include/asm/bootinfo.h
> @@ -125,4 +125,9 @@ extern unsigned long fw_arg0, fw_arg1, fw_arg2, fw_arg3;
>   */
>  extern void plat_mem_setup(void);
>  
> +/*
> + * Optional platform hook to call swiotlb_setup().
> + */
> +extern void plat_swiotlb_setup(void);
> +
>  #endif /* _ASM_BOOTINFO_H */
> diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
> index 85aef3f..8b650da 100644
> --- a/arch/mips/kernel/setup.c
> +++ b/arch/mips/kernel/setup.c
> @@ -488,6 +488,11 @@ static void __init arch_mem_init(char **cmdline_p)
>  
>  	bootmem_init();
>  	sparse_init();
> +
> +#ifdef CONFIG_SWIOTLB
> +	plat_swiotlb_setup();
> +#endif

    We should avoid #ifdef's in function bodies. Why not defile an empty 
'inline' in the header above if CONFIG_SWIOTLB is not defined?

WBR, Sergei


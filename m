Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab0D3Q4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:56:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:39292 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758074Ab0D3Qzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:55:45 -0400
Message-ID: <4BDA6FDE.20606@monstr.eu>
Date: Fri, 30 Apr 2010 07:51:26 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: "Steven J. Magnani" <steve@digidescorp.com>
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: export assembly functions used by modules
References: <1272391235-32036-1-git-send-email-steve@digidescorp.com>
In-Reply-To: <1272391235-32036-1-git-send-email-steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven J. Magnani wrote:
> Modules that use copy_{to,from}_user(), memcpy(), and memset() fail to build
> in certain circumstances.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/arch/microblaze/kernel/microblaze_ksyms.c b/arch/microblaze/kernel/microblaze_ksyms.c
> --- a/arch/microblaze/kernel/microblaze_ksyms.c	2010-04-27 10:14:33.000000000 -0500
> +++ b/arch/microblaze/kernel/microblaze_ksyms.c	2010-04-27 12:52:08.000000000 -0500
> @@ -52,3 +52,13 @@ EXPORT_SYMBOL_GPL(_ebss);
>  extern void _mcount(void);
>  EXPORT_SYMBOL(_mcount);
>  #endif
> +
> +/*
> + * Assembly functions that may be used (directly or indirectly) by modules
> + */
> +EXPORT_SYMBOL(__copy_tofrom_user);
> +
> +#ifdef CONFIG_OPT_LIB_ASM
> +EXPORT_SYMBOL(memcpy);
> +EXPORT_SYMBOL(memmove);
> +#endif
> 

applied.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian

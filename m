Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab1CWNYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:24:19 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:61108 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab1CWNYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:24:16 -0400
Message-ID: <4D89F362.9010708@snapgear.com>
Date: Wed, 23 Mar 2011 23:19:30 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Greg Ungerer <gerg@uclinux.org>, Linux/m68k <linux-m68k@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k,m68knommu: Wire up syncfs
References: <alpine.DEB.2.00.1103231334450.21922@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.00.1103231334450.21922@ayla.of.borg>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/03/11 22:35, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>


> To be folded with the previous one.
>
>   arch/m68k/include/asm/unistd.h       |    3 ++-
>   arch/m68k/kernel/entry.S             |    1 +
>   arch/m68knommu/kernel/syscalltable.S |    1 +
>   3 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
> index f69f7ce..29e1790 100644
> --- a/arch/m68k/include/asm/unistd.h
> +++ b/arch/m68k/include/asm/unistd.h
> @@ -346,10 +346,11 @@
>   #define __NR_name_to_handle_at	340
>   #define __NR_open_by_handle_at	341
>   #define __NR_clock_adjtime	342
> +#define __NR_syncfs		343
>
>   #ifdef __KERNEL__
>
> -#define NR_syscalls		343
> +#define NR_syscalls		344
>
>   #define __ARCH_WANT_IPC_PARSE_VERSION
>   #define __ARCH_WANT_OLD_READDIR
> diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
> index 8f9524a..1359ee6 100644
> --- a/arch/m68k/kernel/entry.S
> +++ b/arch/m68k/kernel/entry.S
> @@ -753,4 +753,5 @@ sys_call_table:
>   	.long sys_name_to_handle_at	/* 340 */
>   	.long sys_open_by_handle_at
>   	.long sys_clock_adjtime
> +	.long sys_syncfs
>
> diff --git a/arch/m68knommu/kernel/syscalltable.S b/arch/m68knommu/kernel/syscalltable.S
> index 605bbbe..9b8393d 100644
> --- a/arch/m68knommu/kernel/syscalltable.S
> +++ b/arch/m68knommu/kernel/syscalltable.S
> @@ -361,6 +361,7 @@ ENTRY(sys_call_table)
>   	.long sys_name_to_handle_at	/* 340 */
>   	.long sys_open_by_handle_at
>   	.long sys_clock_adjtime
> +	.long sys_syncfs
>
>   	.rept NR_syscalls-(.-sys_call_table)/4
>   		.long sys_ni_syscall


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com

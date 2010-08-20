Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab0HTDnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 23:43:05 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:63671 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751543Ab0HTDnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 23:43:03 -0400
Message-ID: <4C6DF8BC.8060803@snapgear.com>
Date: Fri, 20 Aug 2010 13:38:36 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: uClinux development list <uclinux-dev@uclinux.org>
CC: Linux/m68k <linux-m68k@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [uClinux-dev] [PATCH] m68k, m68knommu: Wire up fanotify_init,
 fanotify_mark, and prlimit64
References: <alpine.DEB.2.00.1008191804480.16652@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.00.1008191804480.16652@ayla.of.borg>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Aug 2010 03:42:08.0210 (UTC) FILETIME=[AA15B320:01CB4019]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>


> ---
>  arch/m68k/include/asm/unistd.h       |    5 ++++-
>  arch/m68k/kernel/entry.S             |    3 +++
>  arch/m68knommu/kernel/syscalltable.S |    3 +++
>  3 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
> index 60b15d0..b43b36b 100644
> --- a/arch/m68k/include/asm/unistd.h
> +++ b/arch/m68k/include/asm/unistd.h
> @@ -340,10 +340,13 @@
>  #define __NR_set_thread_area	334
>  #define __NR_atomic_cmpxchg_32	335
>  #define __NR_atomic_barrier	336
> +#define __NR_fanotify_init	337
> +#define __NR_fanotify_mark	338
> +#define __NR_prlimit64		339
>  
>  #ifdef __KERNEL__
>  
> -#define NR_syscalls		337
> +#define NR_syscalls		340
>  
>  #define __ARCH_WANT_IPC_PARSE_VERSION
>  #define __ARCH_WANT_OLD_READDIR
> diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
> index 2391bdf..6360c43 100644
> --- a/arch/m68k/kernel/entry.S
> +++ b/arch/m68k/kernel/entry.S
> @@ -765,4 +765,7 @@ sys_call_table:
>  	.long sys_set_thread_area
>  	.long sys_atomic_cmpxchg_32	/* 335 */
>  	.long sys_atomic_barrier
> +	.long sys_fanotify_init
> +	.long sys_fanotify_mark
> +	.long sys_prlimit64
>  
> diff --git a/arch/m68knommu/kernel/syscalltable.S b/arch/m68knommu/kernel/syscalltable.S
> index b30b3eb..79b1ed1 100644
> --- a/arch/m68knommu/kernel/syscalltable.S
> +++ b/arch/m68knommu/kernel/syscalltable.S
> @@ -355,6 +355,9 @@ ENTRY(sys_call_table)
>  	.long sys_set_thread_area
>  	.long sys_atomic_cmpxchg_32	/* 335 */
>  	.long sys_atomic_barrier
> +	.long sys_fanotify_init
> +	.long sys_fanotify_mark
> +	.long sys_prlimit64
>  
>  	.rept NR_syscalls-(.-sys_call_table)/4
>  		.long sys_ni_syscall


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com

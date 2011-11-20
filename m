Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1KTXeL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 18:34:11 -0500
Received: from dalsmrelay2.nai.com ([205.227.136.216]:35339 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab1KTXeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 18:34:09 -0500
Message-ID: <4EC98EE6.8070101@snapgear.com>
Date: Mon, 21 Nov 2011 09:36:06 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: <linux-m68k@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: Wire up process_vm_{read,write}v
References: <1321823420-14893-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1321823420-14893-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 21/11/11 07:10, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>

Looks good.

Acked-by: Greg Ungerer <gerg@uclinux.org>

Regards
Greg


>   arch/m68k/include/asm/unistd.h  |    4 +++-
>   arch/m68k/kernel/syscalltable.S |    2 ++
>   2 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
> index d97234b..ea0b502 100644
> --- a/arch/m68k/include/asm/unistd.h
> +++ b/arch/m68k/include/asm/unistd.h
> @@ -350,10 +350,12 @@
>   #define __NR_clock_adjtime	342
>   #define __NR_syncfs		343
>   #define __NR_setns		344
> +#define __NR_process_vm_readv	345
> +#define __NR_process_vm_writev	346
>
>   #ifdef __KERNEL__
>
> -#define NR_syscalls		345
> +#define NR_syscalls		347
>
>   #define __ARCH_WANT_IPC_PARSE_VERSION
>   #define __ARCH_WANT_OLD_READDIR
> diff --git a/arch/m68k/kernel/syscalltable.S b/arch/m68k/kernel/syscalltable.S
> index c468f2e..ce827b3 100644
> --- a/arch/m68k/kernel/syscalltable.S
> +++ b/arch/m68k/kernel/syscalltable.S
> @@ -365,4 +365,6 @@ ENTRY(sys_call_table)
>   	.long sys_clock_adjtime
>   	.long sys_syncfs
>   	.long sys_setns
> +	.long sys_process_vm_readv	/* 345 */
> +	.long sys_process_vm_writev
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com

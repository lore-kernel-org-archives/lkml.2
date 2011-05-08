Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab1EHWqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:46:23 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:18595 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932692Ab1EHWqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:46:20 -0400
Message-ID: <4DC71D1E.5030407@snapgear.com>
Date: Mon, 9 May 2011 08:45:50 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux/m68k <linux-m68k@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: Really wire up sys_pselect6 and sys_ppoll
References: <alpine.DEB.2.00.1105062107290.23969@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.00.1105062107290.23969@ayla.of.borg>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/11 05:08, Geert Uytterhoeven wrote:
> We reserved the numbers a long time ago, but never wired them up in the
> syscall table as they need TIF_RESTORE_SIGMASK, which we only got last year
> in commit cb6831d5d3099e772a510eb3e1ed0760ccffb45e ("m68k: Switch to saner
> sigsuspend()")
>
> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>


> ---
> I'll move this before "m68k: unistd - Comment out definitions for unimplemented
> syscalls", and will update the latter.
>
>   arch/m68k/kernel/syscalltable.S |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/m68k/kernel/syscalltable.S b/arch/m68k/kernel/syscalltable.S
> index cb3bc1b..6f7b091 100644
> --- a/arch/m68k/kernel/syscalltable.S
> +++ b/arch/m68k/kernel/syscalltable.S
> @@ -321,8 +321,8 @@ ENTRY(sys_call_table)
>   	.long sys_readlinkat
>   	.long sys_fchmodat
>   	.long sys_faccessat		/* 300 */
> -	.long sys_ni_syscall		/* Reserved for pselect6 */
> -	.long sys_ni_syscall		/* Reserved for ppoll */
> +	.long sys_pselect6
> +	.long sys_ppoll
>   	.long sys_unshare
>   	.long sys_set_robust_list
>   	.long sys_get_robust_list	/* 305 */


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com

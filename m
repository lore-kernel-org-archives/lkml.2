Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab2JHFrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 01:47:05 -0400
Received: from dnvwsmailout1.mcafee.com ([161.69.31.173]:16777 "EHLO
	DNVWSMAILOUT1.mcafee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab2JHFrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 01:47:01 -0400
Message-ID: <507269A3.9020009@snapgear.com>
Date: Mon, 8 Oct 2012 15:50:27 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Greg Ungerer <gerg@uclinux.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Bryan Wu <bryan.wu@canonical.com>
Subject: Re: [PATCH 02/16] ARM: binfmt_flat: unused variable 'persistent'
References: <1349448930-23976-1-git-send-email-arnd@arndb.de> <1349448930-23976-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1349448930-23976-3-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/12 00:55, Arnd Bergmann wrote:
> The flat_get_addr_from_rp() macro does not use the 'persistent' argument
> on ARM, causing a harmless compiler warning. A cast to void removes
> that warning.
>
> Without this patch, building at91x40_defconfig results in:
>
> fs/binfmt_flat.c: In function 'load_flat_file':
> fs/binfmt_flat.c:746:17: warning: unused variable 'persistent' [-Wunused-variable]
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Ungerer <gerg@uclinux.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Bryan Wu <bryan.wu@canonical.com>

Acked-by: Greg Ungerer <gerg@uclinux.org>

I can pick this one up to, and push to the arm-soc tree.

Regards
Greg


> ---
>   arch/arm/include/asm/flat.h |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/include/asm/flat.h b/arch/arm/include/asm/flat.h
> index 59426a4..e847d23 100644
> --- a/arch/arm/include/asm/flat.h
> +++ b/arch/arm/include/asm/flat.h
> @@ -8,7 +8,7 @@
>   #define	flat_argvp_envp_on_stack()		1
>   #define	flat_old_ram_flag(flags)		(flags)
>   #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
> -#define	flat_get_addr_from_rp(rp, relval, flags, persistent) get_unaligned(rp)
> +#define	flat_get_addr_from_rp(rp, relval, flags, persistent) ((void)persistent,get_unaligned(rp))
>   #define	flat_put_addr_at_rp(rp, val, relval)	put_unaligned(val,rp)
>   #define	flat_get_relocate_addr(rel)		(rel)
>   #define	flat_set_persistent(relval, p)		0
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com

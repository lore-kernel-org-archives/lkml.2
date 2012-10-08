Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab2JHFoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 01:44:12 -0400
Received: from dnvwsmailout1.mcafee.com ([161.69.31.173]:16668 "EHLO
	DNVWSMAILOUT1.mcafee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2JHFoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 01:44:10 -0400
Message-ID: <50726966.5010503@snapgear.com>
Date: Mon, 8 Oct 2012 15:49:26 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Greg Ungerer <gerg@uclinux.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 01/16] ARM: warnings in arch/arm/include/asm/uaccess.h
References: <1349448930-23976-1-git-send-email-arnd@arndb.de> <1349448930-23976-2-git-send-email-arnd@arndb.de>
In-Reply-To: <1349448930-23976-2-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/12 00:55, Arnd Bergmann wrote:
> On NOMMU ARM, the __addr_ok() and __range_ok() macros do not evaluate
> their arguments, which may lead to harmless build warnings in some
> code where the variables are not used otherwise. Adding a cast to void
> gets rid of the warning and does not make any semantic changes.
>
> Without this patch, building at91x40_defconfig results in:
>
> fs/read_write.c: In function 'rw_copy_check_uvector':
> fs/read_write.c:684:9: warning: unused variable 'buf' [-Wunused-variable]
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Ungerer <gerg@uclinux.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>

Acked-by: Greg Ungerer <gerg@uclinux.org>

I can pick it up and push to the arm-soc tree.

Regards
Greg


> ---
>   arch/arm/include/asm/uaccess.h |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
> index 77bd79f..7e1f760 100644
> --- a/arch/arm/include/asm/uaccess.h
> +++ b/arch/arm/include/asm/uaccess.h
> @@ -200,8 +200,8 @@ extern int __put_user_8(void *, unsigned long long);
>   #define USER_DS			KERNEL_DS
>
>   #define segment_eq(a,b)		(1)
> -#define __addr_ok(addr)		(1)
> -#define __range_ok(addr,size)	(0)
> +#define __addr_ok(addr)		((void)(addr),1)
> +#define __range_ok(addr,size)	((void)(addr),0)
>   #define get_fs()		(KERNEL_DS)
>
>   static inline void set_fs(mm_segment_t fs)
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com

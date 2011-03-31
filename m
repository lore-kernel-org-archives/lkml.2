Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847Ab1CaBkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 21:40:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58025 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823Ab1CaBkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 21:40:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ej1msl5fr66C08uUC7c7s+4FFI/xmsd1zSz1DKuboo3sV5pLUVeht2OC/XvpbYPelN
         idncv/XuaT8/MNTM9qgdb4R60LZsO4JodQmL3sQbzVHglc1R+67WBn8Bm3xCuDK9nUJX
         5guG7cZxqAneQOi1gUKRxu+4GijpcVgadEdf8=
MIME-Version: 1.0
In-Reply-To: <4D93CDD7.8000708@sgi.com>
References: <20110225180633.857892225@gulag1.americas.sgi.com>
	<20110225180634.017570095@gulag1.americas.sgi.com>
	<20110227120949.GF16453@elte.hu>
	<20110227121518.GA19165@elte.hu>
	<4D6AFBB0.70401@kernel.org>
	<4D6BF63D.2020404@sgi.com>
	<AANLkTi=Sn6DKAjGHQjtWGiLGh8vpuS-vmXK=TMDrbjdv@mail.gmail.com>
	<4D6BFF46.3050001@sgi.com>
	<AANLkTi=Xf5RaF559QsRNijmG0YP7amkG569NZFhpt4QY@mail.gmail.com>
	<4D93CDD7.8000708@sgi.com>
Date: Wed, 30 Mar 2011 18:40:06 -0700
X-Google-Sender-Auth: YLVzgQOygxmst1L1rk8KiuRe6XM
Message-ID: <AANLkTi=eRgp0wqpwq-W=E7ptrnQuM837+J+enEA2wey-@mail.gmail.com>
Subject: Re: [PATCH 1/2] memblock: add error return when CONFIG_HAVE_MEMBLOCK
 is not set
From: Yinghai Lu <yinghai@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Rientjes <rientjes@google.com>,
        Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 5:41 PM, Mike Travis <travis@sgi.com> wrote:
> Subject: memblock: add error return when CONFIG_HAVE_MEMBLOCK is not set
> Author: Yinghai Lu <yinghai@kernel.org>
>
>        Add an error return if CONFIG_HAVE_MEMBLOCK is not set instead
>        of having to add #ifdef CONFIG_HAVE_MEMBLOCK around blocks of
>        code calling that function.
>
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
> include/linux/memblock.h |    9 ++++++++-
> 1 file changed, 8 insertions(+), 1 deletion(-)
>
> --- linux.orig/include/linux/memblock.h
> +++ linux/include/linux/memblock.h
> @@ -2,6 +2,8 @@
> #define _LINUX_MEMBLOCK_H
> #ifdef __KERNEL__
>
> +#define MEMBLOCK_ERROR 0
> +
> #ifdef CONFIG_HAVE_MEMBLOCK
> /*
>  * Logical memory blocks.
> @@ -20,7 +22,6 @@
> #include <asm/memblock.h>
>
> #define INIT_MEMBLOCK_REGIONS   128
> -#define MEMBLOCK_ERROR         0
>
> struct memblock_region {
>        phys_addr_t base;
> @@ -160,6 +161,12 @@ static inline unsigned long memblock_reg
> #define __initdata_memblock
> #endif
>
> +#else
> +static inline phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t
> align)
> +{
> +       return MEMBLOCK_ERROR;
> +}
> +
> #endif /* CONFIG_HAVE_MEMBLOCK */
>
> #endif /* __KERNEL__ */
>

setup_log_buf will pass function pointer, So this one is not needed, right?

Thanks

Yinghai

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab2KPQFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:05:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33810 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab2KPQFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:05:51 -0500
Message-ID: <50A6644D.80205@zytor.com>
Date: Fri, 16 Nov 2012 08:05:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 8/9] x86: ramdisk info print with high bits.
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org> <1353055989-31939-9-git-send-email-yinghai@kernel.org>
In-Reply-To: <1353055989-31939-9-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 12:53 AM, Yinghai Lu wrote:
> ramdisk could be loaded high now for 64bit.
> 
> So need to print more digits for them.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/x86/kernel/setup.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index c2eb535..0e13c6e 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -341,7 +341,7 @@ static void __init relocate_initrd(void)
>  	memblock_reserve(ramdisk_here, area_size);
>  	initrd_start = ramdisk_here + PAGE_OFFSET;
>  	initrd_end   = initrd_start + ramdisk_size;
> -	printk(KERN_INFO "Allocated new RAMDISK: [mem %#010llx-%#010llx]\n",
> +	printk(KERN_INFO "Allocated new RAMDISK: [mem %#018llx-%#018llx]\n",
>  			 ramdisk_here, ramdisk_here + ramdisk_size - 1);

NAK, this is expected to match the resource print format (%pR), which
prints 10 digits by default and then expands.  Furthermore, printing
*18* digits is downright silly since we still don't have 72-bit addressing.

	-hpa


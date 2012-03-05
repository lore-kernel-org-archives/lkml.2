Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab2CEHtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 02:49:49 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:41896 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2CEHtr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 02:49:47 -0500
MIME-Version: 1.0
Message-ID: <d493264b-7da0-41bd-b0bc-219b1a180f10@default>
Date: Sun, 4 Mar 2012 23:49:31 -0800 (PST)
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <mingo@redhat.com>, <konrad.wilk@oracle.com>, <yinghai@kernel.org>,
        <tglx@linutronix.de>, <joe.jin@oracle.com>, <hpa@zytor.com>
Subject: =?UTF-8?B?562U5aSNOiBbUEFUQ0hdIEluaXRpYWxpemUgbWF4X3Bmbl9tYXBwZWQgYQ==?=
 =?UTF-8?B?cyBpbml0aWFsIGlkZW50IG1hcHBpbmcgc2l6ZSBmb3IgeDg2XzY0?=
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F54700F.0087,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- zhenzhong.duan@oracle.com 写道：

> It's better to initialize max_pfn_mapped as initial ident
> mapping size but not initial kernel map size for x86_64.
> This is also in accordance with i386 code.
> 
> It lead to page tables allocation to as high as 1G for
> init_memory_mapping,
> this will allow larger crashkernel reservation.
> 
> Tested on HP DL980G7, it can reserve more than 521MiB space for kdump
> kernel now.
> http://bugzilla.oracle.com/bugzilla/show_bug.cgi?id=13405
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Tested-by: Dawei Pang <dawei.pang@hp.com>
> ---
>  arch/x86/kernel/head64.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> index 3a3b779..3beb94f 100644
> --- a/arch/x86/kernel/head64.c
> +++ b/arch/x86/kernel/head64.c
> @@ -77,7 +77,7 @@ void __init x86_64_start_kernel(char *
> real_mode_data)
>  	/* Make NULL pointers segfault */
>  	zap_identity_mappings();
>  
> -	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
> +	max_pfn_mapped = PUD_PAGE_SIZE >> PAGE_SHIFT;
>  
>  	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
>  #ifdef CONFIG_EARLY_PRINTK
> -- 
> 1.7.3

Hmm, any comment is welcome
thanks

zduan

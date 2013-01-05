Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab3AED2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 22:28:20 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:40010 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab3AED2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 22:28:19 -0500
Date: Sat, 5 Jan 2013 11:28:09 +0800
From: Guo Chao <yan@linux.vnet.ibm.com>
To: matt@console-pimps.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] efi: Make 'efi_enabled' a function to
Message-ID: <20130105032809.GA15166@yanx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010503-0260-0000-0000-0000025DA8A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

query EFI facilities
Reply-To: <1357219085-4312-2-git-send-email-matt@console-pimps.org> 
In-Reply-To: <1357219085-4312-2-git-send-email-matt@console-pimps.org> 

> diff --git a/init/main.c b/init/main.c
> index e33e09d..e71d924 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -604,7 +604,7 @@ asmlinkage void __init start_kernel(void)
>  	pidmap_init();
>  	anon_vma_init();
>  #ifdef CONFIG_X86
> -	if (efi_enabled)
> +	if (efi_enabled(EFI_RUNTIME_SERVICES))
>  		efi_enter_virtual_mode();
>  #endif
>  	thread_info_cache_init();
> @@ -632,7 +632,7 @@ asmlinkage void __init start_kernel(void)
>  	acpi_early_init(); /* before LAPIC and SMP init */
>  	sfi_init_late();
> 
> -	if (efi_enabled) {
> +	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
>  		efi_late_init();
>  		efi_free_boot_services();
>  	}

I just wonder why we compile efi code away explicitly by CONFIG_X86 in
one place and implicitly by if (0) in another place, in the same
function.

Thanks,
Guo Chao


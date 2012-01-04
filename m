Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab2ADF0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 00:26:06 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:56788 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751061Ab2ADF0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 00:26:04 -0500
Message-ID: <1325654761.28596.3.camel@joe2Laptop>
Subject: Re: [PATCH 2/5] x86: efi: convert printk to pr_*()
From: Joe Perches <joe@perches.com>
To: Olof Johansson <olof@lixom.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Date: Tue, 03 Jan 2012 21:26:01 -0800
In-Reply-To: <1325610682-24811-3-git-send-email-olof@lixom.net>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
	 <1325610682-24811-3-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-03 at 09:11 -0800, Olof Johansson wrote:
> Alright, I guess I'll go through and convert them, even though
> there's no net gain to speak of.

Perhaps it'd be better to add
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
before any #include and remove PFX from the
formats.

> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
[]
> @@ -254,7 +254,7 @@ int efi_set_rtc_mmss(unsigned long nowtime)
>  
>  	status = efi.get_time(&eft, &cap);
>  	if (status != EFI_SUCCESS) {
> -		printk(KERN_ERR "Oops: efitime: can't read time!\n");
> +		pr_err("Oops: efitime: can't read time!\n");

		pr_err("Oops: can't read time!\n")
> @@ -367,7 +367,7 @@ static void __init print_efi_memmap(void)
>  	     p < memmap.map_end;
>  	     p += memmap.desc_size, i++) {
>  		md = p;
> -		printk(KERN_INFO PFX "mem%02u: type=%u, attr=0x%llx, "
> +		pr_info(PFX "mem%02u: type=%u, attr=0x%llx, "
>  			"range=[0x%016llx-0x%016llx) (%lluMB)\n",

		pr_info("mem%02u: type..."

etc...


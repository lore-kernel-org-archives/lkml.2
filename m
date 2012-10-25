Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934736Ab2JYH6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:58:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55194 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964967Ab2JYH55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:57:57 -0400
Date: Thu, 25 Oct 2012 09:57:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Bin Gao <bin.gao@linux.intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <len.brown@intel.com>
Subject: Re: arch/x86/Kconfig: not select X86_MPPARSE when SFI is present
Message-ID: <20121025075752.GE3712@gmail.com>
References: <20121025060400.GB38419@bingao-desk1.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025060400.GB38419@bingao-desk1.fm.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bin Gao <bin.gao@linux.intel.com> wrote:

> MPS tables are not needed for systems that have proper ACPI support.
> This is also true for systems that have SFI in place.
> 
> So this patch is to exclude X86_MPPARSE when either ACPI or SFI is present.
> 
> Signed-off-by: Bin Gao <bin.gao@intel.com>
> ---
>  arch/x86/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 46c3bff..b1494bd 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -310,7 +310,7 @@ config X86_X2APIC
>  	  If you don't know what to do here, say N.
>  
>  config X86_MPPARSE
> -	bool "Enable MPS table" if ACPI
> +	bool "Enable MPS table" if ACPI || SFI
>  	default y
>  	depends on X86_LOCAL_APIC
>  	---help---

The changelog does not seem to match the patch. Did you want to 
say:

  " So this patch allows the configuration (turning off) of
    CONFIG_X86_MPPARSE when either ACPI or SFI is present. "

?

	Ingo

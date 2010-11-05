Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab0KER1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:27:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18612 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab0KER1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:27:43 -0400
Message-ID: <4CD43E53.4010909@kernel.org>
Date: Fri, 05 Nov 2010 10:26:43 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101013 SUSE/3.0.9 Thunderbird/3.0.9
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] x86-64: adjust section annotations in AMD Fam10 MMCONF
  enabling code
References: <4CD2DE1E0200007800020990@vpn.id2.novell.com>
In-Reply-To: <4CD2DE1E0200007800020990@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2010 08:23 AM, Jan Beulich wrote:
> check_enable_amd_mmconf_dmi() gets called only for the BSP, hence
> everything hanging off of it can be __init*.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/mmconf-fam10h_64.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> --- linux-2.6.37-rc1/arch/x86/kernel/mmconf-fam10h_64.c
> +++ 2.6.37-rc1-x86_64-mmconf-fam10h-sections/arch/x86/kernel/mmconf-fam10h_64.c
> @@ -217,13 +217,13 @@ void __cpuinit fam10h_check_enable_mmcfg
>  	wrmsrl(address, val);
>  }
>  
> -static int __devinit set_check_enable_amd_mmconf(const struct dmi_system_id *d)
> +static int __init set_check_enable_amd_mmconf(const struct dmi_system_id *d)
>  {
>          pci_probe |= PCI_CHECK_ENABLE_AMD_MMCONF;
>          return 0;
>  }
>  
> -static const struct dmi_system_id __cpuinitconst mmconf_dmi_table[] = {
> +static const struct dmi_system_id __initconst mmconf_dmi_table[] = {
>          {
>                  .callback = set_check_enable_amd_mmconf,
>                  .ident = "Sun Microsystems Machine",
> @@ -234,7 +234,8 @@ static const struct dmi_system_id __cpui
>  	{}
>  };
>  
> -void __cpuinit check_enable_amd_mmconf_dmi(void)
> +/* Called from a __cpuinit function, but only on the BSP. */
> +void __ref check_enable_amd_mmconf_dmi(void)
>  {
>  	dmi_check_system(mmconf_dmi_table);
>  }
> 
> 
> 

Acked-by: Yinghai Lu <yinghai@kernel.org>

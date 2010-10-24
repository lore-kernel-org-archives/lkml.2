Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab0JXJ5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 05:57:12 -0400
Received: from www.tglx.de ([62.245.132.106]:49508 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab0JXJ5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 05:57:11 -0400
Date: Sun, 24 Oct 2010 11:56:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/15] x86, sfi: Use smp_register_lapic_address()
In-Reply-To: <1287882149-29275-8-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1010241155051.2466@localhost6.localdomain6>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org> <1287882149-29275-8-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Oct 2010, Yinghai Lu wrote:

> kill mp_sfi_register_lapic_address, they are the same

Except for the difference.
 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/kernel/sfi.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kernel/sfi.c b/arch/x86/kernel/sfi.c
> index dd4c281..4dc8065 100644
> --- a/arch/x86/kernel/sfi.c
> +++ b/arch/x86/kernel/sfi.c
> @@ -34,17 +34,6 @@
>  #ifdef CONFIG_X86_LOCAL_APIC
>  static unsigned long sfi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
>  
> -static void __init mp_sfi_register_lapic_address(unsigned long address)
> -{
> -	mp_lapic_addr = address;
> -
> -	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);
> -	if (boot_cpu_physical_apicid == -1U)
> -		boot_cpu_physical_apicid = read_apic_id();
> -
> -	pr_info("Boot CPU = %d\n", boot_cpu_physical_apicid);

That pr_info is not really important, but it makes the function
different in the first place.

> -}
> -
>  /* All CPUs enumerated by SFI must be present and enabled */
>  static void __cpuinit mp_sfi_register_lapic(u8 id)
>  {
> @@ -110,7 +99,7 @@ static int __init sfi_parse_ioapic(struct sfi_table_header *table)
>  int __init sfi_platform_init(void)
>  {
>  #ifdef CONFIG_X86_LOCAL_APIC
> -	mp_sfi_register_lapic_address(sfi_lapic_addr);
> +	smp_register_lapic_address(sfi_lapic_addr);
>  	sfi_table_parse(SFI_SIG_CPUS, NULL, NULL, sfi_parse_cpus);
>  #endif
>  #ifdef CONFIG_X86_IO_APIC
> -- 
> 1.7.1
> 

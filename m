Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab1CCUyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:54:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48255 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab1CCUyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:54:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mvva8jlq4ONgT+fvNTswyeSPNI+7FKEx2B/N7fMMagea/c3nvoAaVbL6/mGNXZjqxn
         Of7ldqN17kZNQRRQSvpW6PBY7qpZYXPZnVvaickyLfdDvvET83U4bUtpoQ4bqOm0j8H1
         iHm+PIA/FHzgCVQYJqnsxUfgGi4YvTgTdAl5o=
Message-ID: <4D6FFFF0.9030402@gmail.com>
Date: Thu, 03 Mar 2011 23:54:08 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Henrik Kretzschmar <henne@nachtwindheim.de>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 4/7] x86: remove enable_NMI_through_LVT0() entirely
References: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de> <1299182701-8591-4-git-send-email-henne@nachtwindheim.de>
In-Reply-To: <1299182701-8591-4-git-send-email-henne@nachtwindheim.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 11:04 PM, Henrik Kretzschmar wrote:
> This function is not used anywhere in the tree,
> since commit 072b198a4ad48bd722ec6d203d65422a4698eae7
> so it can be removed.
> 
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
> ---
>  arch/x86/include/asm/apic.h |    1 -
>  arch/x86/kernel/apic/apic.c |   17 -----------------
>  2 files changed, 0 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index 6d74dd37..f17d7c5 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -238,7 +238,6 @@ void register_lapic_address(unsigned long address);
>  extern void setup_boot_APIC_clock(void);
>  extern void setup_secondary_APIC_clock(void);
>  extern int APIC_init_uniprocessor(void);
> -extern void enable_NMI_through_LVT0(void);
>  extern int apic_force_enable(unsigned long addr) __init;
>  
>  /*
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 5177aaa..a0e9c1f 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -292,23 +292,6 @@ u64 native_apic_icr_read(void)
>  	return icr1 | ((u64)icr2 << 32);
>  }
>  
> -/**
> - * enable_NMI_through_LVT0 - enable NMI through local vector table 0
> - */
> -void __cpuinit enable_NMI_through_LVT0(void)
> -{
> -	unsigned int v;
> -
> -	/* unmask and set to NMI */
> -	v = APIC_DM_NMI;
> -
> -	/* Level triggered for 82489DX (32bit mode) */
> -	if (!lapic_is_integrated())
> -		v |= APIC_LVT_LEVEL_TRIGGER;
> -
> -	apic_write(APIC_LVT0, v);
> -}
> -
>  #ifdef CONFIG_X86_32
>  /**
>   * get_physical_broadcast - Get number of physical broadcast IDs

Seems to be a leftover since nmi-watchdog via io-apic. Good for me.
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

CC'ing Don.
-- 
    Cyrill

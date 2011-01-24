Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab1AXT61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:58:27 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41092 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab1AXT6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:58:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pZx+5bLp/KuCUYke78GtSGrxYa72et0PoLDi4hcJGR9fq9nPa86Er8brcCFiLeDNoS
         7H31dwuIHPrE7Di1dfozDPrnr2aJRG0JCxOLelH+ksRFVjNaydJHw1Mi6mKTsxirVhsb
         CfLep1Nn7mJ3sfuQbDkhlbaMWoJcHXb1KkPVc=
MIME-Version: 1.0
In-Reply-To: <1295789862-25482-5-git-send-email-tj@kernel.org>
References: <1295789862-25482-1-git-send-email-tj@kernel.org>
	<1295789862-25482-5-git-send-email-tj@kernel.org>
Date: Mon, 24 Jan 2011 11:58:24 -0800
X-Google-Sender-Auth: f-DX7FF8sktrf13-7W0V_cIUnpA
Message-ID: <AANLkTimi0Q6mqD68H5WOf=grwuVXxMPKHgM7z6RcbhE1@mail.gmail.com>
Subject: Re: [PATCH 04/16] x86: Replace cpu_2_logical_apicid[] with early
 percpu variable
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, eric.dumazet@gmail.com,
        brgerst@gmail.com, gorcunov@gmail.com, penberg@kernel.org,
        shaohui.zheng@intel.com, rientjes@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 5:37 AM, Tejun Heo <tj@kernel.org> wrote:
> Unlike x86_64, on x86_32, the mapping from cpu to logical apicid may
> vary depending on apic in use.  cpu_2_logical_apicid[] array is used
> for this mapping.  Replace it with early percpu variable
> x86_cpu_to_logical_apicid to make it better aligned with other
> mappings.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  arch/x86/include/asm/apic.h      |    4 ----
>  arch/x86/include/asm/smp.h       |    3 +++
>  arch/x86/kernel/apic/apic.c      |   11 +++++++++++
>  arch/x86/kernel/apic/es7000_32.c |    2 +-
>  arch/x86/kernel/apic/numaq_32.c  |    2 +-
>  arch/x86/kernel/apic/summit_32.c |    4 ++--
>  arch/x86/kernel/setup_percpu.c   |    7 +++++++
>  arch/x86/kernel/smpboot.c        |    7 ++-----
>  8 files changed, 27 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index 5e3969c..eb139ec 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -595,8 +595,4 @@ extern int default_check_phys_apicid_present(int phys_apicid);
>
>  #endif /* CONFIG_X86_LOCAL_APIC */
>
> -#ifdef CONFIG_X86_32
> -extern u8 cpu_2_logical_apicid[NR_CPUS];
> -#endif
> -
>  #endif /* _ASM_X86_APIC_H */
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index 4c2f63c..dc7c46a 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -38,6 +38,9 @@ static inline struct cpumask *cpu_core_mask(int cpu)
>
>  DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
>  DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
> +#if defined(CONFIG_SMP) && defined(CONFIG_X86_32)
> +DECLARE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid);
> +#endif

why changing it from u8 to int?

Thanks

Yinghai

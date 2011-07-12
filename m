Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab1GLR3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 13:29:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:9794 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab1GLR3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 13:29:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,521,1304319600"; 
   d="scan'208";a="26277087"
Subject: Re: [PATCH] x86, x2apic: Preserve high 32-bits of IA32_APIC_BASE
 MSR
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <20110712055831.2498.78521.sendpatchset@nchumbalkar.americas.cpqcorp.net>
References: <20110712055831.2498.78521.sendpatchset@nchumbalkar.americas.cpqcorp.net>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 12 Jul 2011 10:29:36 -0700
Message-Id: <1310491776.12417.31.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-11 at 22:59 -0700, Naga Chumbalkar wrote:
> If there's no special reason to zero-out the "high" 32-bits of the IA32_APIC_BASE
> MSR, let's preserve it.
> 
> The x2APIC Specification doesn't explicitly state any such requirement. (Sec 2.2 
> in: http://www.intel.com/Assets/PDF/manual/318148.pdf).
> 
> Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index b9338b8..f7b0c7a 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1429,7 +1429,7 @@ void enable_x2apic(void)
>  	rdmsr(MSR_IA32_APICBASE, msr, msr2);
>  	if (!(msr & X2APIC_ENABLE)) {
>  		printk_once(KERN_INFO "Enabling x2apic\n");
> -		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, 0);
> +		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, msr2);
>  	}
>  }
>  #endif /* CONFIG_X86_X2APIC */

yeah, I don't think it was intentional.

Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab1J0H2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:28:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59085 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab1J0H2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:28:32 -0400
Date: Thu, 27 Oct 2011 09:26:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/3] Add Numachip APIC support
Message-ID: <20111027072652.GC15923@elte.hu>
References: <1319609230-18897-1-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319609230-18897-1-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel J Blueman <daniel@numascale-asia.com> wrote:

> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 9f548cb..f4b93de 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -66,6 +66,7 @@
>  #include <asm/apic.h>
>  #include <asm/io_apic.h>
>  #include <asm/setup.h>
> +#include <asm/numachip/numachip.h>
>  #include <asm/uv/uv.h>
>  #include <linux/mc146818rtc.h>
>  
> @@ -513,7 +514,7 @@ wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
>  	return (send_status | accept_status);
>  }
>  
> -static int __cpuinit
> +int __cpuinit
>  wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
>  {
>  	unsigned long send_status, accept_status = 0;
> @@ -1094,6 +1095,9 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
>  	print_cpu_info(&cpu_data(0));
>  	x86_init.timers.setup_percpu_clockev();
>  
> +	if (is_numachip_system())
> +		numachip_system_init();
> +
>  	if (is_uv_system())
>  		uv_system_init();

This is pretty ugly in its present form - please don't repeat the 
is_uv_system() mistakes but check how the MRST platform uses the 
x86_init methods to install its callbacks in setup code.

If you need a callback a new place then please extend x86_init 
accordingly.

Thanks,

	Ingo

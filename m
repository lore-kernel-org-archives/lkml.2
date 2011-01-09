Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab1AIJjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 04:39:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58418 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab1AIJjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 04:39:39 -0500
Date: Sun, 9 Jan 2011 10:39:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] x86, apic: Do not increment disabled_cpus from
 generic_processor_info.
Message-ID: <20110109093926.GB542@elte.hu>
References: <AANLkTimb7wj0oP_ctr7Ergf4VmVFTMHU3QCCaLcPE5Q9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimb7wj0oP_ctr7Ergf4VmVFTMHU3QCCaLcPE5Q9@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

>  disabled_cpus has been incremented from the call path of
> generic_processor_info (i.e from  acpi_register_lapic and
> MP_processor_info) when a perticular cpu is not enabled. So, we can
> remove the redundant increment of disabled_cpus from
> generic_processor_info.
> 
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index ce65d44..2499664 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1943,7 +1943,6 @@ void __cpuinit generic_processor_info(int
> apicid, int version)
>  			"ACPI: NR_CPUS/possible_cpus limit of %i reached."
>  			"  Processor %d/0x%x ignored.\n", max, thiscpu, apicid);
> 
> -		disabled_cpus++;
>  		return;

Hm, what effects does this have in practice? smpboot.c uses disabled_cpus as a value 
to calculate limits - why has this bug not caused some misbehavior somewhere? (or if 
it has caused misbehavior, what is that?)
 
Thanks,

	Ingo

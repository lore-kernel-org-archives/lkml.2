Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab1IZQPC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 12:15:02 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:50293 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1IZQPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 12:15:00 -0400
Date: Mon, 26 Sep 2011 12:13:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: JBeulich@suse.com, tj@kernel.org, tglx@linutronix.de, hpa@zytor.com
Cc: Stratos Psomadakis <psomas@gentoo.org>, mingo@elte.hu, stable@kernel.org,
        tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [PATCH] i386/bigsmp: eliminate false warnings regarding logical
 APIC ID mismatches
Message-ID: <20110926161353.GA3900@phenom.oracle.com>
References: <4E4D27B40200007800051D40@nat28.tlf.novell.com>
 <4E5B677F.4030302@gentoo.org>
 <4E649ED00200007800054988@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E649ED00200007800054988@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090209.4E80A4D4.012E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> --- 3.1-rc2/arch/x86/kernel/apic/probe_32.c
> >> +++ 3.1-rc2-i386-bigsmp-early-lapicid-override/arch/x86/kernel/apic/probe_32.c
> >> @@ -203,7 +203,18 @@ void __init default_setup_apic_routing(v
> >>  	if (!cmdline_apic && apic == &apic_default) {
> >>  		struct apic *bigsmp = generic_bigsmp_probe();
> >>  		if (bigsmp) {
> >> +			unsigned int cpu;
> >> +
> >>  			apic = bigsmp;
> >> +			for_each_possible_cpu(cpu) {
> >> +				if (early_per_cpu(x86_cpu_to_logical_apicid,
> >> +						  cpu) == BAD_APICID)
> >> +					continue;
> >> +				early_per_cpu(x86_cpu_to_logical_apicid,
> >> +					      cpu) =
> >> +					bigsmp->x86_32_early_logical_apicid
> >> +						(cpu);
> >> +			}
> >>  			printk(KERN_INFO "Overriding APIC driver with %s\n",
> >>  			       apic->name);
> >>  		}
> > Will this patch be included in 3.1 (so that it gets merged in 3.0-stable
> > kernels sooner too) or will it go for 3.2?
> 
> That can only be answered by the maintainers (on Cc), not me - afaict
> it didn't even get applied to -tip yet.

ping?

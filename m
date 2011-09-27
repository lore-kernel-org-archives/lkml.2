Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab1I0I5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 04:57:53 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:50032 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1I0I5w convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:6:1>);
	Tue, 27 Sep 2011 04:57:52 -0400
Message-Id: <4E81AC2B0200007800057F62@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 27 Sep 2011 09:57:47 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <mingo@elte.hu>, "Stratos Psomadakis" <psomas@gentoo.org>,
        <stable@kernel.org>, <tj@kernel.org>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] i386/bigsmp: eliminate false warnings regarding
	 logical APIC ID mismatches
References: <4E4D27B40200007800051D40@nat28.tlf.novell.com>
 <4E5B677F.4030302@gentoo.org>
 <4E649ED00200007800054988@nat28.tlf.novell.com>
 <20110926161353.GA3900@phenom.oracle.com>
In-Reply-To: <20110926161353.GA3900@phenom.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 26.09.11 at 18:13, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> >> --- 3.1-rc2/arch/x86/kernel/apic/probe_32.c
>> >> +++ 3.1-rc2-i386-bigsmp-early-lapicid-override/arch/x86/kernel/apic/probe_32.c
>> >> @@ -203,7 +203,18 @@ void __init default_setup_apic_routing(v
>> >>  	if (!cmdline_apic && apic == &apic_default) {
>> >>  		struct apic *bigsmp = generic_bigsmp_probe();
>> >>  		if (bigsmp) {
>> >> +			unsigned int cpu;
>> >> +
>> >>  			apic = bigsmp;
>> >> +			for_each_possible_cpu(cpu) {
>> >> +				if (early_per_cpu(x86_cpu_to_logical_apicid,
>> >> +						  cpu) == BAD_APICID)
>> >> +					continue;
>> >> +				early_per_cpu(x86_cpu_to_logical_apicid,
>> >> +					      cpu) =
>> >> +					bigsmp->x86_32_early_logical_apicid
>> >> +						(cpu);
>> >> +			}
>> >>  			printk(KERN_INFO "Overriding APIC driver with %s\n",
>> >>  			       apic->name);
>> >>  		}
>> > Will this patch be included in 3.1 (so that it gets merged in 3.0-stable
>> > kernels sooner too) or will it go for 3.2?
>> 
>> That can only be answered by the maintainers (on Cc), not me - afaict
>> it didn't even get applied to -tip yet.
> 
> ping?

I haven't seen any tipbot for it (despite having re-sent it about two
weeks ago), so I have to assume it still didn't go in. I also didn't see
anything else (e.g. reasons why this shouldn't get applied), just
complete silence (I would almost say as "usual", no matter how hard
I try to meet Ingo's expectations on patch descriptions).

So I can only again defer answering your question to the maintainers,
who are all on Cc.

Jan


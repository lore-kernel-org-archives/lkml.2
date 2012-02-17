Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab2BQL4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 06:56:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43380 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab2BQL4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 06:56:41 -0500
Date: Fri, 17 Feb 2012 12:56:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Move per cpu cpu_llc_shared_map to a field in
 struct cpuinfo_x86
Message-ID: <20120217115627.GA25601@elte.hu>
References: <20120212111914.GC21493@elte.hu>
 <1329178356-16645-1-git-send-email-kjwinchester@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329178356-16645-1-git-send-email-kjwinchester@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Winchester <kjwinchester@gmail.com> wrote:

> Commit 141168c36cde ("x86: Simplify code by removing a !SMP #ifdefs from
> 'struct cpuinfo_x86'") caused the compilation error:
> 
> mce_amd.c:(.cpuinit.text+0x4723): undefined reference to 'cpu_llc_shared_map'
> 
> by removing an #ifdef CONFIG_SMP around a block containing a reference
> to cpu_llc_shared_map.  Rather than replace the #ifdef, move
> cpu_llc_shared_map to be a new cpumask_t field llc_shared_map in
> struct cpuinfo_x86 and adjust all references to cpu_llc_shared_map.
> 
> The size effects on various kernels are as follows:
> 
>    text	   data	    bss	    dec	    hex	filename
> 5281572	 513296	1044480	6839348	 685c34	vmlinux.up
> 5281572	 513296	1044480	6839348	 685c34	vmlinux.up.patched
> 5548860	 516792	1110016	7175668	 6d7df4	vmlinux.smp.2
> 5548837	 516792	1110016	7175645	 6d7ddd	vmlinux.smp.2.patched
> 5595965	 706840	1310720	7613525	 742c55	vmlinux.smp.max
> 5595876	 707880	1310720	7614476	 74300c	vmlinux.smp.max.patched
> 
> It can be seen that this change has no effect on UP, a minor effect for
> SMP with Max 2 CPUs, and a more substantial but still not overly large
> effect for MAXSMP.
> 
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> ---
> 
> I'm still wondering if I should I give the same treatment to:
> 
> cpu_sibling_map
> cpu_core_map
> cpu_llc_id
> cpu_number
> 
> or is that going too far?
> 
>  arch/x86/include/asm/processor.h      |    1 +
>  arch/x86/include/asm/smp.h            |    6 ------
>  arch/x86/kernel/cpu/intel_cacheinfo.c |    4 ++--
>  arch/x86/kernel/cpu/mcheck/mce_amd.c  |    7 ++++---
>  arch/x86/kernel/smpboot.c             |   15 ++++++---------
>  arch/x86/xen/smp.c                    |    1 -
>  6 files changed, 13 insertions(+), 21 deletions(-)

Yeah, I'd definitely give them the same treatment.

Would you like to update your series? I'd suggest you keep patch 
#1 in place, as it's already probably reasonably well tested.

Thanks,

	Ingo

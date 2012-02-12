Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab2BLLXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 06:23:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46402 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab2BLLXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 06:23:06 -0500
Date: Sun, 12 Feb 2012 12:23:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Move per cpu cpu_llc_shared_map to a field in
 struct cpuinfo_x86
Message-ID: <20120212112306.GA14593@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Kevin Winchester <kjwinchester@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Nick Bowler <nbowler@elliptictech.com>,
	linux-kernel@vger.kernel.org
References: <20120211140737.GA26637@elte.hu>
 <1329006252-1684-1-git-send-email-kjwinchester@gmail.com>
 <CAELBVzD8eZuxO0KLvZp8VuucoPxBNVsojO1NhC-pvr78Mg1v+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAELBVzD8eZuxO0KLvZp8VuucoPxBNVsojO1NhC-pvr78Mg1v+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 11, 2012 at 10:18:53PM -0400, Kevin Winchester wrote:
> > @@ -225,7 +225,6 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
> >        for_each_possible_cpu(i) {
> >                zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
> >                zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
> > -               zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
> >        }
> >        set_cpu_sibling_map(0);
> >
> 
> I just realized that I took out a couple of allocations here for
> cpu_llc_shared_map, without replacing them.  Am I leaving
> cpuinfo_x86.llc_shared_map unallocated then, and just writing to
> whatever address that field happened to get?

AFAICT, yes, you need to alloc the cpumask too, i.e. something like

	zalloc_cpumask_var(cpu_info(i).llc_shared_map, GFP_KERNEL);

assuming this happens before the cpumask gets initted in
set_cpu_sibling_map() et al. Just give the whole init path a hard
staring, and try to figure out the proper init sequence.

HTH.

P.S.: I'm currently travelling but will give your patch a run when I get
back, thanks.

-- 
Regards/Gruss,
Boris.

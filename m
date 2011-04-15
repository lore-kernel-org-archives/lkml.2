Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab1DOG0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 02:26:06 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:58961 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1DOG0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 02:26:04 -0400
Date: Fri, 15 Apr 2011 02:25:53 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86 intel power: Initialize MSR_IA32_ENERGY_PERF_BIAS
In-reply-to: <20110414090854.GB9248@elte.hu>
Message-id: <alpine.LFD.2.02.1104150202310.29365@x980>
References: <alpine.LFD.2.02.1103301819250.31342@x980>
 <20110414090854.GB9248@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > From: Len Brown <len.brown@intel.com>
> > 
> > Since 2.6.35 (23016bf0d25), Linux prints the existence of "epb" in /proc/cpuinfo,
> > Since 2.6.38 (d5532ee7b40), the x86_energy_perf_policy(8) utility is available
> > in-tree to update MSR_IA32_ENERGY_PERF_BIAS.
> > 
> > However, the typical BIOS fails to initialize the MSR,
> > and the typical Linux distro neglects to invoke x86_energy_perf_policy(8).
> > 
> > The result is that some modern hardware is running in hardware default,
> > which is "performance" mode, rather than the intended design default
> > of "normal" mode.
> > 
> > Initialize the MSR to the "normal" setting during kernel boot.
> > 
> > Of course, x86_energy_perf_policy(8) is available to change
> > the default after boot, should the user have a policy preference.
> > 
> > cc: stable@kernel.org
> > Signed-off-by: Len Brown <len.brown@intel.com>
> > ---
> >  arch/x86/include/asm/msr-index.h |    3 +++
> >  arch/x86/kernel/cpu/intel.c      |   14 ++++++++++++++
> >  2 files changed, 17 insertions(+), 0 deletions(-)
> > 
...
> 
> Dunno, this patch appears to silently modify the system to be slower than it 
> was before under Linux.
> 
> Won't people report this as a regression if this change reduces performance for 
> them?
> 
> They wont be able to see your comments in the code and in the changelog either, 
> when this happens to them. They might look into /proc/cpuinfo and see 'epb' 
> there but it wont tell them anything. They wont know about a utility available 
> in tools/power/x86/ either.

This patch makes no change to the epb feature indicator
/proc/cpuinfo.

> So this patch has 'future trouble' written all over it i'm afraid.

EPB is limited to SNB and later.
So the installed base as yet is small.
(it also exists on WSM-EP, but doesn't do so much there)
EPB will have a more significant effect on future hardware.

Linux currently trails competing operating systems in energy
efficiency on SNB due to this setting, and Linux will trail
competing operating systems even more on future hardware
if this default is not fixed.

Will it be possible to measure a performance difference between
"performance" and "normal"?  Yes, it will be possible.
Will 99.9% of users notice?  Nope.  More likely they'll notice
the the power savings that are disabled in "performance" mode.

I should have called it "benchmark" mode instead of "performance" mode...

thanks,
Len Brown, Intel Open Source Technology Center


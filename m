Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863Ab1CaISt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 04:18:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43821 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097Ab1CaISq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 04:18:46 -0400
Date: Thu, 31 Mar 2011 10:18:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/9] x86 idle: remove NOP cpuinfo_x86.hlt_works_ok flag
Message-ID: <20110331081800.GH5938@elte.hu>
References: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1301550524.git.len.brown@intel.com>
 <b048802b0285a5ff28e74a4309d833116174904a.1301550524.git.len.brown@intel.com>
 <20110331061247.GA24786@elte.hu>
 <alpine.LFD.2.02.1103310252160.8569@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1103310252160.8569@x980>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Len Brown <lenb@kernel.org> wrote:

> > > hlt_works_ok was X86_32 only, initialized to 1, and never cleared.
> > > 
> > > On 32-bit kernels, this deletes a line from /proc/cpuinfo: "hlt_bug : no"
> > 
> > I think you missed the valid usecase where an old CPU with broken halt is 
> > booted with the no-hlt boot parameter and does not want to crash in the HLT 
> > instruction.
> > 
> > That "no-hlt" boot parameter does:
> > 
> >   arch/x86/kernel/cpu/bugs.c:     boot_cpu_data.hlt_works_ok = 0;
> > 
> > We can restrict compatibility, but *please* lets do it *explicitly*, not under 
> > some 'remove unused code' pretense ...
> > 
> > Could you please list all CPU models that are affected?
> 
> "no-hlt" existed only for 32-bit, and there were exactly zero
> automatic invocations of it.

Do we know whether a distro adds this to the boot line? Do we know about users 
relying on it.

> "idle=poll" does the same thing -- sans change a line
> in /proc/cpuinfo.

It also has an effect on halt/poweroff, right?

> Do we really need both?

Probably not, as i said i do not disagree - i just think it should be more 
explicit. Make it a: "users of CPU models X beware" commit title, not 'remove 
inactive code' ...

So please list the affected hardware and list the affected boot parameter 
explicitly, in a well-titled commit that phases out this (very likely unused) 
compatibility hack and *document* the idle=poll workaround for ancient 
hardware.

There's still i386DX CPUs being manufactured these days - a 20+ years old CPU 
design is surprisingly resilient to spurious patent claims, for obvious 
reasons.

Really, there's no need to do things by stealth. There's few things worse than 
doing the right thing for the wrong reason - it becomes a bad habit of subtly 
broken thinking quickly.

Thanks,

	Ingo

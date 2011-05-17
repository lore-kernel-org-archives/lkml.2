Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab1EQLhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 07:37:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39955 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272Ab1EQLg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 07:36:59 -0400
Date: Tue, 17 May 2011 13:36:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
Message-ID: <20110517113634.GC13475@elte.hu>
References: <20110516160943.GC25898@one.firstfloor.org>
 <alpine.LFD.2.02.1105161817120.3078@ionos>
 <20110516164939.GD25898@one.firstfloor.org>
 <BANLkTintkmnkN3kW06oa+TjT7W0Q1yQQGA@mail.gmail.com>
 <m2fwoeo0pf.fsf@firstfloor.org>
 <alpine.LFD.2.02.1105162345110.3078@ionos>
 <BANLkTinVnr1ZM2wOxuH-rHZGh+_SBWT-+g@mail.gmail.com>
 <alpine.LFD.2.02.1105170022430.3078@ionos>
 <20110517080029.GB22093@elte.hu>
 <BANLkTimpEfb3P9FWgrCDwSSVr6RA8nXb5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimpEfb3P9FWgrCDwSSVr6RA8nXb5w@mail.gmail.com>
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


* Andrew Lutomirski <luto@mit.edu> wrote:

> > Well, how does that differ from having the real syscall instruction there? 
> > How are we going to filter real (old-)glibc calls from exploits?
> 
> Because there are only four vsyscalls: vgettimeofday, vtime, vgetcpu, and 
> venosys.  None of them have side-effects, so they only allow an attacker to 
> write something to user memory somewhere.  The implementation of 
> vgettimeofday needs a syscall instruction internally for its fallback, which 
> means that an attack could jump there instead of to the start of the vsyscall 
> implementation.

So for this to work securely the emulation code would also have to filter the 
syscall numbers, to make sure that only these benign syscalls are used.

It should perhaps also warn if it notices something weird going on.

> > If it can be filtered in a meaningful way then we should just do that and 
> > perhaps offer a (default enabled) .config COMPAT_VDSO_EMU=y switch to turn 
> > the emulation off.
> >
> > That way we keep the ABI and also have a way out for users who *really* 
> > need this to work in a performant way.
> 
> Yeah, that probably makes more sense.  It'll make for an uglier diffstat, 
> though -- there's a lot of ugly duplicate code around to make vgettimeofday 
> and vgetcpu work.

Lets try the pure emulation thing first, ok? Complications is not really what 
we need in this area ...

Thanks,

	Ingo

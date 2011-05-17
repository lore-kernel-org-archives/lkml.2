Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1EQIAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:00:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39477 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab1EQIAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:00:51 -0400
Date: Tue, 17 May 2011 10:00:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Lutomirski <luto@mit.edu>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
Message-ID: <20110517080029.GB22093@elte.hu>
References: <cover.1305560561.git.luto@mit.edu>
 <20110516160943.GC25898@one.firstfloor.org>
 <alpine.LFD.2.02.1105161817120.3078@ionos>
 <20110516164939.GD25898@one.firstfloor.org>
 <BANLkTintkmnkN3kW06oa+TjT7W0Q1yQQGA@mail.gmail.com>
 <m2fwoeo0pf.fsf@firstfloor.org>
 <alpine.LFD.2.02.1105162345110.3078@ionos>
 <BANLkTinVnr1ZM2wOxuH-rHZGh+_SBWT-+g@mail.gmail.com>
 <alpine.LFD.2.02.1105170022430.3078@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105170022430.3078@ionos>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> > see if I can persuade Uli to take accept a glibc patch to stop calling it 
> > in future static glibc versions.
> 
> How wide spread is this in reality on 64bit systems ?
> 
> IOW, what's the damage if we take a trap and emulate it in the most painful 
> way we can come up with ?

Well, how does that differ from having the real syscall instruction there? How 
are we going to filter real (old-)glibc calls from exploits?

If it can be filtered in a meaningful way then we should just do that and 
perhaps offer a (default enabled) .config COMPAT_VDSO_EMU=y switch to turn the 
emulation off.

That way we keep the ABI and also have a way out for users who *really* need 
this to work in a performant way.

Thanks,

	Ingo

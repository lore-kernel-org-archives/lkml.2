Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2GJJsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:48:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49515 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab2GJJsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:48:51 -0400
Date: Tue, 10 Jul 2012 11:48:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
        eranian@google.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
Message-ID: <20120710094845.GB14821@gmail.com>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org>
 <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
 <1341598329.7709.57.camel@twins>
 <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com>
 <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com>
 <1341832997.3462.41.camel@twins>
 <CA+55aFyF-GT-BAjLCvwZPFCCKkkYz0ZznSSOYw4RVYizZhLE0g@mail.gmail.com>
 <1341910954.3462.102.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341910954.3462.102.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2012-07-09 at 10:55 -0700, Linus Torvalds wrote:
> > However, it is worth pointing out that sp/bp have exactly the same
> > segment base issue. So if you do stack tracing into user mode, you
> > should really do the same thing for those. And quite frankly, at that
> > point vm86 mode and the stack segment matters in other ways than just
> > the base pointer: a 16-bit stack segment acts fundamentally
> > differently from a 32-bit one. So at that point it may well make much
> > more sense to take the approach Ingo suggests, and simply not follow
> > stack frames at all. 
> 
> Right, so I amended the patch to ignore vm86 stacks and added 
> {cs,ss}_base magic to ia32 stacks.
> 
> Ingo, do you want me to do a version where I simply bail on 
> everything if regs->{cs,ss} != {__USER_CS, __USER32_CS} || 
> regs->flags & VM ?

Only if it's really simple to do - out of morbid curiosity, to 
compare the two diffstats and such.

Thanks,

	Ingo

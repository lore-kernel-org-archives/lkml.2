Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab2GJICl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 04:02:41 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50816 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab2GJICg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 04:02:36 -0400
Date: Tue, 10 Jul 2012 10:02:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
        eranian@google.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
Message-ID: <20120710080230.GA10919@gmail.com>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org>
 <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
 <1341598329.7709.57.camel@twins>
 <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com>
 <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com>
 <1341832997.3462.41.camel@twins>
 <20120709184145.GA7666@gmail.com>
 <1341906848.3462.92.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341906848.3462.92.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > > +static unsigned long code_segment_base(struct pt_regs *regs)
> > > +{
> > > +#ifdef CONFIG_32BIT
> > > +     if (user_mode(regs) && regs->cs != __USER_CS)
> > > +             return get_segment_base(regs->cs);
> > > +#else
> > > +     if (test_thread_flag(TIF_IA32)) {
> > > +             if (user_mode(regs) && regs->cs != __USER32_CS)
> > > +                     return get_segment_base(regs->cs);
> > > +     }
> > > +#endif
> > > +     return 0;
> > > +}
> > 
> > Will this do the right thing for x32 mode? 
> 
> hpa? It looks like x32 has TIF_X32, but from the kernel's POV 
> its really just another 64bit process, so as long as we don't 
> trigger the TIF_IA32 case we'll just return 0.

Maybe add that as a comment or so, to stop future wondering. 
Maybe list all the states an x86 process can be in, and describe 
what we intend to do for each. That will make it easier to match 
up intent with actual code and will make it easier to keep it 
correct in the future as well.

> set_personality_ia32() looks like TIF_IA32 and TIF_X32 are 
> mutually exclusive, so I think we do the right thing.

Ok.

Thanks,

	Ingo

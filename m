Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab2GJJzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:55:43 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61369 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab2GJJzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:55:42 -0400
Date: Tue, 10 Jul 2012 11:55:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
        eranian@google.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
Message-ID: <20120710095535.GC14821@gmail.com>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org>
 <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
 <1341598329.7709.57.camel@twins>
 <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com>
 <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com>
 <1341832997.3462.41.camel@twins>
 <CA+55aFyF-GT-BAjLCvwZPFCCKkkYz0ZznSSOYw4RVYizZhLE0g@mail.gmail.com>
 <1341910954.3462.102.camel@twins>
 <1341913846.3462.105.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341913846.3462.105.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2012-07-10 at 11:02 +0200, Peter Zijlstra wrote:
> > Ingo, do you want me to do a version where I simply bail on everything
> > if regs->{cs,ss} != {__USER_CS, __USER32_CS} || regs->flags & VM ?
> 
> Here's a variant that does that.. 

>  arch/x86/include/asm/perf_event.h         |   11 +++++--
>  arch/x86/kernel/cpu/perf_event.c          |   46 +++++++++++++++++++++++++-----
>  arch/x86/kernel/cpu/perf_event.h          |   20 +++++++++++++
>  arch/x86/kernel/cpu/perf_event_amd_ibs.c  |    4 +-
>  arch/x86/kernel/cpu/perf_event_intel_ds.c |    7 ++--
>  5 files changed, 74 insertions(+), 14 deletions(-)

this is the full thing:

>  arch/x86/include/asm/perf_event.h         |   11 ++-
>  arch/x86/kernel/cpu/perf_event.c          |   89 ++++++++++++++++++++++++++----
>  arch/x86/kernel/cpu/perf_event.h          |   20 ++++++
>  arch/x86/kernel/cpu/perf_event_amd_ibs.c  |    4 +
>  arch/x86/kernel/cpu/perf_event_intel_ds.c |    7 +-
>  5 files changed, 114 insertions(+), 17 deletions(-)

so that's 40 LOC difference.

Hm, I expected there to be more of a difference, so let me 
change my mind again in view of the evidence: now I tend to
lean Linus's way, we might as well apply those extra 40 lines
now that you've written them :-)

Even if it is not enough to do proper segmented profiling, 
should anyone be interested in such a profiling mode they'll 
have a much easier job making it work, the rest looks mostly a 
user space side job. Your larger patch looks safe enough at the 
boundaries.

Thanks,

	Ingo

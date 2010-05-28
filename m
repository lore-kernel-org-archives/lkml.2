Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0E1HBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:01:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53249 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab0E1HBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:01:00 -0400
Date: Fri, 28 May 2010 09:00:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL, v2] perf changes
Message-ID: <20100528070026.GA31058@elte.hu>
References: <20100524192531.GA15614@elte.hu>
 <20100525002221.GA30395@drongo>
 <20100525135200.GA21462@elte.hu>
 <alpine.LFD.2.00.1005271533010.11382@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005271533010.11382@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4993]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 25 May 2010, Ingo Molnar wrote:
> >
> >  75 files changed, 1847 insertions(+), 3147 deletions(-)
> 
> I was excited by this ("A code _reduction_! Will wonders never cease?"), but 
> it turns out that all of the reduction was due to removing some unused 
> utility functions from the user-level tools.

Simple things first and maybe it turns into a habit!

> The actual kernel still grew:
>
>  32 files changed, 1327 insertions(+), 964 deletions(-)
>
> oh well. Merged anyway.

Hey, while i have to admit to being a member of the infinitely large group of 
kernel developers working hard to ensure that the kernel's size follows 
Moore's Law - this time i beg to differ, as we _did_ manage to shrink the 
kernel! ;-)

Here's the before/after vmlinux comparison:

 (x86 defconfig, 64-bit): vmlinux: 

                       text      data      bss       dec      hex  filename
                    .......................................................
 cad719d (before):  8441843   1281100   983876  10706819   a35f83   vmlinux
 c5617b2 ( after):  8417488   1277724   983876  10679088   a2f330   vmlinux
                    .......................................................
                    -24.35K    -3.37K
                     -0.28%    -0.26%

Ob'Suggestion: we could help debloating efforts by officially declaring to 
take provably-debloating patches up to -rc4? (with a vmlinux comparison 
mandated in the changelog or such)

Debloating patches tend to reduce complexity, and hence are more 
regression-resistent. (They are also rare, so it's not like we would be 
risking a flood of patches.)

That would be a clever way to redirect the creative energies of kernel 
developers who are otherwise bored by -rc1's legendary stability and always 
try to sneak further features upstream post -rc1.

Such a policy would mean that while the merge window for bloating patches is a 
strict ~1.5 weeks, the merge window for debloating patches would be a generous 
~1.5 months.

Maybe such a mild hint would help propagate the idea some more.

Dunno - just an idea,

	Ingo

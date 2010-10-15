Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab0JODSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 23:18:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51491 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab0JODSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 23:18:41 -0400
Date: Fri, 15 Oct 2010 05:18:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-arch@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        John Reiser <jreiser@bitwagon.com>
Subject: Re: [PATCH 2/3] ftrace/x86: Add support for C version of recordmcount
Message-ID: <20101015031832.GG9640@elte.hu>
References: <20101014210014.895157788@goodmis.org>
 <20101014210136.230687571@goodmis.org>
 <20101015025047.GA9640@elte.hu>
 <1287112449.23682.27.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287112449.23682.27.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 2010-10-15 at 04:50 +0200, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > This patch adds the support for the C version of recordmcount and
> > > compile times show ~ 12% improvement.
> > 
> > I reported this recordmcount performance problem 2 years ago. Better 
> > later than never i guess.
> 
> And I also remember saying after I posted this code that it would have 
> a compile time performance hit. Heck, it's a perl script running on 
> every object file. It was obvious what was at issue here. But it's 
> better to slow down the kernel build than to brick network cards. 

Well, it's even better to do neither!

> Also, perl was much easier to do.

Lets write the whole kernel in perl and forget about performance ;-)

> That said, the embarrassing thing is not that I knew (or you reported 
> it) about this performance problem. I'm actually quite embarrassed 
> that I had this code sitting in my inbox for over a year. I just kept 
> having other things that were more important coming up than lowering 
> the compile time of the kernel. Although, I did work to get streamline 
> config to offset this performance hit.
> 
> Finally, while at the End Users Summit, I decided to take a look at 
> John's code, and I was quite impressed.
> 
> But as you said, better late than never.

Yeah. Note that as a maintainer i need to grumble when i see some 
not-so-good event - even if there's a happy resolution! Otherwise such 
cases would tend to creep up in frequency ;-)

> > > +ifdef CONFIG_DYNAMIC_FTRACE
> > > +	ifdef CONFIG_HAVE_C_MCOUNT_RECORD
> > > +		BUILD_C_RECORDMCOUNT := y
> > > +		export BUILD_C_RECORDMCOUNT
> > 
> > > --- a/arch/x86/Kconfig
> > > +++ b/arch/x86/Kconfig
> > > @@ -33,6 +33,7 @@ config X86
> > >  	select HAVE_KRETPROBES
> > >  	select HAVE_OPTPROBES
> > >  	select HAVE_FTRACE_MCOUNT_RECORD
> > > +	select HAVE_C_MCOUNT_RECORD
> > 
> > The naming is inconsistent here - it should be HAVE_C_RECORDMCOUNT, like 
> > the build variable has, and like the utility is called. If we are going 
> > to add this flag to most architectures we should name it consistently.
> 
> Sure, want me to rebase it or just write a patch on top of it?

Sure, patch on top would be fine.

Thanks,

	Ingo

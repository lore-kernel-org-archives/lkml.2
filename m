Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab0JODOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 23:14:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab0JODOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 23:14:12 -0400
X-Authority-Analysis: v=1.1 cv=QISHQ+x4xS+apxgDHgAvNvlUjyrXCzYsHvuXcbPYiKg= c=1 sm=0 a=9WCZY-WHpdEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=i7uaMaKEbLa_j9SYAS4A:9 a=JgOD3o2aaOuy3W9NFz7XJsGca04A:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/3] ftrace/x86: Add support for C version of
 recordmcount
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-arch@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        John Reiser <jreiser@bitwagon.com>
In-Reply-To: <20101015025047.GA9640@elte.hu>
References: <20101014210014.895157788@goodmis.org>
	 <20101014210136.230687571@goodmis.org>  <20101015025047.GA9640@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 14 Oct 2010 23:14:09 -0400
Message-ID: <1287112449.23682.27.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 04:50 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > This patch adds the support for the C version of recordmcount and
> > compile times show ~ 12% improvement.
> 
> I reported this recordmcount performance problem 2 years ago. Better 
> later than never i guess.

And I also remember saying after I posted this code that it would have a
compile time performance hit. Heck, it's a perl script running on every
object file. It was obvious what was at issue here. But it's better to
slow down the kernel build than to brick network cards. Also, perl was
much easier to do.

That said, the embarrassing thing is not that I knew (or you reported
it) about this performance problem. I'm actually quite embarrassed that
I had this code sitting in my inbox for over a year. I just kept having
other things that were more important coming up than lowering the
compile time of the kernel. Although, I did work to get streamline
config to offset this performance hit.

Finally, while at the End Users Summit, I decided to take a look at
John's code, and I was quite impressed.

But as you said, better late than never.


> 
> > +ifdef CONFIG_DYNAMIC_FTRACE
> > +	ifdef CONFIG_HAVE_C_MCOUNT_RECORD
> > +		BUILD_C_RECORDMCOUNT := y
> > +		export BUILD_C_RECORDMCOUNT
> 
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -33,6 +33,7 @@ config X86
> >  	select HAVE_KRETPROBES
> >  	select HAVE_OPTPROBES
> >  	select HAVE_FTRACE_MCOUNT_RECORD
> > +	select HAVE_C_MCOUNT_RECORD
> 
> The naming is inconsistent here - it should be HAVE_C_RECORDMCOUNT, like 
> the build variable has, and like the utility is called. If we are going 
> to add this flag to most architectures we should name it consistently.

Sure, want me to rebase it or just write a patch on top of it?

-- Steve



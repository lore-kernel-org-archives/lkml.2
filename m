Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab0HSRdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 13:33:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38035 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab0HSRdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 13:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=DIuOtjlADogeBWYv38HNeE9ymWCg4934kgTSvxc+mW1fcw0PxDygC6VDM1sQ4g4gEy
         FeM3oWSgXRaRjhfy+BoHsyWfT97xp6d3V/HJf9BM5zSuIMjqhO3/j+PGIJUxmy7xk2E1
         Cp6LPj3VmNOFuEgIzlscwlYafoTVJUIVaLtGc=
Date: Thu, 19 Aug 2010 19:33:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [GIT PULL] perf callchains updates
Message-ID: <20100819173325.GC5281@nowhere>
References: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com> <1282219778.2605.53.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1282219778.2605.53.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 02:09:38PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-08-19 at 01:46 +0200, Frederic Weisbecker wrote:
> > Ingo,
> > 
> > Please pull the perf/core branch that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	perf/core
> > 
> > Thanks,
> > 	Frederic
> > ---
> > 
> > Frederic Weisbecker (6):
> >       perf: Drop unappropriate tests on arch callchains
> >       perf: Generalize callchain_store()
> >       perf: Generalize some arch callchain code
> >       perf: Factorize callchain context handling
> >       perf: Fix race in callchains
> >       perf: Humanize the number of contexts
> > 
> > Namhyung Kim (1):
> >       perf, tracing: add missing __percpu markups
> > 
> > 
> >  arch/arm/kernel/perf_event.c         |   62 +--------
> >  arch/powerpc/kernel/perf_callchain.c |   86 ++++--------
> >  arch/sh/kernel/perf_callchain.c      |   50 +------
> >  arch/sparc/kernel/perf_event.c       |   69 +++------
> >  arch/x86/kernel/cpu/perf_event.c     |   82 +++--------
> >  include/linux/ftrace_event.h         |    4 +-
> >  include/linux/perf_event.h           |   30 +++-
> >  kernel/perf_event.c                  |  259 ++++++++++++++++++++++++++++++----
> >  kernel/trace/trace_event_perf.c      |   21 ++--
> >  kernel/trace/trace_functions_graph.c |    2 +-
> >  10 files changed, 342 insertions(+), 323 deletions(-)
> 
> /usr/src/linux-2.6/arch/x86/kernel/cpu/perf_event.c: In function ‘perf_callchain_kernel’:
> /usr/src/linux-2.6/arch/x86/kernel/cpu/perf_event.c:1645: warning: ‘return’ with a value, in function returning void
> /usr/src/linux-2.6/arch/x86/kernel/cpu/perf_event.c: In function ‘perf_callchain_user’:
> /usr/src/linux-2.6/arch/x86/kernel/cpu/perf_event.c:1698: warning: ‘return’ with a value, in function returning void
> 



Ah sorry. Should I carry this patch (I'd need your Sob) or will you?

Thanks.


 
> ---
> Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
> +++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
> @@ -1642,7 +1642,7 @@ perf_callchain_kernel(struct perf_callch
>  {
>  	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
>  		/* TODO: We don't support guest os callchain now */
> -		return NULL;
> +		return;
>  	}
>  
>  	perf_callchain_store(entry, regs->ip);
> @@ -1695,7 +1695,7 @@ perf_callchain_user(struct perf_callchai
>  
>  	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
>  		/* TODO: We don't support guest os callchain now */
> -		return NULL;
> +		return;
>  	}
>  
>  	fp = (void __user *)regs->bp;
> 


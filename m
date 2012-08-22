Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2HVIk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:40:29 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45339 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab2HVIkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:40:23 -0400
Date: Wed, 22 Aug 2012 10:40:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Feng Tang <feng.tang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ulrich Drepper <drepper@gmail.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf tools: Fix 'No libunwind found' make warning message
Message-ID: <20120822084017.GA21581@gmail.com>
References: <1345479985-18669-1-git-send-email-acme@infradead.org>
 <20120821093231.GA12385@gmail.com>
 <20120821093628.GA981@krava.brq.redhat.com>
 <20120822083812.GC1003@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822083812.GC1003@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Tue, Aug 21, 2012 at 11:36:28AM +0200, Jiri Olsa wrote:
> > On Tue, Aug 21, 2012 at 11:32:31AM +0200, Ingo Molnar wrote:
> > > 
> > > * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > > 
> > 
> > SNIP
> > 
> > > 
> > > One minor observation, the Makefile tells us:
> > > 
> > > Makefile:496: No libunwind found. Please install libunwind >= 0.99
> > > 
> > > I guess that should be libunwind-dev[el], right? Plain libunwind 
> > > is not enough.
> > 
> > right, will fix it
> > 
> > thanks,
> > jirka
> 
> ---
> Changing error message when libunwind support is not found
> to inform properly to install libunwind-dev[el] package.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 6bd888d..218cdb5 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -493,7 +493,7 @@ endif
>  
>  FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(ALL_CFLAGS) $(LIBUNWIND_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
>  ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND)),y)
> -	msg := $(warning No libunwind found. Please install libunwind >= 0.99);
> +	msg := $(warning No libunwind found, disables post unwind support. Please install libunwind-dev[el] >= 0.99);

s/disables/disable

Thanks,

	Ingo

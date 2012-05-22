Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2EVIfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:35:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917Ab2EVIfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:35:41 -0400
Date: Tue, 22 May 2012 10:35:27 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] perf tools: Split out util/symbol-elf.c
Message-ID: <20120522083527.GA2901@m.brq.redhat.com>
References: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
 <1336979424-17206-4-git-send-email-namhyung.kim@lge.com>
 <20120521114531.GB5923@m.brq.redhat.com>
 <871umd2fno.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871umd2fno.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 10:00:43AM +0900, Namhyung Kim wrote:
> Hi, Jiri
> 
> On Mon, 21 May 2012 13:45:31 +0200, Jiri Olsa wrote:
> > hi,
> > this one needs rebase to current code, I got some conflicts
> >
> 
> Will do.
> 
> 
> > On Mon, May 14, 2012 at 04:10:22PM +0900, Namhyung Kim wrote:
> >> Factor out the dependency of ELF handling into separate
> >> symbol-elf.c file. It is a preparation of building a
> >> minimalistic version perf tools which doesn't depend on
> >> the elfutils.
> >> 
> >> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> >> ---
> >>  tools/perf/Makefile          |    1 +
> >>  tools/perf/util/symbol-elf.c |  691 +++++++++++++++++++++++++++++++++++++++++
> >>  tools/perf/util/symbol.c     |  704 +-----------------------------------------
> >>  tools/perf/util/symbol.h     |   15 +
> >>  4 files changed, 715 insertions(+), 696 deletions(-)
> >>  create mode 100644 tools/perf/util/symbol-elf.c
> >> 
> >> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> >> index e98e14c88532..7198c6cbc006 100644
> >> --- a/tools/perf/Makefile
> >> +++ b/tools/perf/Makefile
> >> @@ -334,6 +334,7 @@ LIB_OBJS += $(OUTPUT)util/usage.o
> >>  LIB_OBJS += $(OUTPUT)util/wrapper.o
> >>  LIB_OBJS += $(OUTPUT)util/sigchain.o
> >>  LIB_OBJS += $(OUTPUT)util/symbol.o
> >> +LIB_OBJS += $(OUTPUT)util/symbol-elf.o
> >
> > I think I'd like more generic elf interface compiled with either libelf
> > or our stuff.. also separated from "other perf related" symbol handling
> >
> > looks like we need to be able to parse out build ID and symbols from
> > symtab or dyntab:
> >
> > perf_elf__get_buildid(file, buf, len)
> >
> > perf_elf__get_symbols(file, ..., callback, )
> >  - calling callback func for each symbol found,
> >    the call would then do the perf symbol related stuff
> >
> > I understand that means much more changes.. so probably what you have now
> > is a good start and we can do that later.. just with above goal in mind
> >
> 
> So you mean we need to have our own libelf or such? I'm not sure it's

I meant having above interface implemented either via libelf or your
minimal implementation.. just little more general than the current one

jirka

> the way to go. I just wanted to have a working 'perf record' on my board
> :). But I'd like to hear how others think.
> 
> Thanks for the comment,
> Namhyung

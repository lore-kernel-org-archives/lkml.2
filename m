Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431Ab2JTAgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 20:36:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59667 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab2JTAgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 20:36:03 -0400
Date: Sat, 20 Oct 2012 02:35:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/11] perf python: Link with libtraceevent
Message-ID: <20121020003556.GA15567@gmail.com>
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
 <1350494387-10987-10-git-send-email-acme@infradead.org>
 <87y5j41rw5.fsf@sejong.aot.lge.com>
 <20121018140033.GC2057@infradead.org>
 <20121018143835.GE2057@infradead.org>
 <1350574827.1610.8.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1350574827.1610.8.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> 2012-10-18 (???), 11:38 -0300, Arnaldo Carvalho de Melo:
> > Em Thu, Oct 18, 2012 at 11:00:33AM -0300, Arnaldo Carvalho de Melo escreveu:
> > > Em Thu, Oct 18, 2012 at 10:38:18AM +0900, Namhyung Kim escreveu:
> > > > On Wed, 17 Oct 2012 14:19:45 -0300, Arnaldo Carvalho de Melo wrote:
> > > > I got a build error after adding 'extern unsigned int page_size' to
> > > > util/python.c - please see my previous reply.
> > > > 
> > > >   namhyung@sejong:perf$ make
> > > >       SUBDIR ../lib/traceevent/
> > > >       LINK perf
> > > >       GEN python/perf.so
> > > >   gcc: error: python_ext_build/tmp//../../libtraceevent.a: No such file or directory
> > > >   error: command 'gcc' failed with exit status 1
> > > >   cp: cannot stat `python_ext_build/lib/perf.so': No such file or directory
> > > >   make: *** [python/perf.so] Error 1
> > > >   TRACE_EVENT_DIR = ../lib/traceevent/
> >    
> > > >   ifneq ($(OUTPUT),)
> > > >   	TE_PATH=$(OUTPUT)
> > > >   else
> > > >   	TE_PATH=$(TRACE_EVENT_DIR)
> > > >   endif
> > > >   
> > > >   LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
> > > 
> > > I see, so we need to somehow propagate this TE_PATH variable to the setup.py file...
> > 
> > Can you try with the attached patch? I tested it here and works with:
> > 
> >  make -C tools/perf
> > 
> > and with O=
> 
> It works well for me too:
> 
> Tested-by: Namhyung Kim <namhyung@kernel.org>

Even with that I'm getting:

util/python.c: In function ‘initperf’:
util/python.c:1018:2: error: ‘page_size’ undeclared 
(first use in this function)
util/python.c:1018:2: note: each undeclared identifier is 
reported only once for each function it appears in
error: command 'gcc' failed with exit status 1

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab2JRPke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:40:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57651 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab2JRPkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:40:33 -0400
Subject: Re: [PATCH 09/11] perf python: Link with libtraceevent
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <20121018143835.GE2057@infradead.org>
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
	 <1350494387-10987-10-git-send-email-acme@infradead.org>
	 <87y5j41rw5.fsf@sejong.aot.lge.com> <20121018140033.GC2057@infradead.org>
	 <20121018143835.GE2057@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Oct 2012 00:40:27 +0900
Message-ID: <1350574827.1610.8.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-18 (목), 11:38 -0300, Arnaldo Carvalho de Melo:
> Em Thu, Oct 18, 2012 at 11:00:33AM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Thu, Oct 18, 2012 at 10:38:18AM +0900, Namhyung Kim escreveu:
> > > On Wed, 17 Oct 2012 14:19:45 -0300, Arnaldo Carvalho de Melo wrote:
> > > I got a build error after adding 'extern unsigned int page_size' to
> > > util/python.c - please see my previous reply.
> > > 
> > >   namhyung@sejong:perf$ make
> > >       SUBDIR ../lib/traceevent/
> > >       LINK perf
> > >       GEN python/perf.so
> > >   gcc: error: python_ext_build/tmp//../../libtraceevent.a: No such file or directory
> > >   error: command 'gcc' failed with exit status 1
> > >   cp: cannot stat `python_ext_build/lib/perf.so': No such file or directory
> > >   make: *** [python/perf.so] Error 1
> > >   TRACE_EVENT_DIR = ../lib/traceevent/
>    
> > >   ifneq ($(OUTPUT),)
> > >   	TE_PATH=$(OUTPUT)
> > >   else
> > >   	TE_PATH=$(TRACE_EVENT_DIR)
> > >   endif
> > >   
> > >   LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
> > 
> > I see, so we need to somehow propagate this TE_PATH variable to the setup.py file...
> 
> Can you try with the attached patch? I tested it here and works with:
> 
>  make -C tools/perf
> 
> and with O=

It works well for me too:

Tested-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung




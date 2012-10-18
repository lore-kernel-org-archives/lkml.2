Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab2JROAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:00:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:59856 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab2JROAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:00:52 -0400
Date: Thu, 18 Oct 2012 11:00:33 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/11] perf python: Link with libtraceevent
Message-ID: <20121018140033.GC2057@infradead.org>
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
 <1350494387-10987-10-git-send-email-acme@infradead.org>
 <87y5j41rw5.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5j41rw5.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 18, 2012 at 10:38:18AM +0900, Namhyung Kim escreveu:
> On Wed, 17 Oct 2012 14:19:45 -0300, Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> >
> > The evsel methods to read tracepoint fields uses libtraceevent
> > functions, becoming needed by the python binding as well.
> 
> I got a build error after adding 'extern unsigned int page_size' to
> util/python.c - please see my previous reply.
> 
>   namhyung@sejong:perf$ make
>       SUBDIR ../lib/traceevent/
>       LINK perf
>       GEN python/perf.so
>   gcc: error: python_ext_build/tmp//../../libtraceevent.a: No such file or directory
>   error: command 'gcc' failed with exit status 1
>   cp: cannot stat `python_ext_build/lib/perf.so': No such file or directory
>   make: *** [python/perf.so] Error 1
> 
> The libtraceevent.a will be in
> python_ext_build/tmp/../../../lib/traceevent/libtraceevent.a if make was
> invoked without the O.
> 
> Makefile contains following:
> 
>   TRACE_EVENT_DIR = ../lib/traceevent/
>   
>   ifneq ($(OUTPUT),)
>   	TE_PATH=$(OUTPUT)
>   else
>   	TE_PATH=$(TRACE_EVENT_DIR)
>   endif
>   
>   LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
>   TE_LIB := -L$(TE_PATH) -ltraceevent

I see, so we need to somehow propagate this TE_PATH variable to the setup.py file...

- Arnaldo

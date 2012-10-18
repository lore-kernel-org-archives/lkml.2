Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2JRBiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 21:38:23 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64607 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2JRBiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 21:38:22 -0400
X-AuditID: 9c930197-b7c4aae000004160-36-507f5d8a2df0
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/11] perf python: Link with libtraceevent
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
	<1350494387-10987-10-git-send-email-acme@infradead.org>
Date: Thu, 18 Oct 2012 10:38:18 +0900
In-Reply-To: <1350494387-10987-10-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Wed, 17 Oct 2012 14:19:45 -0300")
Message-ID: <87y5j41rw5.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2012 14:19:45 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> The evsel methods to read tracepoint fields uses libtraceevent
> functions, becoming needed by the python binding as well.

I got a build error after adding 'extern unsigned int page_size' to
util/python.c - please see my previous reply.

  namhyung@sejong:perf$ make
      SUBDIR ../lib/traceevent/
      LINK perf
      GEN python/perf.so
  gcc: error: python_ext_build/tmp//../../libtraceevent.a: No such file or directory
  error: command 'gcc' failed with exit status 1
  cp: cannot stat `python_ext_build/lib/perf.so': No such file or directory
  make: *** [python/perf.so] Error 1

The libtraceevent.a will be in
python_ext_build/tmp/../../../lib/traceevent/libtraceevent.a if make was
invoked without the O.

Makefile contains following:

  TRACE_EVENT_DIR = ../lib/traceevent/
  
  ifneq ($(OUTPUT),)
  	TE_PATH=$(OUTPUT)
  else
  	TE_PATH=$(TRACE_EVENT_DIR)
  endif
  
  LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
  TE_LIB := -L$(TE_PATH) -ltraceevent

Thanks,
Namhyung

>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Link: http://lkml.kernel.org/n/tip-j3o4v7jyvp9ke9n230l96a1m@git.kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/setup.py |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
> index d0f9f29..09c3cea 100644
> --- a/tools/perf/util/setup.py
> +++ b/tools/perf/util/setup.py
> @@ -31,6 +31,7 @@ perf = Extension('perf',
>  		  sources = ext_sources,
>  		  include_dirs = ['util/include'],
>  		  extra_compile_args = cflags,
> +		  extra_objects = [build_tmp + '/../../libtraceevent.a'],
>                   )
>  
>  setup(name='perf',

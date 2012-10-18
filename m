Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2JRBcC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 21:32:02 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58039 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab2JRBcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 21:32:01 -0400
X-AuditID: 9c930197-b7c4aae000004160-c1-507f5c0e6dbb
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 08/11] perf python: Initialize 'page_size' variable
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
	<1350494387-10987-9-git-send-email-acme@infradead.org>
Date: Thu, 18 Oct 2012 10:31:57 +0900
In-Reply-To: <1350494387-10987-9-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Wed, 17 Oct 2012 14:19:44 -0300")
Message-ID: <87391c36r6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Wed, 17 Oct 2012 14:19:44 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> The commit 0c1fe6b:
>
>  'perf tools: Have the page size value available for all tools'

Is that commit in your perf/urgent branch?  I got this:

    GEN python/perf.so
util/python.c: In function ‘initperf’:
util/python.c:1018:2: error: ‘page_size’ undeclared (first use in this function)
util/python.c:1018:2: note: each undeclared identifier is reported only once for each function it appears in
error: command 'gcc' failed with exit status 1
cp: cannot stat `python_ext_build/lib/perf.so': No such file or directory
make: *** [python/perf.so] Error 1

Adding '#include "util.h"' didn't work.  But manually adding 'extern
unsigned int page_size;' did.

Thanks,
Namhyung


>
> Broke the python binding because the global variable 'page_size' is
> initialized on the main() routine, that is not called when using
> just the python binding, causing evlist.mmap() to fail because it
> expects that variable to be initialized to the system's page size.
>
> Fix it by initializing it on the binding init routine.
>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Link: http://lkml.kernel.org/n/tip-vrvp3azmbfzexnpmkhmvtzzc@git.kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/python.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
> index 9181bf2..a2657fd 100644
> --- a/tools/perf/util/python.c
> +++ b/tools/perf/util/python.c
> @@ -1015,6 +1015,8 @@ PyMODINIT_FUNC initperf(void)
>  	    pyrf_cpu_map__setup_types() < 0)
>  		return;
>  
> +	page_size = sysconf(_SC_PAGE_SIZE);
> +
>  	Py_INCREF(&pyrf_evlist__type);
>  	PyModule_AddObject(module, "evlist", (PyObject*)&pyrf_evlist__type);

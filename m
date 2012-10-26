Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890Ab2JZPeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:34:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34741 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933782Ab2JZPea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:34:30 -0400
Date: Fri, 26 Oct 2012 17:34:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Borislav Petkov <bp@amd64.org>, David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/9] perf/core improvements and fixes
Message-ID: <20121026153431.GA5230@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
	Borislav Petkov <bp@amd64.org>, David Howells <dhowells@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Stephane Eranian <eranian@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>, arnaldo.melo@gmail.com,
	Arnaldo Carvalho de Melo <acme@redhat.com>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
 <20121026145451.GA14379@gmail.com>
 <508AA709.7010202@gmail.com>
 <1351265502.1619.13.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1351265502.1619.13.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 12:31:42AM +0900, Namhyung Kim wrote:
> And I see a strange delay when compiling builtin-sched.o.  After
> building perf tools, I deleted builtin-{sched,test,script}.o to rebuild
> the only since they are largest ones.
> 
>   namhyung@leonhard:perf$ ls -lS *.c | head -3
>   -rw-r--r-- 1 namhyung namhyung 45522 2012-10-27 00:20 builtin-sched.c
>   -rw-r--r-- 1 namhyung namhyung 36372 2012-10-27 00:20 builtin-test.c
>   -rw-r--r-- 1 namhyung namhyung 35555 2012-10-27 00:20 builtin-script.c
> 
>   namhyung@leonhard:perf$ rm builtin-{sched,test,script}.o
> 
> 
> And then building each file with time command shows this:
> 
>   namhyung@leonhard:perf$ time make builtin-script.o &> /dev/null
> 
>   real	0m4.577s
>   user	0m2.755s
>   sys	0m1.655s
> 
>   namhyung@leonhard:perf$ time make builtin-test.o &> /dev/null
> 
>   real	0m4.486s
>   user	0m2.707s
>   sys	0m1.658s
> 
>   namhyung@leonhard:perf$ time make builtin-sched.o &> /dev/null
> 
>   real	0m16.936s
>   user	0m15.157s
>   sys	0m1.635s
> 
> You can see it easily when building perf without -j option. But I have
> no idea why it takes so long..

Well, you can trace that workload with perf itself, no, and see the
hotspots.

:-)

-- 
Regards/Gruss,
Boris.

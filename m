Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875Ab2JZPbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:31:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933738Ab2JZPbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:31:50 -0400
Subject: Re: [GIT PULL 0/9] perf/core improvements and fixes
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Borislav Petkov <bp@amd64.org>, David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <508AA709.7010202@gmail.com>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
	 <20121026145451.GA14379@gmail.com>  <508AA709.7010202@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Oct 2012 00:31:42 +0900
Message-ID: <1351265502.1619.13.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-26 (금), 09:06 -0600, David Ahern:
> On 10/26/12 8:54 AM, Ingo Molnar wrote:
> >> perf/core improvements:
> >>
> >> . perf inject changes to allow showing where a task sleeps, from Andrew Vagin.
> >>
> >> . Makefile improvements from Namhyung Kim.
> >
> > These are really useful: there used to be a couple of seconds of
> > wait time at the beginning of every perf build - these are now
> > nicely explained with the various CHK entries.

Kudos to Jiri who did the real work!

> 
> PERF-VERSION-GEN and specifically the git commands are the cause of more 
> delay than the config checks, especially when doing the build in a VM 
> with the kernel source on an NFS mount.

And I see a strange delay when compiling builtin-sched.o.  After
building perf tools, I deleted builtin-{sched,test,script}.o to rebuild
the only since they are largest ones.

  namhyung@leonhard:perf$ ls -lS *.c | head -3
  -rw-r--r-- 1 namhyung namhyung 45522 2012-10-27 00:20 builtin-sched.c
  -rw-r--r-- 1 namhyung namhyung 36372 2012-10-27 00:20 builtin-test.c
  -rw-r--r-- 1 namhyung namhyung 35555 2012-10-27 00:20 builtin-script.c

  namhyung@leonhard:perf$ rm builtin-{sched,test,script}.o


And then building each file with time command shows this:

  namhyung@leonhard:perf$ time make builtin-script.o &> /dev/null

  real	0m4.577s
  user	0m2.755s
  sys	0m1.655s

  namhyung@leonhard:perf$ time make builtin-test.o &> /dev/null

  real	0m4.486s
  user	0m2.707s
  sys	0m1.658s

  namhyung@leonhard:perf$ time make builtin-sched.o &> /dev/null

  real	0m16.936s
  user	0m15.157s
  sys	0m1.635s

You can see it easily when building perf without -j option. But I have
no idea why it takes so long..

Thanks,
Namhyung



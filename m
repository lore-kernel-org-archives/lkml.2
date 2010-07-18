Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab0GRHRd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 03:17:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49752 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab0GRHRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 03:17:31 -0400
Date: Sun, 18 Jul 2010 09:17:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/3] perf/core improvements
Message-ID: <20100718071716.GA32016@elte.hu>
References: <1279417736-4396-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279417736-4396-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0329]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (3):
>   perf ui: Make END go to the last entry, not the top of the last page
>   perf ui: Make ui_browser__run exit on unhandled hot keys
>   perf hists: Factor out duplicated code
> 
>  tools/perf/util/hist.c |   36 ++++++++++++++++++------------------
>  tools/perf/util/newt.c |   14 +++++---------
>  2 files changed, 23 insertions(+), 27 deletions(-)

Pulled, thanks Arnaldo!

FYI, i'm still seeing problems with 'perf report --parent xyz' functionality, 
as the Newt interface segfaults:

#0  0x00007ffff7dddcdb in ?? () from /usr/lib64/libnewt.so.0.52
#1  0x00007ffff7dd5ab6 in ?? () from /usr/lib64/libnewt.so.0.52
#2  0x00007ffff7dd5260 in ?? () from /usr/lib64/libnewt.so.0.52
#3  0x00007ffff7dd61ff in newtFormRun () from /usr/lib64/libnewt.so.0.52
#4  0x00000000004552a1 in hists__browse (self=0xa302b0, helpline=<value optimized out>, 
    ev_name=0x4e5dde "cycles") at util/newt.c:968
#5  0x0000000000455bc0 in hists__tui_browse_tree (self=<value optimized out>, 
    help=0x4e0710 "For a higher level overview, try: perf report --sort comm,dso")
    at util/newt.c:1142
#6  0x00000000004109e3 in __cmd_report (argc=<value optimized out>, argv=<value optimized out>, 
    prefix=<value optimized out>) at builtin-report.c:346
#7  cmd_report (argc=<value optimized out>, argv=<value optimized out>, 
    prefix=<value optimized out>) at builtin-report.c:508
#8  0x0000000000406188 in run_builtin (p=0x722590, argc=3, argv=0x7fffffffe570) at perf.c:286
#9  0x0000000000406be6 in handle_internal_command (argc=3, argv=0x7fffffffe570) at perf.c:357
#10 run_argv (argc=3, argv=0x7fffffffe570) at perf.c:401
#11 main (argc=3, argv=0x7fffffffe570) at perf.c:487

newt-0.52.11-2.fc13.x86_64

perf version 2.6.35.rc5.1194.g16950e5

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1JOPBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 11:01:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54483 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab1JOPBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 11:01:30 -0400
Date: Sat, 15 Oct 2011 16:59:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Jarosch <thomas.jarosch@intra2net.com>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/5] perf/core improvements and fixes
Message-ID: <20111015145946.GB9516@elte.hu>
References: <1318616873-26739-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318616873-26739-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please consider pulling from:
> 
> git://github.com/acmel/linux.git perf/core
> 
> 	These are in addition to the ones you reported being problematic
> with perf top segfaulting sometimes, that problem should be fixed by the
> first patch below.
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (4):
>   perf hists browser: Invalidate ui_browser->top after timer calls
>   perf annotate browser: Exit when pressing ESC or the left arrow
>   perf ui browser: Add filter method
>   perf annotate browser: Allow toggling the visualization of source code lines
> 
> Thomas Jarosch (1):
>   perf buildid: Fix possible unterminated readlink() result buffer
> 
>  tools/perf/util/header.c               |    2 +-
>  tools/perf/util/ui/browser.c           |   52 +++++++++++++++++----
>  tools/perf/util/ui/browser.h           |    1 +
>  tools/perf/util/ui/browsers/annotate.c |   78 +++++++++++++++++++++++++++++--
>  tools/perf/util/ui/browsers/hists.c    |   15 +++++-
>  5 files changed, 131 insertions(+), 17 deletions(-)

Pulled, thanks a lot Arnaldo!

The 'perf top' segfault is indeed fixed for me too.

Btw., i noticed another weirdness - sometimes after startup i get 
this message:

/lib64/libc-2.14.90.so was updated, restart the long running apps that use it!                          

but it was not updated recently:

 earth5:~/tip/tools/perf> ll /lib64/libc-2.14.90.so
 -rwxr-xr-x 1 root root 2062920 Sep 28 15:11 /lib64/libc-2.14.90.so
 earth5:~/tip/tools/perf> date
 Sat Oct 15 16:59:04 CEST 2011
 earth5:~/tip/tools/perf> uptime
  16:59:08 up 19 days, 21:35, 11 users,  load average: 7.77, 7.48, 3.81

Thanks,

	Ingo

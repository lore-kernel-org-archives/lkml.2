Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1E1JmH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 05:42:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43436 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab1E1JmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 05:42:05 -0400
Date: Sat, 28 May 2011 11:41:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/5] perf/urgent fixes
Message-ID: <20110528094150.GA12059@elte.hu>
References: <1306532736-3790-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306532736-3790-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
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
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (4):
>   perf tools: Make sure kptr_restrict warnings fit 80 col terms
>   perf top: Remove unused macro
>   perf top: Handle kptr_restrict
>   perf top: Don't stop if no kernel symtab is found
> 
> David Ahern (1):
>   perf events: initialize fd array to -1 instead of 0
> 
>  tools/perf/builtin-record.c |   19 ++++++++-----------
>  tools/perf/builtin-report.c |   17 +++++++----------
>  tools/perf/builtin-top.c    |   37 ++++++++++++++++++++++++++++++-------
>  tools/perf/util/evsel.c     |   10 ++++++++++
>  4 files changed, 55 insertions(+), 28 deletions(-)

Pulled, thanks a lot Arnaldo!

The various variations of kptr_restrict now work fine AFAICS - will 
send the fixes to Linus today.

One (very) small issue i noticed, if the user only samples user-space 
events then i still get the warning:

 aldebaran:~> perf record -e cycles:upp sleep 1
 WARNING: Kernel address maps (/proc/{kallsyms,modules}) are restricted,

although perf does not record any kernel samples so kptr_restrict is 
irrelevant in this case.

	Ingo

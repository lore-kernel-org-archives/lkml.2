Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab0E1IWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 04:22:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52328 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805Ab0E1IWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 04:22:18 -0400
Date: Fri, 28 May 2010 10:22:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/2] perf tui fix and annotate improvement
Message-ID: <20100528082206.GB24058@elte.hu>
References: <1274909449-10977-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274909449-10977-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0011]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
> 
> 	I still have to make it cache vmlinux files instead of always caching
> kallsyms, so that users can select it via .perfconfig the tradeof .debug/ disk
> space versus offline/precise (build-id verified) annotate ability for kernel
> symbols.
> 
> 	But one can use another seldom used perf command to workaround this
> situation, buildid-cache, by doing:
> 
> perf buildid-cache -r /path/to/vmlinux
> perf buildid-cache -a /path/to/vmlinux
> 
> 	The first one will read the build-id in /path/to/vmlinux, and remove
> the symlink from the cache, the second will add the vmlinux file to the cache
> and make the symlink to it, so that 'perf archive' will package the right
> vmlinux and then offline annotation should work as expected.
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (2):
>   perf tui: Reset use_browser if stdout is not a tty
>   perf symbols: Add the build id cache to the vmlinux path
> 
>  tools/perf/builtin-annotate.c |    2 +-
>  tools/perf/builtin-top.c      |    2 +-
>  tools/perf/util/newt.c        |    1 +
>  tools/perf/util/symbol.c      |   27 +++++++++++++++++++++++----
>  tools/perf/util/symbol.h      |    2 +-
>  5 files changed, 27 insertions(+), 7 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo

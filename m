Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab1J0HNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:13:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33332 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab1J0HNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:13:45 -0400
Date: Thu, 27 Oct 2011 09:12:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Deng-Cheng Zhu <dczhu@mips.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 00/11] perf/core fixes and improvements
Message-ID: <20111027071207.GB14858@elte.hu>
References: <1319651314-29404-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319651314-29404-1-git-send-email-acme@infradead.org>
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
> 	It _almost_ is libnewt free, got preempted now, will continue later.
> 
> 	Using libnewt ended up being inflexible and since I had to implement
> the ui_browser to work directly with the existing perf hist_entry abstractions,
> namely callchains, I ended up using it for menus and for the annotate browser.
> 
> 	It got less and less used and finally handling SIGWINCH made me decide
> to work towards using just libslang.
> 
> 	The abstractions that are being put in place should make it not that
> difficult to have a GUI at some point.
> 
> Regards,
> 
> - Arnaldo
> 
> HEAD now is   a9072bc0b0af991e274b699f17bc50cf201e377b
> Changes since c752d04066a36ae30b29795f3fa3f536292c1f8c:
> 
> Arnaldo Carvalho de Melo (11):
>   perf evlist: Fix grouping of multiple events
>   perf ui progress: Reimplement using slang
>   perf ui: Improve handling sigwinch a bit
>   perf ui: Reimplement ui_helpline using libslang
>   perf ui: Reimplement ui__popup_menu using ui__browser
>   perf ui: Reimplement the popup windows using libslang
>   perf ui: Rename ui__warning_paranoid to ui__error_paranoid
>   perf hists browser: Use K_TIMER
>   perf ui browser: No need to switch char sets that often
>   perf ui browser: Handle K_RESIZE in dialog windows
>   perf header: Fix build on old systems
> 
>  tools/perf/builtin-record.c            |   13 ++-
>  tools/perf/builtin-stat.c              |   20 +++-
>  tools/perf/builtin-test.c              |    6 +-
>  tools/perf/builtin-top.c               |   13 ++-
>  tools/perf/util/annotate.c             |    9 +-
>  tools/perf/util/debug.c                |    7 +-
>  tools/perf/util/debug.h                |   17 +--
>  tools/perf/util/evlist.c               |   30 +++++
>  tools/perf/util/evlist.h               |    2 +
>  tools/perf/util/evsel.c                |   43 ++++++--
>  tools/perf/util/evsel.h                |   10 ++-
>  tools/perf/util/header.c               |    2 +-
>  tools/perf/util/python.c               |   31 +++++-
>  tools/perf/util/session.c              |    8 +-
>  tools/perf/util/ui/browser.c           |  138 +++++++++++++++---------
>  tools/perf/util/ui/browser.h           |    8 ++
>  tools/perf/util/ui/browsers/annotate.c |   14 +--
>  tools/perf/util/ui/browsers/hists.c    |   27 +++--
>  tools/perf/util/ui/helpline.c          |   16 ++-
>  tools/perf/util/ui/helpline.h          |    2 +
>  tools/perf/util/ui/progress.c          |   65 +++---------
>  tools/perf/util/ui/progress.h          |    7 +-
>  tools/perf/util/ui/setup.c             |   83 ++++++++++++++-
>  tools/perf/util/ui/ui.h                |    3 +
>  tools/perf/util/ui/util.c              |  182 +++++++++++++++++++-------------
>  tools/perf/util/ui/util.h              |    8 +-
>  26 files changed, 504 insertions(+), 260 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo

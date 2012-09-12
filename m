Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab2ILBET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 21:04:19 -0400
Received: from [205.233.59.134] ([205.233.59.134]:45290 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756822Ab2ILBEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 21:04:16 -0400
Date: Tue, 11 Sep 2012 18:03:10 -0700
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/18] perf test: Remove die() calls
Message-ID: <20120912010310.GA10019@ghostprotocols.net>
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
 <1347407590-30960-2-git-send-email-acme@infradead.org>
 <87627kay0u.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87627kay0u.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 12, 2012 at 09:24:33AM +0900, Namhyung Kim escreveu:
> Hi, Arnaldo
> 
> On Tue, 11 Sep 2012 20:52:53 -0300, Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> >
> > Just use pr_err() + return -1 and let the other tests run as well and
> > then the perf's main() exit doing whatever it needs.
> [snip]
> > diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
> > index cf33e50..6ae102e 100644
> > --- a/tools/perf/builtin-test.c
> > +++ b/tools/perf/builtin-test.c
> > @@ -1023,14 +1023,16 @@ static int __test__rdpmc(void)
> >  
> >  	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
> >  	if (fd < 0) {
> > -		die("Error: sys_perf_event_open() syscall returned "
> > -		    "with %d (%s)\n", fd, strerror(errno));
> > +		pr_debug("Error: sys_perf_event_open() syscall returned "
> > +			 "with %d (%s)\n", fd, strerror(errno));
> 
> s/pr_debug/pr_err/ ?
> 
> Otherwise the message will not be shown unless -v option is given
> - and it's not sync with the changelog ;-)

Oops :-\ Can you sent a fixup patch for this and the other case?

Thanks for the review!

- Arnaldo

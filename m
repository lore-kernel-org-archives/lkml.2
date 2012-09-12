Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784Ab2ILNtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:49:16 -0400
Received: from [205.233.59.134] ([205.233.59.134]:40333 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab2ILNtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:49:13 -0400
Date: Wed, 12 Sep 2012 06:47:49 -0700
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 16/18] perf evsel: Introduce perf_evsel__{str,int}val
 methods
Message-ID: <20120912134749.GB10019@ghostprotocols.net>
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
 <1347407590-30960-17-git-send-email-acme@infradead.org>
 <87oblc9fyn.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87oblc9fyn.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 12, 2012 at 10:40:00AM +0900, Namhyung Kim escreveu:
> On Tue, 11 Sep 2012 20:53:08 -0300, Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> >
> > Wrappers to the libtraceevent routines, so that we can further reduce
> > the surface contact perf builtins have with it.
> [snip]
> > +char *perf_evsel__strval(struct perf_evsel *evsel, struct perf_sample *sample,
> > +			 const char *name)
> > +{
> > +	struct format_field *field = pevent_find_field(evsel->tp_format, name);
> > +	int offset;
> > +
> > +        if (!field)
> > +                return NULL;
> 
> Whitespace problem?

Argh, if it is so, I have somehow unwired my git hook scripts, will
check.
 
> Btw, as a generic wrapper shouldn't it handle common fields also?  If
> you care about performance, how about switching the order of finding
> fields in question, i.e.:
> 
> 	struct format_field *field = pevent_find_field(evsel->tp_format, name);
> 
> 	if (!field) {
> 		field = pevent_find_common_field(evsel->tp_format, name);
> 		if (!field)
> 			return NULL;
> 	}

When I see the need for looking at those commom fields, and so far I saw
none since we have perf_sample already, I think I'll add a wrapper for
pevent_find_common_field. I.e. use the fact we know we want one of those
fields, the _any_ is just a distraction, I think.
 
- Arnaldo

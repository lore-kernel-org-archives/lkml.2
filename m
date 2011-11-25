Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1KYLqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 06:46:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab1KYLqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 06:46:20 -0500
Date: Fri, 25 Nov 2011 09:46:11 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: mingo@redhat.com, eranian@google.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, efault@gmx.de, peterz@infradead.org
Subject: Re: libperf interface stability
Message-ID: <20111125114611.GA7098@infradead.org>
References: <new-submission> <tip-06daaaba7c211ca6a8227b9a54dbc86dd837f034@git.kernel.org> <20111124162845.GB7795@erda.amd.com> <20111124181052.GA4058@infradead.org> <20111125104535.GN15738@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111125104535.GN15738@erda.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 25, 2011 at 11:45:35AM +0100, Robert Richter escreveu:
> On 24.11.11 16:10:52, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Nov 24, 2011 at 05:28:45PM +0100, Robert Richter escreveu:
> > > It would be good to have a well defined, stable libperf interface for
> > > tools other than perf.

> > Agreed, an effort in this direction was the perf python binding, that so
> > far includes only:

> > tools/perf/util/setup.py

> > 	sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
> > 		   'util/evsel.c', 'util/cpumap.c', 'util/thread_map.c',
> > 		   'util/util.c', 'util/xyarray.c', 'util/cgroup.c',
> > 		   'util/debugfs.c'],

> > You need https://github.com/acmel/linux/commits/perf/urgent to build it
> > tho, it has a fix for that:

> > In the end it generates a ~/build/perf/python/perf.so file (I use make
> > -C tools/perf O=/home/acme/build/perf) that has all that is needed for
> > simple tools like tools/perf/python/twatch.py.

> > I think of it as a precursor for a shared library for use with C and I
> > have been working on untangling references such as the symbol_conf one
> > you mentioned and making the 'perf_evlist' and 'perf_evsel' classes the
> > main way to work with libperf.

> Thanks Arnaldo, will then take this as a base to start with.

Good, if you could do something like:

1) get the above list of c files except for util/python.c that is just
glue stuff for the python binding and make it the new libperf.a

2) make a perf.a that just is libperf.a + the rest of the .c files today
in libperf.a, i.e. perf.a would be the "just for perf tools for now"
bundle

3) make the python binding be just this new libperf.a + util/python.c

4) make libperf.so.0.0.1 be just what is in this new libperf.a

I think we would have a good start, committing just to what is in the
python binding as the first iteration, then over time we can on a case
ba casis, slowly, move more things there.

Then, if you use this new libperf.so.0.0.1 in some tool, lets check if
the abstractions in place there are enough for your case, I'd really
love to know if they are enough or have any major flaw :-)

Or if you just want to use them directly for initial experimenting, just
link against that set of files removing python.c.

- Arnaldo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab2IYNcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:32:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab2IYNcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:32:04 -0400
Date: Tue, 25 Sep 2012 10:30:15 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Feng Tang <feng.tang@intel.com>, mingo@elte.hu, a.p.zijlstra@chello.nl,
        andi@firstfloor.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: perf tools regression testing was Re: [PATCH v3 1/9] perf hists:
 Move hists_init() from util/evsel.c to util/hist.c
Message-ID: <20120925133015.GA2892@infradead.org>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
 <1348500251-9937-2-git-send-email-feng.tang@intel.com>
 <20120924160239.GD9977@infradead.org>
 <87pq5ayjuu.fsf@sejong.aot.lge.com>
 <20120925110519.GA28902@infradead.org>
 <1348577942.1877.32.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1348577942.1877.32.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 25, 2012 at 09:59:02PM +0900, Namhyung Kim escreveu:
> 2012-09-25 (화), 08:05 -0300, Arnaldo Carvalho de Melo:
> > Em Tue, Sep 25, 2012 at 10:25:13AM +0900, Namhyung Kim escreveu:
> > > On Mon, 24 Sep 2012 13:02:39 -0300, Arnaldo Carvalho de Melo wrote:
> > > > Em Mon, Sep 24, 2012 at 11:24:03PM +0800, Feng Tang escreveu:
> > > >> Which looks more natural

> > > > It is there to avoid dragging the hist code into the python binding :-\

> > > Hmm... it's so hairy.  Can't we do better?

> > We always can do better :-)

> > I just stated why it was at that place.

> > When doing refactorings we're all the time trying to make it better in
> > many senses, one of them is trying to isolate code that is useful in a
> > general way and thus should be made available via a library/scripting
> > binding.
 
> Yeah, but the isolation sometimes got broken as code getting added like
> this.  So we need a automatic way of detecting breakage.

Agreed.
 
> I thought about adding a perf test entry running python/twatch.py, but
> it will not work for an installed perf binary since it cannot find the
> twatch.py script and perf.so extension files which are not installed.

I thought about doing it the way 'perf script' works with python, i.e.
calling the python interpreter, setting the PYTHONPATH thru it, then
asking for 'use python' to happen, catch the result.
 
> Now I'm thinking of making it build-time test so that it can be executed
> by make when specific argument is given - e.g. make C=1 ?

I think there is room for a 'make -C tools/perf check' that would use
the 'expect' tool to do not just this but also run record, report, etc
and check its output against what is expected, perf test is ok for
checking the APIs, but we need a test suite for the actual builtins as
called from the command line.

- Arnaldo

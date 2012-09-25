Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab2IYOKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:10:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab2IYOKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:10:52 -0400
Date: Tue, 25 Sep 2012 11:10:17 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Feng Tang <feng.tang@intel.com>, mingo@elte.hu, a.p.zijlstra@chello.nl,
        andi@firstfloor.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: perf tools regression testing was Re: [PATCH v3 1/9] perf hists:
 Move hists_init() from util/evsel.c to util/hist.c
Message-ID: <20120925141017.GD2892@infradead.org>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
 <1348500251-9937-2-git-send-email-feng.tang@intel.com>
 <20120924160239.GD9977@infradead.org>
 <87pq5ayjuu.fsf@sejong.aot.lge.com>
 <20120925110519.GA28902@infradead.org>
 <1348577942.1877.32.camel@leonhard>
 <20120925133015.GA2892@infradead.org>
 <1348580868.1877.43.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1348580868.1877.43.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 25, 2012 at 10:47:48PM +0900, Namhyung Kim escreveu:
> 2012-09-25 (화), 10:30 -0300, Arnaldo Carvalho de Melo:
> > Em Tue, Sep 25, 2012 at 09:59:02PM +0900, Namhyung Kim escreveu:
> > > Now I'm thinking of making it build-time test so that it can be executed
> > > by make when specific argument is given - e.g. make C=1 ?

> > I think there is room for a 'make -C tools/perf check' that would use
> > the 'expect' tool to do not just this but also run record, report, etc
> > and check its output against what is expected, perf test is ok for
> > checking the APIs, but we need a test suite for the actual builtins as
> > called from the command line.

> Hmm.. we have 'make check' but running it ended up tons of macro
> redefinition and unknown attribute warnings from sparse. :/

Ok, then 'make test', that would run 'perf test' + the expect like
tests.

I'm trying to figure out if http://www.noah.org/python/pexpect/ is a
better choice, that way we don't have to learn yet another scripting
language.

- Arnaldo

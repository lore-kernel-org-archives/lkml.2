Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab2IYM7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:59:11 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:59535 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab2IYM7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:59:09 -0400
Subject: Re: [PATCH v3 1/9] perf hists: Move hists_init() from util/evsel.c
 to util/hist.c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Feng Tang <feng.tang@intel.com>, mingo@elte.hu, a.p.zijlstra@chello.nl,
        andi@firstfloor.org, dsahern@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20120925110519.GA28902@infradead.org>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
	 <1348500251-9937-2-git-send-email-feng.tang@intel.com>
	 <20120924160239.GD9977@infradead.org> <87pq5ayjuu.fsf@sejong.aot.lge.com>
	 <20120925110519.GA28902@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Sep 2012 21:59:02 +0900
Message-ID: <1348577942.1877.32.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-09-25 (화), 08:05 -0300, Arnaldo Carvalho de Melo:
> Em Tue, Sep 25, 2012 at 10:25:13AM +0900, Namhyung Kim escreveu:
> > On Mon, 24 Sep 2012 13:02:39 -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Mon, Sep 24, 2012 at 11:24:03PM +0800, Feng Tang escreveu:
> > >> Which looks more natural
> > >
> > > It is there to avoid dragging the hist code into the python binding :-\
> > 
> > Hmm... it's so hairy.  Can't we do better?
> 
> We always can do better :-)
> 
> I just stated why it was at that place.
> 
> When doing refactorings we're all the time trying to make it better in
> many senses, one of them is trying to isolate code that is useful in a
> general way and thus should be made available via a library/scripting
> binding.

Yeah, but the isolation sometimes got broken as code getting added like
this.  So we need a automatic way of detecting breakage.

I thought about adding a perf test entry running python/twatch.py, but
it will not work for an installed perf binary since it cannot find the
twatch.py script and perf.so extension files which are not installed.

Now I'm thinking of making it build-time test so that it can be executed
by make when specific argument is given - e.g. make C=1 ?

Thanks
Namhyung



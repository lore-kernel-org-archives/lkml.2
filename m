Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab1EXPkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:40:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38425 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab1EXPkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:40:36 -0400
Date: Tue, 24 May 2011 17:40:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, linux-kernel@vger.kernel.org,
        fbuihuu@gmail.com, paulus@samba.org, acme@redhat.com
Subject: Re: perf: regression with PERF_EVENT_IOC_REFRESH
Message-ID: <20110524154020.GA26516@elte.hu>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>
 <1306182141.2497.5.camel@laptop>
 <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>
 <1306233036.2497.15.camel@laptop>
 <alpine.DEB.2.00.1105241041490.10575@cl320.eecs.utk.edu>
 <1306249830.18455.41.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306249830.18455.41.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2011-05-24 at 11:04 -0400, Vince Weaver wrote:
>
> > 2.6.37, 2.6.38, or 2.6.39 then it would be silly to do it just for
> > 2.6.40.

No, this commit was added in v2.6.38 so v2.6.37 should be fine.

> Oh, I assumed it was recent and .39/.40 would suffice.

Btw., how did it happen that the PAPI tests did not get run against upstream 
over the course of about half a year, two full stable kernels released:

 Date:   Mon Mar 14 18:20:32 2011 -0700    Linux 2.6.38
 Date:   Wed May 18 21:06:34 2011 -0700    Linux 2.6.39

?

I'd suggest periodically running the PAPI tests on the perf development tree:

  http://people.redhat.com/mingo/tip.git/README

doing that would have caught this problem 6 months ago.

The upstream policy is that regressions are generally recognized before the 
next kernel gets released: i.e. in the stabilization period after -rc1, the 
roughly two months until the final kernel gets released. That is the window 
when we can still fix regressions relatively cheaply.

Yes, there are exceptions, but if a piece of user-space code did not get tested 
with upstream over months and months then that moves into the 'fix it if we 
can' category - not a regression per se.

So the upstream message is: we can only care about you if you care testing 
upstream.

So if it's easy to fix we can certainly fix this bug and mark it for a -stable 
backport, but this is not a regression that got reported to us in any timely 
manner.

Btw., to get such assumptions tested more frequently than twice a year i'd 
suggest moving these usecases into 'perf test' or so - that it gets run every 
day:

 $ perf test
 1: vmlinux symtab matches kallsyms: FAILED!

 2: detect open syscall event: Ok
 3: detect open syscall event on all cpus: Ok
 4: read samples using the mmap interface: Ok

Thanks,

	Ingo

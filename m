Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab2CIHgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 02:36:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53745 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab2CIHgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 02:36:45 -0500
Date: Fri, 9 Mar 2012 08:36:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Arun Sharma <asharma@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        robert.richter@amd.com, ming.m.lin@intel.com, vweaver1@eecs.utk.edu,
        andi@firstfloor.org
Subject: Re: [RFC] perf report: Implement symbol filtering on TUI
Message-ID: <20120309073619.GB15570@elte.hu>
References: <20120306062546.GA622@elte.hu>
 <1331085470-32594-1-git-send-email-namhyung.kim@lge.com>
 <20120307060724.GA4241@elte.hu>
 <4F5716A2.6070804@lge.com>
 <20120308104432.GB25949@elte.hu>
 <4F59629E.6090909@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F59629E.6090909@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung.kim@lge.com> wrote:

> >  - unknown symbols are not matched, and thus they will show up
> >    indiscrimnately even though I only want to see them if the
> >   filter is something like '0x' or 'unknown'.
> >
> 
> Since they have no symbol. :) In the current implementation, 
> it will actually show you such symbols if you enter '0x' or 
> 'unknown' as a filter unless there're symbols that have those 
> letters in its name.
> 
> I can think of 3 solutions for this now:
> 
> 1. Adding a special filter keyword (like 'unknown'). But there's
> probably some symbols which have those letters.
> 
> 2. If filter string consists of (hex-) digits only, it will only
> show hist entries doesn't have symbols, or tries to match based on
> its ip.
> 
> 3. Implement zooming-in to "unknown" dso. Maybe it's a different
> issue, but I think it's good to have and it'll helps this too.
> 
> What do you guys think?

Well, the main problem I had was that they showed up in the 
'perf report sched' filtered output and messed it up.

I.e. I'm not interested in unknown symbols much, I'm interested 
in *not* seeing them when I type 'perf report sched'.

Thanks,

	Ingo

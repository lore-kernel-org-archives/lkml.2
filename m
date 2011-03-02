Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab1CBItl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:49:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60168 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab1CBItk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:49:40 -0500
Date: Wed, 2 Mar 2011 09:49:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf: Set filters before mmaping events
Message-ID: <20110302084925.GA21204@elte.hu>
References: <1298693021-23500-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298693021-23500-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> We currently set the filters after we mmap the events, this is a
> race that let undesired events record themselves in the buffer before
> we had the time to set the filters.
> 
> So set the filters before they can be recorded. That also librarizes
> the filters setting so that filtering can be done more easily
> from other tools than perf record later.
> 
> (PS: This should fix most of the bugs Ingo has reported
> about filters that weren't working with perf).

Nice!

Mind pulling Steve's filter-enhancements branch and sending a pull request for the 
whole thing? Steve's branch was:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git tip/perf/filter

( Or your fixes could be applied to Steve's branch as well - whichever direction you 
  guys prefer - the important thing is to have filtering tested and validated as a 
  whole. )

Thanks,

	Ingo

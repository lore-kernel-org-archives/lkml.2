Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485Ab1D0Q1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:27:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35828 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759454Ab1D0Q1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:27:37 -0400
Date: Wed, 27 Apr 2011 18:27:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arun Sharma <arun@sharma-home.net>
Cc: Arun Sharma <asharma@fb.com>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] perf events: Add stalled cycles generic event -
 PERF_COUNT_HW_STALLED_CYCLES
Message-ID: <20110427162711.GA29460@elte.hu>
References: <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
 <20110422203022.GA20573@elte.hu>
 <20110423201409.GA20072@elte.hu>
 <20110424061645.GA12013@radium.snc4.facebook.com>
 <20110427111141.GB28993@elte.hu>
 <BANLkTimz-KevvqmxxUPp73GEaAC5PTGWWw@mail.gmail.com>
 <20110427154805.GB23494@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110427154805.GB23494@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > [...] why not pick cycles where no uops are retiring?
> > 
> > cycles_no_uops_retired = cycles - c["UOPS_RETIRED:ANY:c=1:t=1"]
> >
> > In the presence of C-states and some halted cycles, I found that I couldn't 
> > measure it via UOPS_RETIRED:ANY:c=1:i=1 because it counts halted cycles too 
> > and could be greater than (unhalted) cycles.
> 
> Agreed, good point.
> 
> You are right that it is more robust to pick 'the CPU was busy on our behalf' 
> metric instead of a 'CPU is idle' metric, because that way 'HLT' as a special 
> type of idling around does not have to be identified.

Sidenote, there's one advantage of the idle event: it's more meaningful to 
profile idle cycles - and it's easy to ignore the HLT loop in the profile 
output (we already do).

That way we get a 'hidden overhead' profile: a profile of frequently executed 
code which executes in the CPU in a suboptimal way.

So we should probably offer both events.

Thanks,

	Ingo

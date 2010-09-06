Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab0IFMlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:41:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40867 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab0IFMlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:41:00 -0400
Date: Mon, 6 Sep 2010 14:40:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100906124046.GA20777@elte.hu>
References: <4C84B088.5050003@redhat.com>
 <1283772256.1930.303.camel@laptop>
 <4C84D1CE.3070205@redhat.com>
 <1283774045.1930.341.camel@laptop>
 <4C84D77B.6040600@redhat.com>
 <1283776189.1930.380.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283776189.1930.380.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4568]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2010-09-06 at 14:58 +0300, Avi Kivity wrote:
> > On 09/06/2010 02:54 PM, Peter Zijlstra wrote:
> > >
> > >> Basically, to read() all events in one go.  I have many of them.
> > >>
> > >> My current problem is that I have an event (kvm_exit) which I want to
> > >> drill down by looking at a field (exit_reason).  So I create lots of
> > >> separate perf_events with a filter for each reason:
> > >> kvm_exit(exit_reason==0), kvm_exit(exit_reason==1), etc.  But filters
> > >> are fairly slow (can have ~60 such events on AMD), so I want to make
> > >> this drill-down optional.
> > > Yeah, filters suck.
> > 
> > Any idea why?  I saw nothing obvious in the code, except that there 
> > is lots of it.
> 
> It filters after it does all the hard work of creating the trace 
> event, instead of before.

Btw., that's an implementational property of filters that would be nice 
to fix.

If it's not doable within CPP then outside of it.

	Ingo

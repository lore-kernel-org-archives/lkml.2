Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab1JJFYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 01:24:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54666 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab1JJFYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 01:24:41 -0400
Date: Mon, 10 Oct 2011 07:22:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        acme@redhat.com, eric.dumazet@gmail.com, a.p.zijlstra@chello.nl,
        paulus@samba.org, linux-kernel@vger.kernel.org, nhorman@tuxdriver.com
Subject: Re: [PATCHv2 1/2] perf tools: Collect tracing event data files
 directly
Message-ID: <20111010052259.GC32173@elte.hu>
References: <20110925133406.GB2702@jolsa.brq.redhat.com>
 <1317028312-5156-1-git-send-email-jolsa@redhat.com>
 <1317028312-5156-2-git-send-email-jolsa@redhat.com>
 <1317044192.26514.1.camel@gandalf.stny.rr.com>
 <20110926145606.GA8886@jolsa.brq.redhat.com>
 <20110928135525.GS18553@somewhere>
 <1317218589.4588.4.camel@gandalf.stny.rr.com>
 <20110928141754.GT18553@somewhere>
 <20110928165639.GA10084@elte.hu>
 <1317229825.4588.12.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317229825.4588.12.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Good to see your email is back :)
> 
> 
> On Wed, 2011-09-28 at 18:56 +0200, Ingo Molnar wrote:
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > > > But it seems Steve's patches are not completely uncontroversial 
> > > > > because of some crazy disagreements on where the 
> > > > > libparsevent.so should lay (tools generic or tied to perf).
> > > > 
> > > > Which to me seems to be a silly road block, in which I never got 
> > > > a clear answer for.
> > > 
> > > Yeah we need to sort that out with Ingo.
> > 
> > Basically, since it's not at all clear to me where these things (and 
> > APIs) will go, I'd be much more comfortable with this starting out as 
> > tools/perf/lib/ - we can still split it out later on. Merging it in 
> > will be a lot harder.
> 
> I would actually argue that merging is much easier than splitting 
> something up. [...]

Technically it's somewhat easier - socially, not.

> [...] If A depends on B, merging B back into A is trivial. But if B 
> is a part of A, breaking it out of A is a much more difficult task, 
> as the boundaries of A and B are not so easy to find and the 
> coupling of the two is much tighter.

That's a technical problem. In reality we can split up and merge 
projects of very significant size just fine. I've done split-ups and 
factorings-out from millions of lines of code impact. tools/perf is 
still well within such size boundaries.

> I find trying to break things out of perf is very hard to do as the 
> dependencies are throughout all of perf, and no one seems to agree 
> on how to do so.

Then it would be absolute madness to make that non-agreement external 
and hard-code a separate social structure for it!

Libraries are for *boring* infrastructure stuff *everyone agrees on*. 

They are absolutely lousy arbitrators of technical disagreement and 
if there's a serious disagreement they can easily become an absolute 
nightmare socially and a technical distraction. How difficult is this 
to understand?

Please work out disagreements with Arnaldo and do librarization 
within perf if you are interested in that angle. If those internal 
interfaces become visibly boring and are consistently used by 
everything in a way that every main contributor agrees on then we can 
perhaps librarize it. Not the other way around.

Thanks,

	Ingo

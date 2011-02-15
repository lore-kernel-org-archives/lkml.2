Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab1BOSmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 13:42:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43703 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab1BOSmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 13:42:36 -0500
Date: Tue, 15 Feb 2011 19:42:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/14] [GIT PULL][v2.6.39] tracing/filter: More robust
 filtering
Message-ID: <20110215184200.GA7335@elte.hu>
References: <20110208015617.902200587@goodmis.org>
 <20110215044425.GA9994@elte.hu>
 <1297776787.23343.104.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297776787.23343.104.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 2011-02-15 at 05:44 +0100, Ingo Molnar wrote:

> > So ... i have to say that this tracing filter business is unusable crap from a 
> > user POV right now and i see no reason to pull *anything* in this area until it 
> > does not get improved to *much* better levels of usability and utility.
> > 
> > Nobody could *ever* have tested this with a 'naive but curious user' hat on and 
> > this is really sad. We need to do much better!
> 
> Sorry I did not work with perf in writing this code. I was using the debugfs 
> directly. I figured that any improvement I made there would also improve perf as I 
> tried to make sure the perf hooks into that code were updated too.
> 
> My question is, did this patch set cause any of the perf problems or did these 
> problems always exist?
> 
> I'm just saying that perf is not the only user. And to deny improvements in the 
> code because one user does not currently work well with them is just hindering 
> progress.
> 
> There happens to be real users out in the world that are still using ftrace. I see 
> no reason to stop improving it because your goal is to have everyone move to perf.
> 
> Thanks for letting me waste three days on developing this. I even posted an RFC a 
> while back, and no one complained then.

I initially pulled your bits with the intention of merging them, tested them as the 
final line of defense, gave you my feedback in my mail in a very detailed way, with 
suggestions of what to improve.

A few lines I would normally not worry about, but I refuse to pull such a massive 
diffstat:

 3 files changed, 754 insertions(+), 170 deletions(-)

That ignores a major usecase. I do not pull bits that are arcane to begin with which 
improve something that we don't even know whether it works in all cases - in fact 
which we know does not work at all in a major usecase, as my testing has shown.

My point is that you guys need to work this out with the 'other side' *before* it 
goes upstream. The tracing and perf code needs to stop doing this kind of 
self-serving improvements *when basic utility sucks so much*.

And yes, it sucks both on the perf and the ftrace tracing 'side' - in no small part 
because there's two sides.

We had huge churn in the tracing code in the last 2 years and frankly i do not see 
the results and i do not see it getting cleaned up and i do not see it getting 
unified.

I find this kind of 'the other side does not exist' schizm quite harmful to the 
'generic' code in question and am pushing back on you, as i'm expected to. I don't 
care whether it's "perf's fault" or "ftrace's fault" - i find the whole artificial 
division harmful and refuse to elongate/deepen it.

Anyway, there's certainly encouraging responses in this thread so i'm hopeful that 
it's getting fixed and improved and we can push the generic bits upstream.

Thanks,

	Ingo

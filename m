Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1JJM1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:27:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38864 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab1JJM1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:27:38 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=v1jNb7L17ooA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=meVymXHHAAAA:8 a=uRb3wp1THKNcSiCodt4A:9 a=2G4js5DK3El1pXYl-hcA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCHv2 1/2] perf tools: Collect tracing event data files
 directly
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        acme@redhat.com, eric.dumazet@gmail.com, a.p.zijlstra@chello.nl,
        paulus@samba.org, linux-kernel@vger.kernel.org, nhorman@tuxdriver.com
Date: Mon, 10 Oct 2011 08:27:34 -0400
In-Reply-To: <20111010052259.GC32173@elte.hu>
References: <20110925133406.GB2702@jolsa.brq.redhat.com>
	 <1317028312-5156-1-git-send-email-jolsa@redhat.com>
	 <1317028312-5156-2-git-send-email-jolsa@redhat.com>
	 <1317044192.26514.1.camel@gandalf.stny.rr.com>
	 <20110926145606.GA8886@jolsa.brq.redhat.com>
	 <20110928135525.GS18553@somewhere>
	 <1317218589.4588.4.camel@gandalf.stny.rr.com>
	 <20110928141754.GT18553@somewhere> <20110928165639.GA10084@elte.hu>
	 <1317229825.4588.12.camel@gandalf.stny.rr.com>
	 <20111010052259.GC32173@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318249656.7904.66.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 07:22 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>  
> > I would actually argue that merging is much easier than splitting 
> > something up. [...]
> 
> Technically it's somewhat easier - socially, not.

I'm trying to keep this on a technical level.

> 
> > [...] If A depends on B, merging B back into A is trivial. But if B 
> > is a part of A, breaking it out of A is a much more difficult task, 
> > as the boundaries of A and B are not so easy to find and the 
> > coupling of the two is much tighter.
> 
> That's a technical problem. In reality we can split up and merge 
> projects of very significant size just fine. I've done split-ups and 
> factorings-out from millions of lines of code impact. tools/perf is 
> still well within such size boundaries.

I find splitting perf up is not so easy. Perhaps if you do it so well
then you could help.

> 
> > I find trying to break things out of perf is very hard to do as the 
> > dependencies are throughout all of perf, and no one seems to agree 
> > on how to do so.
> 
> Then it would be absolute madness to make that non-agreement external 
> and hard-code a separate social structure for it!

I seem to agree with Arnaldo, Boris and Frederic, but you do not seem to
agree. My arguments with Arnaldo started with "but Ingo wants it this
way", his reply was, "What do you want". Honestly, I agreed with
Arnaldo.

> 
> Libraries are for *boring* infrastructure stuff *everyone agrees on*. 


But what I have proposed is something that we all agreed on (besides
you) that it *is* boring infrastructure stuff. Hell, the code never was
developed for perf in the first place. Frederic pulled it in from
trace-cmd. The update code currently lives in trace-cmd as a separate
library, that was designed to work with any other project (including
perf). You want me to rip it apart to make it a perf only lib?

Currently perf has an old outdated version, because it never was
incorporated into perf as a library. If it was, then it could have
easily benefited by the updates. A lot of people want perf to have the
functionality that trace-cmd currently has. But because we are fighting
over where the library will be, perf is still suffering.


> 
> They are absolutely lousy arbitrators of technical disagreement and 
> if there's a serious disagreement they can easily become an absolute 
> nightmare socially and a technical distraction. How difficult is this 
> to understand?

Must be very difficult to understand, because I do not understand why a
library that can work with multiple tools (perf, powertop, latencytrace,
trace-cmd, kernelshark) needs to be in tools/perf/lib instead of
tools/lib?


> 
> Please work out disagreements with Arnaldo and do librarization 
> within perf if you are interested in that angle. If those internal 
> interfaces become visibly boring and are consistently used by 
> everything in a way that every main contributor agrees on then we can 
> perhaps librarize it. Not the other way around.

For parsing of events, which is what I proposed, it seems to be boring
technical stuff that has been well established by the limitations of the
ABI forced on the debugfs system. It's already over a year old and used
by several developers. One nice feature to come with this is the ability
to add plugins to parse the trace events without needing to read all the
format files. Things like kvm events will suddenly work.

The one disagreement that we are still sorting out is just the name of
the library. I first said libperf (which would make sense to have in
tools/perf/lib) but then it wasn't doing perf specific work. It was just
a way to parse kernel trace points. Nobody seemed to like libparsevent.
I think one of the names that makes sense is libtrace, or libktrace as
it has to do with tracepoints in the kernel. Maybe just libktracepoint?
But that's quite an ugly name.


-- Steve



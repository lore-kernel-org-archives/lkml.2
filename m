Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab2DYMjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:39:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46036 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2DYMjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:39:07 -0400
Date: Wed, 25 Apr 2012 14:39:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: Our failure on tracing tools unification (Was: Re: [RFC][PATCH
 00/15] tools: Unify perf and trace-cmd trace event format parsing v2)
Message-ID: <20120425123858.GF8626@somewhere>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
 <20120423144743.GB29985@somewhere>
 <1335193719.28150.171.camel@twins>
 <20120425080525.GA32613@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425080525.GA32613@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 10:05:25AM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, 2012-04-23 at 16:47 +0200, Frederic Weisbecker wrote:
> > > Ingo doesn't seem to want this library outside perf in order to avoid
> > > the fragmentation of the efforts on tracing tools.
> > 
> > I really don't see the point.. parsing 
> > /debug/tracing/events/*/format gunk really is separate, 
> > furthermore things like powertop et al already are separate 
> > projects and really need this lib.
> > 
> > I mean, who gives a bother where all that crap lives, if its 
> > in the kernel tree its all close enough to keep an eye on.. 
> > its not like kernel/events/ and kernel/trace/ are the same 
> > directory.
> > 
> > Ingo, please could you lighten up and let people get stuff 
> > done? Merging the two implementations, wherever the result 
> > lives, is a better situation that two dis-joint 
> > implementations. So either let Frederic work or do it yourself 
> > but don't hand-wave and road-block stuff.
> 
> As long as perf builds it not as a DSO - or has it in 
> tools/perf/libparseevent/ and co-installs the .so together with 
> perf (and it's packaged together) I'm fine with it.

It's a static library (.a) in tools/lib
This way we ensure perf is not going to dynamically link to some
random version. Besides it stays on the kernel tree so the sources
can evolve on the same branch.

The reason why it's on tools/lib is that people don't want to force
tools to depend on perf.

> One thing that would suck is perf being bound by various 
> versions of this library floating out there.

Sure, the fact it's static and is on the kernel tree prevents
from that.

> One reason why perf has become so popular is that it's 
> self-sufficient to a large degree and is very easy to 
> build/install. Lets not kill that aspect by the death of a 
> thousand cuts.

Agreed. The perf makefile just relays on tools/lib so the dependency
stays on the same tree and stays static so this is transparent to the
user that doesn't need to juggle with dependencies.

> 
> We had nothing but pain from external libraries so far, and 
> there's a reason why the Git project (3+ times larger than perf) 
> avoids library dependencies like the plague...
> 
> Anyway, Frederic, mind posting a version that does the above, so 
> I can have a look at how it all works in practice?

Ok I just rebased against latest perf/core updates and posted to
you. I also pushed it to some branch in my tree (see cover letter)

Thanks!

> 
> Thanks,
> 
> 	Ingo

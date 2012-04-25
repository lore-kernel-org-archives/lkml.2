Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2DYIFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:05:41 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45944 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2DYIFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:05:31 -0400
Date: Wed, 25 Apr 2012 10:05:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <20120425080525.GA32613@gmail.com>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
 <20120423144743.GB29985@somewhere>
 <1335193719.28150.171.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335193719.28150.171.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2012-04-23 at 16:47 +0200, Frederic Weisbecker wrote:
> > Ingo doesn't seem to want this library outside perf in order to avoid
> > the fragmentation of the efforts on tracing tools.
> 
> I really don't see the point.. parsing 
> /debug/tracing/events/*/format gunk really is separate, 
> furthermore things like powertop et al already are separate 
> projects and really need this lib.
> 
> I mean, who gives a bother where all that crap lives, if its 
> in the kernel tree its all close enough to keep an eye on.. 
> its not like kernel/events/ and kernel/trace/ are the same 
> directory.
> 
> Ingo, please could you lighten up and let people get stuff 
> done? Merging the two implementations, wherever the result 
> lives, is a better situation that two dis-joint 
> implementations. So either let Frederic work or do it yourself 
> but don't hand-wave and road-block stuff.

As long as perf builds it not as a DSO - or has it in 
tools/perf/libparseevent/ and co-installs the .so together with 
perf (and it's packaged together) I'm fine with it.

One thing that would suck is perf being bound by various 
versions of this library floating out there.

One reason why perf has become so popular is that it's 
self-sufficient to a large degree and is very easy to 
build/install. Lets not kill that aspect by the death of a 
thousand cuts.

We had nothing but pain from external libraries so far, and 
there's a reason why the Git project (3+ times larger than perf) 
avoids library dependencies like the plague...

Anyway, Frederic, mind posting a version that does the above, so 
I can have a look at how it all works in practice?

Thanks,

	Ingo

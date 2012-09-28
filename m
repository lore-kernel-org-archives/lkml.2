Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416Ab2I1P17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:27:59 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50948 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260Ab2I1P16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:27:58 -0400
Date: Fri, 28 Sep 2012 17:27:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arun Sharma <asharma@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [RFC/PATCHSET 00/15] perf report: Add support to accumulate hist
 periods
Message-ID: <20120928152737.GB14215@somewhere.redhat.com>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
 <87pq5awvgp.fsf@sejong.aot.lge.com>
 <20120927230138.GA10660@somewhere.redhat.com>
 <874nmivgqk.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874nmivgqk.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 02:49:55PM +0900, Namhyung Kim wrote:
> Hi Frederic,
> 
> On Fri, 28 Sep 2012 01:01:48 +0200, Frederic Weisbecker wrote:
> > When Arun was working on this, I asked him to explore if it could make sense to reuse
> > the "-b, --branch-stack"  perf report option. Because after all, this feature is doing
> > about the same than "-b" except it's using callchains instead of full branch tracing.
> > But callchains are branches. Just a limited subset of all branches taken on excecution.
> > So you can probably reuse some interface and even ground code there.
> >
> > What do you think?
> 
> Umm.. first of all, I'm not familiar with the branch stack thing.  It's
> intel-specific, right?
> 
> Also I don't understand what exactly you want here.  What kind of
> interface did you say?  Can you elaborate it bit more?

Look at commit b50311dc2ac1c04ad19163c2359910b25e16caf6
"perf report: Add support for taken branch sampling". It's doing almost
the same than you do, just using PERF_SAMPLE_BRANCH_STACK instead of
callchains.

> And AFAIK branch stack can collect much more branch information than
> just callstacks.

That's not a problem. Callchains are just a high-level filtered source of
branch samples. You don't need full branches to use "-b". Just use the flavour
of branch samples you want to make the sense you want on your branch sampling.

> Can we differentiate which is which easily?

Sure. If you have both sources in your perf.data (PERF_SAMPLE_BRANCH_STACK and
callchains), ask the user which one he wants. Otherwise defaults to what's there.

> Is there
> any limitation on using it?  What if callstacks are not sync'ed with
> branch stacks - is it possible though?

It' better to make both sources mutually exclusive. Otherwise it's going
to be over-complicated.

> 
> But I think it'd be good if the branch stack can be changed to call
> stack in general.  Did you mean this?

That's a different. We might be able to post-process branch tracing and
build a callchain on top of it (following calls and ret). May be we will
one day. But they are different issues altogether.

Thanks.

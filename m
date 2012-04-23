Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab2DWOry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 10:47:54 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:34890 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2DWOrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 10:47:53 -0400
Date: Mon, 23 Apr 2012 16:47:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>
Subject: Our failure on tracing tools unification (Was: Re: [RFC][PATCH
 00/15] tools: Unify perf and trace-cmd trace event format parsing v2)
Message-ID: <20120423144743.GB29985@somewhere>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 12:47:51AM +0200, Frederic Weisbecker wrote:
> 
> Hi,
> 
> So this is a new iteration of the libtracevent library, basically a
> rebase of https://lkml.org/lkml/2011/8/5/299 against latest progresses
> (latest tip/perf/core + tip/perf/urgent).
> 
> This library unifies the trace events parsing code between perf and
> trace-cmd. I initially took this parsing code from trace-cmd to make
> perf able to display trace-events and play with their contents.
> 
> But there is a continuous drift between perf and trace-cmd trace event
> parsing code since then because the fork I did and the original code in
> trace-cmd have never merged into a common entity. As a result, perf
> stays backward because we haven't ported all the progresses that
> trace-cmd did in this area.
> 
> Considering the reactions after the last attempt, it appears the
> unification of this code is uncontroversial. What seem to cause 
> problems is how we do it:
> 
> - as an internal library inside perf, where other tools can hook
> - as a self-contained library in tools/lib, independant from perf
> 
> The argument for the first solution was that trace events format
> is not mature enough to be available for any tool and thus it's too
> early to release a library that would engrave into the stone an
> interface to it, preventing the events format from evolving in the
> future.
> 
> However users of trace events are there already and they all use
> their own parsing. They sometimes wrongly rely on the stability of a
> whole event layout or its ascii structure. The lack of a common and
> independant library is eventually what prevents us from doing progresses
> or make evolutions on trace events.
> 
> So I think we really need to restart the debate. We strongly need to make
> progresses in this area so I'm posting this iteration in the hope we
> can move forward. With the coming of uprobes, there are some chances
> that our tracing becomes more important in the future. Let's join
> our efforts.

I'm trying to summarize some conversations that I got outside the mailing
list (and I truly regret because it should have been debated publicly).

Ingo doesn't seem to want this library outside perf in order to avoid
the fragmentation of the efforts on tracing tools.

We indeed want to unify our tools, like merging trace-cmd into perf.
And after talking with Steve about that, he told me he wants to have
both tools unified as well. But he wants to keep libparseevent as
a generic standalone library.

Indeed, it makes it possible for those who want to use trace events
on their own tools to do it properly. I believe powertop fits into
this scheme. Trace events are a generally useful feature. I wish
we gather our efforts on one tool like perf but I don't want to force
everyone to this path. So I personally agree with that library
to be standalone.

Thus I think we are stuck again.

Now libtraceevent is perhaps going to become a separate project. I don't
know.

By backporting and sending this libparsevent patch series, I felt pretty
eager in that we could make a great step toward the tracing code unification.

But now with the current state of the picture, I'm worried about
the future of tracing in perf tools. I don't want to spend my time to backport
the features of the parse event code because I refuse to hack around
politics disagreements. So probably the current code is going to rot. Unless
somebody wants to handle this unpleasant task.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab1LNQeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:34:15 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56328 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab1LNQeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:34:14 -0500
Date: Wed, 14 Dec 2011 17:34:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [PATCH 2/2] trace,x86: Add x86 irq vector entry/exit tracepoints
Message-ID: <20111214163407.GE10791@somewhere.redhat.com>
References: <1311983978-10350-1-git-send-email-vnagarnaik@google.com>
 <1311983978-10350-3-git-send-email-vnagarnaik@google.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C57EE47BC@USINDEVS01.corp.hds.com>
 <20111213192556.GD2421@somewhere.redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C57F7A6D7@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C57F7A6D7@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 10:09:11AM -0500, Seiji Aguchi wrote:
> Thank you for giving me a comment.
> Unfortunately, neither "perf record" nor "ftrace" works for me.
> 
> >What about using perf for that?
> >
> >Just run:
> >
> >	perf record -ag
> >	^C
> >	perf report
> >
> >And you should find in the callchains some informations about where your CPUs
> >are spending time.
> >
> >If you system is too slow for that 
> 
> When system is too slow, user command such as "perf record" may not work.
> 
> >but you're doing background tracing with
> >ftrace, you can use stacktrace with ftrace.
> 
> Actually, We're doing background tracing in our customer's system rather than kernel debugging. 
> Ftrace doesn't work for me because it checks the size of the stack at every function call.
> Our customers are seriously concerned about its overhead.
> 
> For reducing the overhead, I need tracepoints so we can hook minimal function calls.

Well ftrace is a whole subsystem that includes the function tracer and also an interface
for tracepoints in debugfs. I was rather suggesting the latter one. This is a good
choice for background tracing. And it supports stacktraces. If those generate too much
overhead perhaps you can tune the number of entries in the stacktrace, I don't remember
if we can do that currently but this can be an interesting feature.

What are you using currently for the background tracing?

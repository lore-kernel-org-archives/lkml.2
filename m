Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751029Ab2FOESm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 00:18:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27913 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2FOESl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 00:18:41 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=G0s97Kyuy1EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=6tMNxHDDvYhHf27NXjwA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339733919.13377.328.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing: Fix the outmost stupidity of tracing_off()
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Fri, 15 Jun 2012 00:18:39 -0400
In-Reply-To: <1339717703.13377.285.camel@gandalf.stny.rr.com>
References: <alpine.LFD.2.02.1206142345100.3086@ionos>
	 <1339714725.13377.252.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1206150106511.3086@ionos>
	 <1339717703.13377.285.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 19:48 -0400, Steven Rostedt wrote:

> I have several branches that I work on and when they are ready, I rebase
> them on top of tip, run a bunch of tests, and then push them out.

One more thing. I do run specific tests during development aimed at the
changes I make. I may rebase on top of tip afterward, run generic tests,
and then push out. These activities are not always done right after each
other. I probably screwed up by either cherry-picking or rebasing a
separate branch, noticing the bug (I remember fixing it before) but then
get side-tracked, and use the original branch that didn't have the fix.
Or it could have simply gotten reverted with a git reset --hard, where I
forgot to do the --amend. For testing something like this, I would have
added tracing_off() in the code, and I do reset --hard to remove my
testing code. If I made the fix and forgot to --amend it, the fix was
lost.

Anyway, I added to my generic tests: testing
 'echo schedule:traceon > set_ftrace_filter' as well as
 'echo schedule:traceoff > set_ftrace_filter' and make sure that they do
enable and disable tracing.

The traceon and traceoff triggers use tracing_on() and tracing_off()
underneath the covers. If they break, the test will fail (I tested the
broken patch and it does fail). This regression wont appear again.

Since the last time you've yelled at me, I've added a lot of stress
tests to ftrace. I test the tracing_on file to make sure it enables and
disables. But my generic tests did not include the internal
tracing_off() testing. My mistake, and yes I screwed up.

-- Steve



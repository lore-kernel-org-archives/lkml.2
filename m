Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab0JSSNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:13:10 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:51352 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751531Ab0JSSNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:13:09 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX190x8NKuQh0k1+ktL5jL9x60GXbXYWIZ1/HRTI3Gq
	MDzoUhmP4LZCGZ
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287487757.24189.40.camel@marge.simson.net>
	 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 19 Oct 2010 20:13:03 +0200
Message-Id: <1287511983.7417.45.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 08:28 -0700, Linus Torvalds wrote:
> On Tue, Oct 19, 2010 at 4:29 AM, Mike Galbraith <efault@gmx.de> wrote:

> So I think the patch looks pretty good, and the numbers seem to look
> just stunningly so, but I'd like to name the feature more along the
> lines of "automatic process group scheduling" rather than about tty's
> per se.

Oh, absolutely, that's what it's all about really.  What I'd _like_ is
to get per process group scheduling working on the cheap..ish.  Your
idea of tty cgoups looked much simpler though, so I figured that would
be a great place to start.  It turned out to be much simpler than I
thought it would be, which is encouraging, and it works well in testing
(so far that is).

> And you actually did that for the Kconfig option, which makes me quite happy.

(Ingo's input.. spot on)

> The one other thing I do wonder about is how noticeable the group
> scheduling overhead is.

Very noticeable, cgroups is far from free.  It would make no sense for a
performance freak to even think about it.  I don't run cgroup enabled
kernels usually, and generally strip to the bone because I favor
throughput very very heavily, but when I look at the desktop under load,
the cost/performance trade-off ~seems to work out.

>  If people compare with a non-CGROUP_SCHED
> kernel, will a desktop-optimized kernel suddenly have horrible pipe
> latency due to much higher scheduling cost? Right now that whole
> feature is hidden by EXPERIMENTAL, I don't know how much it hurts, and
> I never timed it when I tried it out long ago..

The scheduling cost is quite high.  But realistically, the cost of a
distro kernel with full featured network stack is (much) higher.  I
seriously doubt the cost of cgroups would be noticed by the typical
_desktop_ user.  Overall latencies for any switchy microbenchmark will
certainly be considerably higher with the feature enabled.

	-Mike


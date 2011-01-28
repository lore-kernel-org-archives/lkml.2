Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab1A1Sgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 13:36:55 -0500
Received: from mail.openrapids.net ([64.15.138.104]:57772 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753199Ab1A1Sgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 13:36:54 -0500
Date: Fri, 28 Jan 2011 13:36:50 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, roland@redhat.com, oleg@redhat.com,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET] ptrace,signal: group stop / ptrace updates
Message-ID: <20110128183650.GA26633@Krystal>
References: <1296227324-25295-1-git-send-email-tj@kernel.org> <20110128165455.GA18194@elte.hu> <alpine.LFD.2.00.1101281839390.31804@localhost6.localdomain6> <AANLkTinm53a1BzLu6JCBdgOpkHw9MOg2H4gD7xiRyvOh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinm53a1BzLu6JCBdgOpkHw9MOg2H4gD7xiRyvOh@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:29:41 up 65 days, 23:32,  1 user,  load average: 0.19, 0.09,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anca Emanuel (anca.emanuel@gmail.com) wrote:
> On Fri, Jan 28, 2011 at 7:41 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Fri, 28 Jan 2011, Ingo Molnar wrote:
> >> See that '^C^C' line? That is where i had to do Ctrl-C twice.
> >>
> >> It only fails here about once every 10 times, so it's very rare. I have a stock F14
> >> system running on that box, with the very latest .38 based kernel.
> >
> > Tripped over the refuse ^C thing today twice. Had to kill a kernel
> > build from another shell. It just happily displayed ^C and never
> > stopped. That happens once in a while and I have no idea either how to
> > debug that.
> 
> cc: Mathieu
> 
> Use lttng ?

Heh :) I'm sure Ingo and Thomas have their own tools for that ;) There is
one extra thing in the LTTng instrumentation that can help solve this problem:
the "input subsystem" instrumentation (enabled with ltt-armall -i). You can then
get a dump of:

- Your keystrokes (you can then grep for your ctrl-c input)
- Read/poll/select system calls (so you know when your terminal receives the
  input).
- Signals sent/delivered

Some of these are already instrumented in the mainline kernel, so you might get
away without the input subsystem instrumentation.

If I had to take a wild guess, my bet would be to take a look in the area of
signal delivery, but you never know, maybe it's a userspace bug in the X
terminal emulator code that is causing this weirdness.

Hope this helps,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

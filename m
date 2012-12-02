Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab2LBIVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 03:21:15 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:43137 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751802Ab2LBIVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 03:21:14 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX186TMdStzc6qM+Xhuoxf/24QcejHTT42bFrHHb2yS
	bZI+i5hCurRXij
Message-ID: <1354436468.7048.35.camel@marge.simpson.net>
Subject: Re: [RFC GIT PULL] scheduler fix for autogroups
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 02 Dec 2012 09:21:08 +0100
In-Reply-To: <20121201214438.GA6544@gmail.com>
References: <20121201111609.GA18679@gmail.com>
	 <CA+55aFx_yJbonbEC5AYteyNv+qWbG-H=yj_=YaiJHwKyu4FH3Q@mail.gmail.com>
	 <20121201214438.GA6544@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-01 at 22:44 +0100, Ingo Molnar wrote:

> Should we use some other file for that - or no file at all and 
> just emit a bootup printk for kernel hackers with a short 
> attention span?

Or, whack the file and don't bother with a printk either.  If it's in
your config, and your command line doesn't contain noautogroup, it's on,
so the info is already present (until buffer gets full).  That makes for
even fewer lines dedicated to dinky sideline feature.

Or (as previously mentioned) just depreciate (or rip out) the whole
thing since systemd is propagating everywhere anyway, and offers the
same functionality.

For 3.7, a revert of 800d4d30c8f2 would prevent the explosion when folks
play with the now non-functional on/off switch (task groups are required
to _always_ exist, that commit busted the autogroup assumption), so is
perhaps a viable quickfix until autogroups fate is decided?

-Mike


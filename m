Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab1IVOFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 10:05:34 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:58614 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752511Ab1IVOFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 10:05:33 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18lGw53xnQlu8BMjylxaiyNCN/YYqXO9EMi1ENDdp
	X/orpijOCNVMSD
Subject: Re: rt14: strace ->  migrate_disable_atomic imbalance
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>, mingo <mingo@redhat.com>
In-Reply-To: <1316698943.6348.8.camel@marge.simson.net>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
	 <1315835562.6758.3.camel@marge.simson.net>
	 <1315839187.6758.8.camel@marge.simson.net> <1315926499.5977.19.camel@twins>
	 <1315927699.6445.6.camel@marge.simson.net> <1315930430.5977.21.camel@twins>
	 <1316600230.6628.6.camel@marge.simson.net> <1316685640.31429.2.camel@twins>
	 <1316692534.6284.46.camel@marge.simson.net>
	 <1316693391.31429.12.camel@twins>
	 <1316698943.6348.8.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 16:05:27 +0200
Message-ID: <1316700327.4831.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 15:42 +0200, Mike Galbraith wrote:
> On Thu, 2011-09-22 at 14:09 +0200, Peter Zijlstra wrote:
> > On Thu, 2011-09-22 at 13:55 +0200, Mike Galbraith wrote:
> > > On Thu, 2011-09-22 at 12:00 +0200, Peter Zijlstra wrote:
> > > 
> > > > OK, this one seems to be better.. But its quite vile, not sure I
> > > > actually like it anymore.
> > > 
> > > Well, seemed to work, but I see there's a v3 now.
> > 
> > Yeah, just posted it for completeness, not sure its actually going
> > anywhere since its slower than the current code (although its hard to
> > say with the results changing from reboot to reboot), and its still
> > quite ugly..
> 
> Hm. Stracing this proglet will soon leave it stuck forever unless the
> timer is left running.  Virgin rt14 does the same though...
> 
> strace ./jitter -c 3 -p 99 -f 1000 -t 10 -r
> 
> rt_sigtimedwait([], NULL, NULL, 8)      = 64
> timer_settime(0x1, TIMER_ABSTIME, {it_interval={0, 0}, it_value={0, 0}}, NULL) = 0
> timer_settime(0x1, TIMER_ABSTIME, {it_interval={0, 0}, it_value={1316698141, 166759038}}, NULL) = 0
> rt_sigtimedwait([], NULL, NULL, 8)      = 64
> timer_settime(0x1, TIMER_ABSTIME, {it_interval={0, 0}, it_value={0, 0}}, NULL) = 0
> timer_settime(0x1, TIMER_ABSTIME, {it_interval={0, 0}, it_value={1316698141, 167822701}}, NULL) = 0
> rt_sigtimedwait([], NULL, NULL, 8)      = 64
> timer_settime(0x1, TIMER_ABSTIME, {it_interval={0, 0}, it_value={0, 0}}, NULL) = 0
> timer_settime(0x1, TIMER_ABSTIME, {it_interval={0, 0}, it_value={1316698141, 168887375}}, NULL) = 0
> --- SIGRT_32 (Real-time signal 30) @ 0 (0) ---
> rt_sigreturn(0x40)                      = 0
> rt_sigtimedwait([], NULL, NULL, 8^C <unfinished ...>

I thought it was RT specific, but it's not after all, a 3.0.4 distro
desktop (preempt) kernel did the same after a bit.

	-Mike


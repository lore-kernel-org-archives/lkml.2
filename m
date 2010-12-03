Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab0LCGse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 01:48:34 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:39101 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751489Ab0LCGsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 01:48:33 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19NSQl4NXBNRToVvQd70agwt6DCZ4g+hROwRTZUrE
	axW3vDpxqFJi9z
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4CF87C14.8000708@google.com>
References: <20101121133744.GA10765@elte.hu>
	 <1290700829.4759.16.camel@maggy.simson.net>
	 <1290954299.30515.15.camel@marge.simson.net> <4CF5C379.8030204@google.com>
	 <1291184173.7466.147.camel@marge.simson.net>  <4CF87C14.8000708@google.com>
Content-Type: text/plain
Date: Fri, 03 Dec 2010 07:48:29 +0100
Message-Id: <1291358909.4378.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 21:11 -0800, Paul Turner wrote:
> On 11/30/10 22:16, Mike Galbraith wrote:
> > On Tue, 2010-11-30 at 19:39 -0800, Paul Turner wrote:
> >> On 11/28/10 06:24, Mike Galbraith wrote:
> >>>
> >>> Something else is seriously wrong though.  36.1 with attached (plus
> >>> sched, cgroup: Fixup broken cgroup movement) works a treat, whereas
> >>> 37.git and tip with fixlet below both suck rocks.  With a make -j40
> >>> running, wakeup-latency is showing latencies of>100ms, amarok skips,
> >>> mouse lurches badly.. generally horrid.  Something went south.
> >>
> >> I'm looking at this.
> >>
> >> The share:share ratios looked good in static testing, but perhaps we
> >> need a little more wake-up boost to improve interactivity.
> >
> > Yeah, feels like a wakeup issue.  I too did a (brief) static test, and
> > that looked ok.
> >
> > 	-Mike
> >
> 
> Hey Mike,
> 
> Does something like the below help?

Unfortunately not.  For example, Xorg+mplayer needs (30 sec refresh)..

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 6487 root      20   0  366m  30m 5100 S   31  0.4   2:04.83 2 Xorg
 4454 root      20   0  318m  28m  15m S   29  0.4   0:38.06 3 mplayer

..but gets this when a heavy kbuild is running along with them.

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 6487 root      20   0  366m  30m 5136 S   12  0.4   2:25.98 1 Xorg
 5595 root      20   0  318m  28m  15m R    8  0.4   0:09.31 3 mplayer

There are 4 task groups active at this time, Xorg, mplayer, Amarok and
konsole where the kbuild is running make -j40.

	-Mike



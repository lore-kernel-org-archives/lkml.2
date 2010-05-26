Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab0EZU0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:26:48 -0400
Received: from ip-70-38-54-39.static.privatedns.com ([70.38.54.39]:43424 "EHLO
	ginevra.hungrycats.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753232Ab0EZU0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:26:47 -0400
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 May 2010 16:26:46 EDT
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
Date: Wed, 26 May 2010 16:18:20 -0400
From: Zygo Blaxell <vger-linux-omap-esightcorp@mailtoo.hungrycats.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>, felipe.balbi@nokia.com,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100526201820.GA25663@gibbs.hungrycats.org>
References: <AANLkTiksR3YozbBH0Iv5kNsQkEGKCH1APCvn_s6LkjV9@mail.gmail.com>
 <1274868593.5882.5185.camel@twins>
 <AANLkTinuxCbeBmxIR7b_1OtrqQYJCamiDZJbnNTih1Fb@mail.gmail.com>
 <1274869966.5882.5262.camel@twins>
 <AANLkTikRMBkoFxgaKsxMJ2lOMomTXpiHJDk3rVt0EtwM@mail.gmail.com>
 <1274870970.5882.5311.camel@twins>
 <AANLkTinlxsokwralwRAL9_YRQ7-SZUSvrGHTlRISA9bC@mail.gmail.com>
 <1274872357.27810.16.camel@twins>
 <20100526133510.6e9de670@lxorguk.ukuu.org.uk>
 <1274878396.27810.334.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274878396.27810.334.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 02:53:16PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-05-26 at 13:35 +0100, Alan Cox wrote:
> > This is an area where machines are improving and where the ability to
> > do stuff like autosuspend, the technology like the OLPC screen and so on
> > create an incentive for the BIOS and platform people to improve their
> > bits of it.
> 
> But do you think its a sensible thing to do? Explicitly not running
> runnable tasks just sounds wrong. 
[...]
> Why would the code holding suspend blockers be any more or less
> important than any other piece of runnable code.

With my userspace developer hat on, I'd *kill* for a way to tell
the kernel that there are more important things for the system to
be doing than executing my runnable task.  In some cases, the set of
"more important things" the system might include running other tasks,
but it also might include conserving power.  I'd like to have my program
tell the kernel things like "wake me up in 0.1 seconds, plus or minus
a year if you have something better to do."

With my sysadmin hat on (which is nearly identical to my phone owner hat,
BTW), I'd like whatever syscall implements those features to take a PID
argument, so I can impose my importance decisions on other processes.
I'd also like to set the relative importance of keeping the CPU idle on
the same scale, so that I could raise or lower the importance of keeping
the CPU idle as power availability changes.

> This whole thing introduces an artificial segregation of code. My 'cool'
> code is more important than your 'uncool' code. Without a clear
> definition of what makes code cool or not.

It's impossible in the general case for an application to know whether
it's important or not, so it's also impossible for the kernel to derive
this information from the application's behavior--and impossible, in the
general case, to decide whether the application is more important than the
battery or some other scarce resource the kernel might also be managing
(e.g. if the machine is running hot, heat dissipation might be scarce,
and we'd want to be idle then too).  This is similar to niceness and
SCHED_RR/FIFO:  there's no way for the kernel to automatically assign
those values either, they have to be specified by a user or administrator.
Of course, programs are free--within limits--to specify these values
about themselves.

Consider a traditional Unix program like "sort".  Seriously, how is "sort"
supposed to know that it's the most important application on the system
(because I need my contacts list alphabetized *now*), or the least
(because the screensaver needs to know which is the oldest graphics
hack in the list)?

"sort" gets invoked from a shell, cooperating with other processes to do
its work.  It knows very little about the context in which it is executing
(nor should it).  Should "sort" sprout command-line arguments for every
possible scheduling latency and power management policy option, or should
"sort" not care, and defer such decisions to other command-line
tools which set these options before exec()ing "sort", or to a management
utility like "top" that implements policy across the entire system?


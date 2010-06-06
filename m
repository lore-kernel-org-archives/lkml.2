Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab0FFOna (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:43:30 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38285 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756570Ab0FFOn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:43:28 -0400
Date: Sun, 6 Jun 2010 07:43:22 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend blockers & Android integration
Message-ID: <20100606144322.GC21016@count0.beaverton.ibm.com>
References: <AANLkTikGDSzaENwg_0BAtsYf3ulGd_6sGPR30WsvUxMi@mail.gmail.com>
 <alpine.LFD.2.00.1006050246350.2933@localhost.localdomain>
 <AANLkTikU21xF49Z-_Lnrq7U7buNmqw_gyEEST8LuN24z@mail.gmail.com>
 <alpine.LFD.2.00.1006051736040.2933@localhost.localdomain>
 <AANLkTinD39rI47innPbGz1Gi8PsXV5HqkmaQuJ70oQ63@mail.gmail.com>
 <alpine.LFD.2.00.1006052348200.2933@localhost.localdomain>
 <AANLkTikmWDHYJ8wWF2cZapbkHHjV09R39I37yvQXFmor@mail.gmail.com>
 <alpine.LFD.2.00.1006060148470.2933@localhost.localdomain>
 <AANLkTikdM79nmARagK9gLveMWEiT6rlk44UELes1k8Ch@mail.gmail.com>
 <alpine.LFD.2.00.1006061202351.2933@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1006061202351.2933@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 06, 2010 at 12:36:21PM +0200, Thomas Gleixner wrote:
> On Sat, 5 Jun 2010, Arve Hjønnevåg wrote:

<snip>

> > events like input event go though a single thread in our system
> > process, while other events like network packets (which are also
> > wakeup events) goes directly to the app.

If you want to wake up cgroup-frozen tasks for these fds perhaps your
framework can fcnt(fd, F_SETOWN, <p[g]id>) to send SIGIO to a
userspace-suspend-blocker thread/process/process group. When IO comes in, the
suspend blocker is signalled which then unfreezes the cgroup of the frozen
untrusted task. SIGIO works on pipes, fifos, sockets, ttys, and ptys --
many of which are precisely the kinds of things that would connect [trusted
and untrusted] apps. Notably absent (last I checked): inotify fds, signalfd,
timerfd, eventfd, filesystem fds and likely more.

Incidentally, this is just to show that it's not impossible to implement
"wakeups" for cgroup-frozen tasks in userspace.

Cheers,
	-Matt Helsley

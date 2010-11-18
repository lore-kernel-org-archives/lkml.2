Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356Ab0KRP7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:59:45 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:33396 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046Ab0KRP7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:59:43 -0500
Date: Thu, 18 Nov 2010 17:59:40 +0200
From: Alexander Shishkin <virtuoso@slind.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kyle Moffett <kyle@moffetthome.net>, Valdis.Kletnieks@vt.edu,
        LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCHv6 0/7] system time changes notification
Message-ID: <20101118155940.GF26184@shisha.kicks-ass.net>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
 <22542.1289507293@localhost>
 <20101111205123.GC10585@shisha.kicks-ass.net>
 <alpine.LFD.2.00.1011112212460.2900@localhost6.localdomain6>
 <AANLkTik8FS5p_P_2ygh9qC2qg7wTDP+23LKbhJCKcMez@mail.gmail.com>
 <alpine.LFD.2.00.1011112322280.2900@localhost6.localdomain6>
 <20101117190659.GB26184@shisha.kicks-ass.net>
 <alpine.DEB.2.00.1011171130210.1595@davide-lnx1>
 <20101117212912.GC26184@shisha.kicks-ass.net>
 <AANLkTi=MgkGsckJ0=K-+vfRMLmwUvJ0D4EY+tSA_N22c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=MgkGsckJ0=K-+vfRMLmwUvJ0D4EY+tSA_N22c@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 10:34:00PM +0100, Kay Sievers wrote:
> On Wed, Nov 17, 2010 at 22:29, Alexander Shishkin <virtuoso@slind.org> wrote:
> > On Wed, Nov 17, 2010 at 12:42:52PM -0800, Davide Libenzi wrote:
> >> On Wed, 17 Nov 2010, Alexander Shishkin wrote:
> >>
> >> > > But what you folks really want for this stuff is an extension to
> >> > > timerfd as you want to be able to poll, right?
> >> > >
> >> > > So what about the following:
> >> > >
> >> > > Add a new flag TDF_NOTIFY_CLOCK_WAS_SET to the timerfd flags. Now this
> >> > > flag adds the timer to a separate list, which gets woken up when the
> >> > > clock is set.
> >> > >
> >> > > No new syscall, just a few lines of code in fs/timerfd.c and
> >> > > clock_was_set().
> >> > >
> >> > > Thoughts ?
> >> >
> >> > Something like this (sans ugliness)?
> >>
> >> Oh, gosh, please. šThis is interface-multiplexing-a-palooza.
> >
> > Thomas made a suggestion, I came up with how it might look like so that
> > pros and cons are clearer to everyone (or at least me) and can be discussed
> > on technical grounds. Code talks, sort of. I'm not convinced that a timer
> > that returns to userspace when the clock changes is such a bad idea, could
> > you please elaborate?
> 
> I like it.
> 
> It's all bout timers, and timerfd is fine to use, I think. It has
> nothing to do with "system-events", we ask for the timer to serve us,
> but if the *time* changes underneath, we need to know to re-calculate.
> 
> I think it's simple and fits very well in the current interface.

What would you say timerfd_gettime() should return for such a timer? Should
it be current clock's time in it_value?

Regards,
--
Alex

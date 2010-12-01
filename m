Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab0LAAeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 19:34:04 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:46713 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab0LAAeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 19:34:02 -0500
Date: Wed, 1 Dec 2010 02:33:58 +0200
From: Alexander Shishkin <virtuoso@slind.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org, Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [PATCH] [RFC] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for
 clock changes
Message-ID: <20101201003358.GJ26184@shisha.kicks-ass.net>
References: <1290532938-7332-1-git-send-email-virtuoso@slind.org>
 <20101123224346.GA19350@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101123224346.GA19350@tango.0pointer.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 11:43:46PM +0100, Lennart Poettering wrote:
> On Tue, 23.11.10 19:22, Alexander Shishkin (virtuoso@slind.org) wrote:
> 
> > Certain userspace applications (like "clock" desktop applets or cron or
> > systemd) might want to be notified when some other application changes
> > the system time. There are several known to me reasons for this:
> >  - avoiding periodic wakeups to poll time changes;
> >  - rearming CLOCK_REALTIME timers when said changes happen;
> >  - changing system timekeeping policy for system-wide time management
> >    programs;
> >  - keeping guest applications/operating systems running in emulators
> >    up to date.
> > 
> > This is another attempt to approach notifying userspace about system
> > clock changes. The other one is using an eventfd and a syscall [1]. In
> > the course of discussing the necessity of a syscall for this kind of
> > notifications, it was suggested that this functionality can be achieved
> > via timers [2] (and timerfd in particular [3]). This idea got quite
> > some support [4], [5], [6] and some vague criticism [7], so I decided
> > to try and go a bit further with it.
> 
> I agree with Kay, this is pretty much exactly what we want for
> systemd. (Assuming that the time jump due to system suspend is
> propagated to userspace like any other time jump with this path).

Good point, I'll add the notification to the resume point.

> So yeah, I'd be very happy if this could be merged.

Good to hear.

Regards,
--
Alex

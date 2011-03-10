Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab1CJPoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:44:04 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:51345 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab1CJPoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:44:01 -0500
Date: Thu, 10 Mar 2011 17:43:57 +0200
From: Alexander Shishkin <virtuoso@slind.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ken MacLeod <ken@bitsko.slc.ut.us>,
        Shaun Reich <predator106@gmail.com>,
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
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock
 changes
Message-ID: <20110310154357.GG11410@shisha.kicks-ass.net>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org>
 <alpine.LFD.2.00.1103101014260.2787@localhost6.localdomain6>
 <20110310141241.GE11410@shisha.kicks-ass.net>
 <alpine.LFD.2.00.1103101516501.2787@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103101516501.2787@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 03:55:00PM +0100, Thomas Gleixner wrote:
> On Thu, 10 Mar 2011, Alexander Shishkin wrote:
> > On Thu, Mar 10, 2011 at 10:52:18AM +0100, Thomas Gleixner wrote:
> > > On Wed, 9 Mar 2011, Alexander Shishkin wrote:
> > > The patch does something different. How is this related to the problem
> > > you wanted to solve in the first place?
> > 
> > Well, if you scratch the timerfd_settime() bit, it kind of addresses the
> > initial problem. The timerfd_settime() was indeed a mistake.
> > 
> > > Can you please explain which problems you identified aside of the
> > > initial one?
> > 
> > Sure. The time daemon that we have here has to stop automatic time updates
> > when some other program changes system time *and* keep that setting
> > effective. Currently, when "the other program" changes the system time
> > right before time daemon changes it, this time setting will be overwritten
> > and lost. I'm thinking that it could be solved with something like
> > 
> >   clock_swaptime(clockid, new_timespec, old_timespec);
> > 
> > but something tells me that it will not be welcome either.
> 
> What's that time daemon doing? The semantics of updating system time,
> but stopping to do so when something else sets the time sounds more
> like a design problem than anything else.

The daemon's synchronizing system time with various sources like GSM base
stations, time servers etc, but only until something else touches the time
in the system, which would basically mean that the user has installed a
3rd-party application that's controlling system time or just called `date`.
I don't know all the reasons for this requirement, but it seems that not
losing time changes to a race is not a bad idea. Of course, if anyone cares.

Regards,
--
Alex

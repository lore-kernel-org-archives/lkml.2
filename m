Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab0IPXEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 19:04:07 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:57321 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab0IPXEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 19:04:04 -0400
Date: Fri, 17 Sep 2010 01:58:43 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 1/7] notify userspace about time changes
Message-ID: <20100916225843.GB10463@shisha.kicks-ass.net>
References: <1284675049-23479-1-git-send-email-virtuoso@slind.org>
 <1284675049-23479-2-git-send-email-virtuoso@slind.org>
 <1284676240.2669.41.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284676240.2669.41.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 03:30:40 -0700, john stultz wrote:
> On Fri, 2010-09-17 at 01:10 +0300, Alexander Shishkin wrote:
> > Certain userspace applications (like "clock" desktop applets or cron) might
> > want to be notified when some other application changes the system time. It
> > might also be important for an application to be able to distinguish between
> > its own and somebody else's time changes.
> > 
> > This patch implements a notification interface via eventfd mechanism. Proccess
> > wishing to be notified about time changes should create an eventfd and pass it
> > to time_change_notify() syscall along with notification options.
> > After that, any calls to settimeofday()/stime()/adjtimex() made by other
> > processes will be signalled to this eventfd. Credits for suggesting the eventfd
> > mechanism for this purpose go to Kirill Shutemov.
> 
> One thing I have thought of since the last time you posted this, maybe
> it would be worth adding a clockid field to the syscall?
> 
> Basically, we're looking at extending the posix clocks interfaces to
> allow for additional clock hardware to be exposed (See the discussion on
> PTP and my CLOCK_RTC patch today for examples and details).
> 
> So it seems possible that folks would want a similar interface to catch
> updates to non CLOCK_REALTIME clocks.
> 
> Does this seem reasonable?

The whole idea seems interesting, I'll try to add this in the next iteration
of this patchset.
The first thing that comes it mind is -- are there going to be additional
events that the user might like to be notified of, like rtc_set_alarm()?
Doesn't seem too likely, though.

Regards,
--
Alex

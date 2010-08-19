Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0HSLXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 07:23:48 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:47608 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab0HSLXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 07:23:47 -0400
Date: Thu, 19 Aug 2010 14:14:41 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, lkml@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [PATCH] [RFCv2] notify userspace about time changes
Message-ID: <20100819111441.GD3003@shisha.kicks-ass.net>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>, lkml@vger.kernel.org,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <johnstul@us.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
	John Kacur <jkacur@redhat.com>,
	Chris Friesen <chris.friesen@genband.com>,
	Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org
References: <1282139739-23832-1-git-send-email-virtuoso@slind.org>
 <20100818155702.bc62b2a6.akpm@linux-foundation.org>
 <4C6C7034.4050501@zytor.com>
 <20100818165303.dd52695a.akpm@linux-foundation.org>
 <1282211446.1926.4609.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282211446.1926.4609.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 11:50:46 +0200, Peter Zijlstra wrote:
> On Wed, 2010-08-18 at 16:53 -0700, Andrew Morton wrote:
> > 
> > 
> > Such applications might be better served via a wake-me-at-this-time
> > syscall instead of a sleep-me-for-this-long syscall.  Although such a
> > thing is less general.
> > 
> We have timer_create(.clockid = CLOCK_REALTIME) for such things, no?

No. I'll try to summarize all the things that have been said about the
use cases for this functionality earlier in the followup version so as
to make things clearer.

> 
> > > +                  fd = open("/sys/kernel/time_notify", O_WRONLY);
> > > +                  fdprintf(fd, "%d 1 0 1 1", efd);
> > 
> > why not
> > 
> >                 sys_time_notify(efd, 1, 0, 1, 1);
> 
> And then there is the /dev/time proposal from Plan9:
> 
>   http://lkml.org/lkml/2009/3/11/363
> 
> Their proposal was to add a poll() method to the device which would wake
> on every change in time.

I haven't seen any poll-related code there, but it looks like the interface
which duplicates existing functionality for no gain.

It would be nice if they did some work on replacing {get,set}timeofday()
with read()s/write()s in glibc etc. But as of now this /dev/time looks quite
a pointless thing to have.

Regards,
--
Alex

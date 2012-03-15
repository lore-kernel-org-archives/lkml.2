Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031003Ab2COPjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:39:24 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33983 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030668Ab2COPjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:39:22 -0400
Date: Thu, 15 Mar 2012 08:39:08 -0700
From: Mandeep Singh Baines <msb@chromium.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] watchdog: Make sure the watchdog thread gets CPU on
 loaded system
Message-ID: <20120315153907.GV27051@google.com>
References: <1331757525-5755-1-git-send-email-dzickus@redhat.com>
 <20120314161906.e53359d3.akpm@linux-foundation.org>
 <20120315014511.GT27051@google.com>
 <1331809239.18960.168.camel@twins>
 <1331809597.18960.171.camel@twins>
 <20120315124228.GA5318@elte.hu>
 <1331820051.18960.187.camel@twins>
 <20120315143549.GC3941@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315143549.GC3941@redhat.com>
X-Operating-System: Linux/2.6.38.8-gg683 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus (dzickus@redhat.com) wrote:
> On Thu, Mar 15, 2012 at 03:00:51PM +0100, Peter Zijlstra wrote:
> > On Thu, 2012-03-15 at 13:42 +0100, Ingo Molnar wrote:
> > > So unless there's concensus to remove everything but the hard 
> > > lockup detection facilities, lets solve the technical problem at 
> > > hand, ok? 
> > 
> > Well, at least make it possible to disable the silly soft thing.
> > 
> > And I really wouldn't know how the soft thing could possible help,
> > except when not actually having a NMI watchdog. What case does it
> > trigger where the NMI one doesn't?
> 
> I think softlockup really boils down to a pre-emption disabled detector
> much like how the hardlockup really is a interrupts disabled detector.
> 
> The amount of code preventing the scheduler from running is most likely a
> lot lower than the code the prevents interrrupts from happening.
> 

Its a good tool for catching problems of scale. As we move to more and
more cores you'll uncover bugs where data structures start to blow up.
Hash tables get huge, when you have 100000s of processes or millions of
TCP flows, or cgroups or namespace. That critical section (spinlock,
spinlock_bh, or preempt_disable) that used to be OK might no longer be.

There are some labs that are already there:

http://www.wine-reviews.net/wine-reviews/news/megatux-to-run-1-million-copies-on-wine-to-simulate-the-internet.html

With the softlockup detector, they'll get a useful stack trace in dmesg
that they can then send to lkml so that we can fix a scalability issue
that we hadn't previously known about.

Regards,
Mandeep

> Cheers,
> Don
> 

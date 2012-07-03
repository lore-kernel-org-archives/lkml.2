Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab2GCMFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 08:05:45 -0400
Received: from swielinga.nl ([83.160.77.141]:49995 "EHLO swielinga.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab2GCMFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 08:05:44 -0400
Date: Tue, 3 Jul 2012 14:05:36 +0200
From: Sytse Wielinga <sytse@swielinga.nl>
To: Richard Cochran <richardcochran@gmail.com>
Cc: John Stultz <johnstul@us.ibm.com>, Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] Potential fix for leapsecond caused futex related
 load spikes
Message-ID: <20120703120535.GA30998@swielinga.nl>
Mail-Followup-To: Richard Cochran <richardcochran@gmail.com>,
	John Stultz <johnstul@us.ibm.com>,
	Prarit Bhargava <prarit@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <4FF06CAB.9020800@redhat.com>
 <4FF08154.3050407@redhat.com>
 <4FF088B9.1000308@us.ibm.com>
 <20120702101606.GA16008@localhost.localdomain>
 <20120702200821.GA31197@swielinga.nl>
 <20120703092325.GA18121@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120703092325.GA18121@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 11:23:25AM +0200, Richard Cochran wrote:
> I think the established practice of announcing the event by network is
> the only sane way of handling this issue. The list of TAI-UTC offsets
> belongs to what David Mills has called our "institutional memory", and
> this is a user space issue. The kernel's job is to just live in the
> moment and provide the right time for *now*.

I do suppose hardware clock and file system times will have to be UTC (or
UTC-based local time) though?  Or do you think the 35 seconds difference
simply will be so small of a problem that it's not worth fussing over?

Doing this translation in libc and keeping fs times in TAI+tz offset would
seem to necessitate at least modifications to every single program accessing
file system data directly, and would still cause minor problems with
multiboot; doing it in the kernel would mean adding a step to the boot
sequence (before mounting root r/w) for loading the current TAI-UTC difference
into the kernel; also, it'd mean splitting 'kernel time' into multiple times.
Which solution did you have in mind?

> > > There have been a number of clock/timer/leap bugs over the last
> > > years. Some of these might have been avoided by using a continuous
> > > scale, since no special timer actions would be needed during a leap
> > > second.
> > > 
> > > The run time cost is low, just one additional test and addition when
> > > reading the time. It might be worth it for the peace of mind when
> > > the next leap second rolls around.
> > 
> > I don't know if reworking the system that's been in place for ages is a good
> > way to give us 'peace of mind'.  Then again, I love to be enlightened :-)
> 
> There have been lockups and other kernel issues due to leap second
> bugs. That is a fact. Does that give you peace of mind?
> 
> My own computers were off for the last leap second. But some people
> cannot afford to do this. I suggest that changing the code so that no
> special actions occur at a leap second would be more reliable than
> having rarely tested code paths just for leap second handling.

I suppose you're right; the new code might be buggy, but at least it'd get
year-round testing instead of just once every few years or so.

Then again, you and John have come up with a good regression test.

Sytse

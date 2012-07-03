Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab2GCJXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:23:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42032 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab2GCJXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:23:34 -0400
Date: Tue, 3 Jul 2012 11:23:25 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <johnstul@us.ibm.com>, Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] Potential fix for leapsecond caused futex
 related load spikes
Message-ID: <20120703092325.GA18121@localhost.localdomain>
References: <4FF06CAB.9020800@redhat.com>
 <4FF08154.3050407@redhat.com>
 <4FF088B9.1000308@us.ibm.com>
 <20120702101606.GA16008@localhost.localdomain>
 <20120702200821.GA31197@swielinga.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120702200821.GA31197@swielinga.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 10:08:21PM +0200, Sytse Wielinga wrote:
> Hi Richard,
> 
> On Mon, Jul 02, 2012 at 12:16:08PM +0200, Richard Cochran wrote:
> > I know you didn't like my (originally Michael Hack's) idea of keeping
> > time in TAI, but wouldn't changing to an internal, continuous time
> > scale (not necessary TAI) solve these sorts of timer issues?
> 
> Doesn't that actually make the problem of leap seconds worse, as you'd have to
> start tabulating past leap seconds in the kernel?

No, I am not suggesting to do that.
 
> Even worse, *future* leap seconds would need to be tracked and after they've
> happened stored on disk, and loaded back into the kernel after booting, which
> seems like a mess.  The trouble here is that leap seconds are only announced a
> short while before they happen, so there's no way to bake leap seconds into
> the software; they need to be dynamically added by ntpd.
> 
> Or is there somehow some way to avoid that?

I think the established practice of announcing the event by network is
the only sane way of handling this issue. The list of TAI-UTC offsets
belongs to what David Mills has called our "institutional memory", and
this is a user space issue. The kernel's job is to just live in the
moment and provide the right time for *now*.

> > There have been a number of clock/timer/leap bugs over the last
> > years. Some of these might have been avoided by using a continuous
> > scale, since no special timer actions would be needed during a leap
> > second.
> > 
> > The run time cost is low, just one additional test and addition when
> > reading the time. It might be worth it for the peace of mind when
> > the next leap second rolls around.
> 
> I don't know if reworking the system that's been in place for ages is a good
> way to give us 'peace of mind'.  Then again, I love to be enlightened :-)

There have been lockups and other kernel issues due to leap second
bugs. That is a fact. Does that give you peace of mind?

My own computers were off for the last leap second. But some people
cannot afford to do this. I suggest that changing the code so that no
special actions occur at a leap second would be more reliable than
having rarely tested code paths just for leap second handling.

Thanks,
Richard

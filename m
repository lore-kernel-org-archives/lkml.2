Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab2EaP1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:27:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37830 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752132Ab2EaP1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:27:45 -0400
Date: Thu, 31 May 2012 11:27:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@redhat.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Use of high-res timers
In-Reply-To: <alpine.LFD.2.02.1205311650130.3231@ionos>
Message-ID: <Pine.LNX.4.44L0.1205311120370.1174-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012, Thomas Gleixner wrote:

> > Here's an example.  A hardware device accesses a software data
> > structure via DMA, and the driver needs to change the data structure.  
> > However, the data can't be updated safely while the device is using it.
> > Furthermore, we know that the device may continue to access the data
> > for as long as 1 ms after being told to stop (because of internal
> > caches and such).
> 
> And of course the hardware designers decided that there is no need for
> a reliable way to detect that....

Well, it's not quite that bad.  In fact the hardware design does call
for a counter that increments at 8000 Hz; it could be used for this 
purpose.

Except...  In some implementations, the counter stops at unpredictable
times!  It's not reliable; hence this workaround.

> It just depends on the resolution of the underlying clocksource and NTP
> adjustments.
> 
> So the only case where you can run into trouble is when the
> clocksource is coarse grained, e.g. pure jiffies, where two
> consecutive calls can show a 1/HZ delta.
> 
> But you really should not worry much about that, except you are aiming
> for some stoneage platform. Anything up to date is going to have at
> least a 32kHz counter based clocksource. At 32kHz the per clock tick
> increment is ~30us, so that's your expected error.

Just what I needed to know!  Thanks.

Alan Stern


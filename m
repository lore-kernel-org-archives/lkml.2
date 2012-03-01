Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab2CAJyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:54:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:36598 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758791Ab2CAJyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:54:37 -0500
Date: Thu, 1 Mar 2012 10:54:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Guenter Roeck <guenter.roeck@ericsson.com>
cc: Greg KH <gregkh@linuxfoundation.org>, Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
In-Reply-To: <1330105668.23014.152.camel@groeck-laptop>
Message-ID: <alpine.LFD.2.02.1203010932070.2742@ionos>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>  <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>  <20120224153811.GA16535@kroah.com>  <1330103229.23014.130.camel@groeck-laptop>  <20120224171752.GB9485@kroah.com>
 <1330105668.23014.152.camel@groeck-laptop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012, Guenter Roeck wrote:
> On Fri, 2012-02-24 at 12:17 -0500, Greg KH wrote:
> > On Fri, Feb 24, 2012 at 09:07:09AM -0800, Guenter Roeck wrote:
> > > How about dropping UIO support from the kernel ? That would make more
> > > sense to me.
> > 
> > Again, UIO solves a real need, are you to tell the users of that code
> > that somehow we are now not going to support them anymore?
> > 
> > UIO was created when Thomas and I sat in the back of a conference
> > presentation and saw, for the umpteenth time, a presentation by someone
> > who was trying to write userspace drivers, and obviously didn't know
> > what they were doing.
> > 
> > UIO provides a framework that actually works (unlike all of the previous
> > research papers were trying to do), and is used in real systems (laser
> > welding robots!) every day, manufacturing things that you use and rely
> > on.
> > 
> > You remove UIO at the risk of pissing off those robots, the choice is
> > yours, I know I'm not going to do it...
> 
> I understand the background and reasoning, but ...
> 
> I have seen UIO used for networking drivers, hwmon drivers, I2C bus
> master drivers (with matching I2C client drivers in user-space), mfd
> devices, and so on. I have seen existing kernel drivers re-implemented
> as UIO drivers. I have seen UIO drivers where the kernel part of the
> driver is larger than the entire driver written as kernel driver. I have
> seen UIO drivers using polling instead of interrupts "because it is
> faster than interrupts".
> 
> Often, those drivers are then re-written for the next board (to support
> the same chip) because they were not written with HW-independence in
> mind and don't support HW abstraction.
> 
> Yes, there may be real need for UIO in some cases, but all I have seen
> it used for so far is what I would call abuse, resulting in maintenance
> nightmares.

UIO always had a clear target: devices which are application bound and
not related to any larger set of functonality (device class
frameworks, communication stacks, ...)

For that kind of devices in kernel drivers are overkill and
performance bottlenecks. The drivers which are in tree come with open
user space access libraries and are completely sane.

We can't punish the sane users for the asinnity of other people.

If people go there and abuse UIO for other purposes, we can't prevent
it. We can't prevent either that people write totally crappy kernel
drivers ...

> Given the choice, I would be quite happy to piss off some robots. Call
> it a prejudice if you like ;).

You might become less happy when the robot welds your ear onto a car
hood :)

Thanks,

	tglx

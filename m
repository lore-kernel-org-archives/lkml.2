Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab2BXRtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:49:22 -0500
Received: from imr4.ericy.com ([198.24.6.9]:60993 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab2BXRtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:49:21 -0500
Message-ID: <1330105668.23014.152.camel@groeck-laptop>
Subject: Re: Can we move device drivers into user-space?
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Greg KH <gregkh@linuxfoundation.org>
CC: Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Fri, 24 Feb 2012 09:47:48 -0800
In-Reply-To: <20120224171752.GB9485@kroah.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
	 <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
	 <20120224153811.GA16535@kroah.com>
	 <1330103229.23014.130.camel@groeck-laptop>
	 <20120224171752.GB9485@kroah.com>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-24 at 12:17 -0500, Greg KH wrote:
> On Fri, Feb 24, 2012 at 09:07:09AM -0800, Guenter Roeck wrote:
> > How about dropping UIO support from the kernel ? That would make more
> > sense to me.
> 
> Again, UIO solves a real need, are you to tell the users of that code
> that somehow we are now not going to support them anymore?
> 
> UIO was created when Thomas and I sat in the back of a conference
> presentation and saw, for the umpteenth time, a presentation by someone
> who was trying to write userspace drivers, and obviously didn't know
> what they were doing.
> 
> UIO provides a framework that actually works (unlike all of the previous
> research papers were trying to do), and is used in real systems (laser
> welding robots!) every day, manufacturing things that you use and rely
> on.
> 
> You remove UIO at the risk of pissing off those robots, the choice is
> yours, I know I'm not going to do it...

I understand the background and reasoning, but ...

I have seen UIO used for networking drivers, hwmon drivers, I2C bus
master drivers (with matching I2C client drivers in user-space), mfd
devices, and so on. I have seen existing kernel drivers re-implemented
as UIO drivers. I have seen UIO drivers where the kernel part of the
driver is larger than the entire driver written as kernel driver. I have
seen UIO drivers using polling instead of interrupts "because it is
faster than interrupts".

Often, those drivers are then re-written for the next board (to support
the same chip) because they were not written with HW-independence in
mind and don't support HW abstraction.

Yes, there may be real need for UIO in some cases, but all I have seen
it used for so far is what I would call abuse, resulting in maintenance
nightmares.

Given the choice, I would be quite happy to piss off some robots. Call
it a prejudice if you like ;).

Guenter



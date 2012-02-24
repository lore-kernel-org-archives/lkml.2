Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab2BXSjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 13:39:06 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45505 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab2BXSjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 13:39:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.240.100 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Fri, 24 Feb 2012 10:34:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120224183423.GA23284@kroah.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
 <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
 <20120224153811.GA16535@kroah.com>
 <1330103229.23014.130.camel@groeck-laptop>
 <20120224171752.GB9485@kroah.com>
 <1330105668.23014.152.camel@groeck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330105668.23014.152.camel@groeck-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 09:47:48AM -0800, Guenter Roeck wrote:
> > You remove UIO at the risk of pissing off those robots, the choice is
> > yours, I know I'm not going to do it...
> 
> I understand the background and reasoning, but ...
> 
> I have seen UIO used for networking drivers, hwmon drivers, I2C bus
> master drivers (with matching I2C client drivers in user-space), mfd
> devices, and so on.

And all of those uses are wrong.  Go kick those developers and companies
today.  Hard.

> I have seen existing kernel drivers re-implemented as UIO drivers. 

Where?  By whom?

> I have seen UIO drivers where the kernel part of the
> driver is larger than the entire driver written as kernel driver. I have
> seen UIO drivers using polling instead of interrupts "because it is
> faster than interrupts".

We can't prevent people from being stupid, can we?

> Often, those drivers are then re-written for the next board (to support
> the same chip) because they were not written with HW-independence in
> mind and don't support HW abstraction.
> 
> Yes, there may be real need for UIO in some cases, but all I have seen
> it used for so far is what I would call abuse, resulting in maintenance
> nightmares.

Again, that's using the interface wrong, and foolishly.  Don't do that.

> Given the choice, I would be quite happy to piss off some robots. Call
> it a prejudice if you like ;).

You can't control how people use an interface.  You will note that there
are no stupid users of the UIO interface in the kernel today, we can't
control what people do in the privacy of their own companies/homes,
despite numerous governments trying to do so in the past.

So yes, people will always do stupid, foolish things.  And they were
doing them before UIO came along, now they just have the chance to at
least do those foolish things in a way that interfaces with the kernel
in a semi-sane manner, not messing anything else in the kernel up.

sorry,

greg k-h

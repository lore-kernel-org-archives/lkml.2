Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab1CQNYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 09:24:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57164 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab1CQNYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 09:24:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: IIO comments
Date: Thu, 17 Mar 2011 14:24:07 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
References: <201103152215.20059.arnd@arndb.de> <201103161615.30799.arnd@arndb.de> <4D80D862.7080601@cam.ac.uk>
In-Reply-To: <4D80D862.7080601@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103171424.07582.arnd@arndb.de>
X-Provags-ID: V02:K0:YLarzL1ebSHrX/phadGjdNrWJeLlGC5i2pp/ySdyHow
 3koaFdSnAYVSAU9kwMy/5TOCyHnBJ9jB3NhjdLo/6AIvWtpxHC
 di9FM2co8SzU9RYxJ+n9xtvyZChUA+lqlbkzmT+F9qsciM/wKh
 f0dl4mqd6mPiM3gI8kK1Gjc7epfJ5piHjIakF5tuDP9N0zQB1f
 EZyK5Uug2OfhVXrCzIkVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 March 2011, Jonathan Cameron wrote:
> On 03/16/11 15:15, Arnd Bergmann wrote:

> > Are you currently printing the unit as part of the
> > attribute output? If that gets handled by the core,
> > any driver that tries to use something else would
> > simply be considered a bug.
> Nope.  It's done set by the Docs.  This we need to keep for compatibility
> (where relevant) with hwmon.  It's a bug now if it doesn't meet
> the spec but you'd be amazed how often these are wrong.  Sometimes
> it is a nightmare figuring out from the datasheet what they actually
> are!

Ok.

> >>
> >> The moment we put a route in for registering additional attributes
> >> the out-of-tree argument is weakened.
> > 
> > Would it help to have multiple types of interfaces (I suppose
> > you already do), each with their own table?
> > 
> > This way you could enforce that all drivers of one type use
> > exactly the same specification, but also make it possible
> > to have new types, even those that have only one driver by
> > design.
>
> Sadly there are no clean definitions of types.  You'd be amazed what
> downright weird sets end up in a given device.
> Might be some way of breaking it down into a set of tables though
> in a vaguely coherent way.  Each device would then have one or more
> of these for which it would define one or more of the functions.

Right, or you could mandate that each device has exactly one of these,
but that you could have multiple iio devices in a single hardware
device.

> > is to have an ioctl function that returns structured
> > data, while the regular read function returns the buffered
> > input stream.
>
> That would work, but it is it really worth it to kill off the chrdev?

I don't know.

> Note we still need most of the underlying structure just to keep the
> various attributes well categorized.

The hardest part of interface design is always to find the simplest
possible way that can cover all the corner cases. I'm trying to
come up with possible simplifications, but I don't know all the
requirements that get in the way.

> >>> Doesn't epoll handle the event escalation with its edge triggered
> >>> mode? Basically you can get notified every time that there is
> >>> more to be read.
> >> We also need to know how much more this is to be read.  So at the
> >> moment, if a 50% full turns up and isn't picked up by userspace
> >> before a 75% full event, the 50% is escalated to become a 75%
> >> event which userspace then receives.  To be honest I'm tempted,
> >> for now at least to drop this functionality.  It has few users
> >> and makes the events system considerably more complex.  We can
> >> think about how / whether to introduce it later.
> > 
> > Yes, good point. I also don't get the use case of this. Why would
> > user space not just always read all data that is available?
> Good point. We could just move the handling of these events into the
> actual driver (this is only ever relevant for hardware buffers).  Thus
> it could keep track of what it knows is there.  Note these devices don't
> always provide any other way of knowing and yes you can read more data
> from them than is actually there.  Whether you can tell this has happened
> is very much device dependent.

Can you give an example? I don't understand what you mean with "can read
mode data [...] than is actually there".

> >> Yup, the dynamic route to creation is what I favour.  As you say
> >> this needs fixing up before going out of staging.  We definitely
> >> need these for a bridge to input to implement polled input devices.
> >>
> >> I'll put a todo in place for that element in staging so we don't
> >> forget.
> > 
> Note I have quite a few changes currently queued up so might be a little while
> before I get to trying out the more complex stuff you have suggested.

Ok, no problem. Just take your time.

	Arnd

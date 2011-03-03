Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab1CCGXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:23:21 -0500
Received: from kroah.org ([198.145.64.141]:33183 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904Ab1CCGXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:23:19 -0500
Date: Wed, 2 Mar 2011 22:19:50 -0800
From: Greg KH <greg@kroah.com>
To: Kumba <kumba@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Can I nest kobjects to create directories under parent
 directories for my driver?
Message-ID: <20110303061950.GC32245@kroah.com>
References: <4D6C68A4.3020306@gentoo.org>
 <20110302203823.GA18879@kroah.com>
 <4D6EBB5A.7080307@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6EBB5A.7080307@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 04:49:14PM -0500, Kumba wrote:
> On 03/02/2011 15:38, Greg KH wrote:
> >
> >That's nice, but it really isn't a good idea to do things this deep.
> >Userspace tools will not be able to find things properly (like libudev)
> >and your kernel code will get very messy (as you have found out.)
> >
> >Why not look at how the other rtc drivers work, they don't nest things
> >this deep and you need to sick with the standard userspace api and not
> >invent a new one if at all possible.
> >
> >But to answer your question, you can do this, but I strongly discourage
> >it.
> 
> From the way sysfs seems to work, I can see that it encourages as
> little nesting as possible.

No, not at all, just you don't want to do nesting "on your own".

> So this is probably the way I will go
> and just call the entries "regs_ctrla" through "regs_ctrl4b".  It
> still conveys the relevant information and is easily doable through
> the existing userspace framework.

That's good.

But again, please look at how other rtc drivers did this so you aren't
creating an api that is unique.

> How does one nest kobjects, though?  Are ksets the only real way?

First off, a driver should _never_ need to deal with a kobject.  Or a
struct device even, that's up to the bus code to wrap up, and even then,
it doesn't deal with kobjects.

You nest 'struct device' objects, as they nest very easy and is how the
kobject stuff is implemented for "real" devices in the kernel.

> Or is it doable through linking kobjects to each other?  If the
> latter is possible, how does one keep the reference to the device
> structure intact?  I figure the right use of backcasting (through
> container_of) is one way, but it definitely seems like I am treading
> new territory with such an approach.

You can do it on your own, but it's tricky, and I don't recommend it at
all, especially in a driver.  Actually never in a driver, just don't do
it.

But if you are curious, look at the kobject documentation in the kernel
tree.  It has working examples and hopefully everything you need if you
are curious.

But again, don't do it, your code will be rejected :)

> I did learn one useful thing through this -- the use of a common
> show/store function for each register (using strncmp to look up
> which bit was accessed).  I was originally doing a single show/store
> pair for each, which added major code bloat and resulted in a ~80kb+
> module.

Yes, that is a nice thing to make code smaller.

thanks,

greg k-h

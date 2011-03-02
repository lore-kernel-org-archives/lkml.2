Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab1CBUhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 15:37:41 -0500
Received: from kroah.org ([198.145.64.141]:47615 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab1CBUhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 15:37:40 -0500
Date: Wed, 2 Mar 2011 15:38:23 -0500
From: Greg KH <greg@kroah.com>
To: Kumba <kumba@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Can I nest kobjects to create directories under parent
 directories for my driver?
Message-ID: <20110302203823.GA18879@kroah.com>
References: <4D6C68A4.3020306@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6C68A4.3020306@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 10:31:48PM -0500, Kumba wrote:
> So I'm attempting to write my first kernel driver for an RTC chip
> (Dallas/Maxim DS1685/DS1687), and running into a problem with using
> sysfs properly.  First off, a patch for this specific RTC was sent
> int to rtc-linux about two years ago, but never made it anywhere.  I
> based off of that and have pretty much re-written the thing since
> then.  It's undergoing a second re-write after some initial feedback
> from the rtc-linux folks.
> 
> What I'm trying to do, is, in sysfs, create individual attributes
> for the bits in each control register.  DS1685 defines 6 control
> registers (4 are the standard DS1286-style, and 2 are "extended" in
> another address bank).
> 
> I want to organize it such that:
> 
> # ls /sys/devices/platform/rtc-ds1685/
> driver@  misc/  modalias  nvram  regs/  rtc/  subsystem@  uevent
> 
> And in regs/:
> ctrla/  ctrlb/  ctrlc/  ctrld/  ctrl4a/  ctrl4b/

That's nice, but it really isn't a good idea to do things this deep.
Userspace tools will not be able to find things properly (like libudev)
and your kernel code will get very messy (as you have found out.)

Why not look at how the other rtc drivers work, they don't nest things
this deep and you need to sick with the standard userspace api and not
invent a new one if at all possible.

But to answer your question, you can do this, but I strongly discourage
it.

good luck,

greg k-h

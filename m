Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab1ELQss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:48:48 -0400
Received: from kroah.org ([198.145.64.141]:52515 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758061Ab1ELQsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:48:42 -0400
Date: Thu, 12 May 2011 09:44:02 -0700
From: Greg KH <greg@kroah.com>
To: Jason Stubbs <jasonbstubbs@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform: fix samsung brightness min/max calculations
Message-ID: <20110512164402.GD26585@kroah.com>
References: <201104201358.50443.jasonbstubbs@gmail.com>
 <201105111447.49816.jasonbstubbs@gmail.com>
 <20110511135114.GD12717@kroah.com>
 <201105121214.00015.jasonbstubbs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105121214.00015.jasonbstubbs@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 12:13:59PM +1000, Jason Stubbs wrote:
> On Wed, 11 May 2011 23:51:14 Greg KH wrote:
> > On Wed, May 11, 2011 at 02:47:49PM +1000, Jason Stubbs wrote:
> > > On Wed, 11 May 2011 08:39:08 Greg KH wrote:
> > > > On Thu, Apr 28, 2011 at 06:55:50PM +1000, Jason Stubbs wrote:
> > > > > Not sure of the "bump" process, so I'll just go over each part of the
> > > > > patch.
> > > > > 
> > > > > Note that all the changes only affect the sabi_config where
> > > > > min_brightness is 1 so you might not see in difference on your
> > > > > hardware.
> > > > 
> > > > This isn't needed anymore due to your other patch superseeding it,
> > > > right?
> > > 
> > > Actually, this one is irrelevant to the nc210/nc110 support as that
> > > laptop uses the "SwSmi@" sabi. It was just something I noticed while
> > > learning the code. The miscalculations will only affect any laptops that
> > > use the "SECLINUX" sabi but I tested it by setting min_brightness to 2
> > > for my laptop.
> > 
> > That's wierd, as that is the type of laptop I have here and it seems to
> > work just fine for me as-is.
> 
> Throwing a printk of user_level into set_brightness when min_brightness = 1,
> I get the following behaviour:
> 
> # cd /sys/class/backlight/samsung
> # for x in 8 7 2 1 0; do echo $x > brightness; done
> # dmesg | tail -n6
> user_level is 0x07
> user_level is 0x06
> user_level is 0x01
> user_level is 0x00
> user_level is 0xff
> samsung_laptop: SABI set command 0x11 failed with completion flag 0xaa and data 0xff
> 
> Essentially, setting brightness to the maximum actually sets it one less and
> setting it to zero does bad thngs.

Ah, ok, nice catch, thanks, I've queued up your patch now.

> > > The patch doesn't apply cleanly on top of the nc210/nc110 patch though as
> > > they both modify set_brightness(). It might apply with a higher fuzz
> > > factor as the changes don't actually clash. Should I redo the patch?
> > 
> > Please do.
> 
> Will send seperately. Doing this though, I found a problem with the
> nc210/nc110 patch in that (user_level == read_brightness()) check should
> actually be (user_brightness == read_brightness()). What should I do about
> this?

I don't know, as you seem to understand this better than I do at this
point, I'll trust your changes :)

thanks,

greg k-h

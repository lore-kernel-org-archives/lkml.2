Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab1CKRJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 12:09:13 -0500
Received: from kroah.org ([198.145.64.141]:43880 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab1CKRJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 12:09:12 -0500
Date: Fri, 11 Mar 2011 09:08:07 -0800
From: Greg KH <greg@kroah.com>
To: andy.green@linaro.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110311170807.GA10350@kroah.com>
References: <Pine.LNX.4.44L0.1103111141270.1975-100000@iolanthe.rowland.org>
 <4D7A5329.6080507@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7A5329.6080507@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 04:51:53PM +0000, Andy Green wrote:
> On 03/11/2011 04:45 PM, Somebody in the thread at some point said:
> 
> Hi -
> 
> >Or to put it another way...  With external, hot-plugged USB devices,
> >there is no need to know "how it is wired".  The fact that it is on a
> >USB bus is the only information necessary.  Why does anyone need to
> >know more than this for on-board USB devices?
> 
> For example, the USB device is a chip with option pins.  On the
> board it is placed on, some of the option pins are tied in a
> particular way that impacts its actual function, but can't be seen
> from the chip itself. The driver covers all the options, but it
> needs to be told which mode the chip was wired up for.

Then that information is in the driver that was written for that
specific device, it is NOT a class device if it requires this type of
information to work properly.

> Another example, it's a USB chip with GPIO pins, analogous to a I2C
> GPIO extender.  Some of the GPIO are wired to LEDs also on the
> board, which you want to expose as generic GPIO.  The board
> definition file is in a position to do all that because it knows
> what the board is and what it is wired up to.
> 
> That the USB chips in these examples are 'discoverable' has nothing
> to do with anything.  In fact the board definition file has
> knowledge about the "functional implemntation" of the instances of
> those chips -- just exactly those instances soldered to the board.
> If you plugged another of these chips, the board definition file has
> nothing to say about it because they are not "on the board" and
> in-scope for it.

Then put that information in the specific driver for this type of
device.

Also, do you have a real example of a USB driver today that needs this?

thanks,

greg k-h

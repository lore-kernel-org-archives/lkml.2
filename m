Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab2DYSfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:35:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56297 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab2DYSfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:35:47 -0400
Date: Wed, 25 Apr 2012 11:35:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Roland Stigge <stigge@antcom.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, stern@rowland.harvard.edu,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Subject: Re: [PATCH v5 1/3] USB: Add driver for NXP ISP1301 USB transceiver
Message-ID: <20120425183542.GA27617@kroah.com>
References: <1335002264-22225-1-git-send-email-stigge@antcom.de>
 <20120424232044.GA2657@kroah.com>
 <4F97B395.9020501@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F97B395.9020501@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 10:19:33AM +0200, Roland Stigge wrote:
> Hi Greg,
> 
> thanks for reviewing! I integrated all of your suggestions into the
> patch update, except ...
> 
> On 04/25/2012 01:20 AM, Greg KH wrote:
> > On Sat, Apr 21, 2012 at 11:57:42AM +0200, Roland Stigge wrote:
> >> This very-lowlevel driver registers the NXP ISP1301 chip via the I2C subsystem.
> >> The chip is the USB transceiver shared by ohci-nxp, lpc32xx_udc (gadget) and
> >> isp1301_omap.
> >>
> >> Following patches let the respective USB host and gadget drivers use this
> >> driver, instead of duplicating ISP1301 handling.
> >>
> >> Signed-off-by: Roland Stigge <stigge@antcom.de>
> >> Acked-by: Arnd Bergmann <arnd@arndb.de>
> >>
> >>  include/linux/usb/isp1301.h                       |   84 ++++++++++++++++++++++
> > 
> > Why this file?  You have a lot of register stuff in here that should be
> > in the .c file, right?  Only put what other files need in this .h file,
> > which shouldn't be much at all from what I can tell.
> 
> Right. At first sight, it doesn't look very elegant that the driver
> exposes the ISP1301 register set to the drivers using it. I discussed
> this design previously with Arnd on the mailing list and we agreed on
> the following: ISP1301 is a very low level driver that primarily
> separates out the I2C client registration of the ISP1301 chip (including
> instantiation via DT), used by other drivers, but it's still just a kind
> of helper driver for some OHCI and USB device drivers. Consider the
> ISP1301 driver as a register set extension of ohci-nxp, lpc32xx-udc and
> isp1301_omap, which in turn know best what to do with the low level
> functionality (individual ISP1301 registers and timing, see the
> different initialization strategies in those drivers). Those drivers
> previously internally duplicated ISP1301 register definitions which is
> solved by the new isp1301 driver.
> 
> Initially, I actually had register get/set functions defined in
> isp1301.h but it turned out that those trivial wrappers around standard
> i2c_smbus_*() better had been removed.
> 
> So what do you think?

Ok, that makes more sense, thanks for explaining it.  Perhaps you should
put that in the patch changelog entry itself, so others don't also have
that same question?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab2DYITk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:19:40 -0400
Received: from antcom.de ([188.40.178.216]:42533 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab2DYITg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:19:36 -0400
Message-ID: <4F97B395.9020501@antcom.de>
Date: Wed, 25 Apr 2012 10:19:33 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, stern@rowland.harvard.edu,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Subject: Re: [PATCH v5 1/3] USB: Add driver for NXP ISP1301 USB transceiver
References: <1335002264-22225-1-git-send-email-stigge@antcom.de> <20120424232044.GA2657@kroah.com>
In-Reply-To: <20120424232044.GA2657@kroah.com>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

thanks for reviewing! I integrated all of your suggestions into the
patch update, except ...

On 04/25/2012 01:20 AM, Greg KH wrote:
> On Sat, Apr 21, 2012 at 11:57:42AM +0200, Roland Stigge wrote:
>> This very-lowlevel driver registers the NXP ISP1301 chip via the I2C subsystem.
>> The chip is the USB transceiver shared by ohci-nxp, lpc32xx_udc (gadget) and
>> isp1301_omap.
>>
>> Following patches let the respective USB host and gadget drivers use this
>> driver, instead of duplicating ISP1301 handling.
>>
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>>
>>  include/linux/usb/isp1301.h                       |   84 ++++++++++++++++++++++
> 
> Why this file?  You have a lot of register stuff in here that should be
> in the .c file, right?  Only put what other files need in this .h file,
> which shouldn't be much at all from what I can tell.

Right. At first sight, it doesn't look very elegant that the driver
exposes the ISP1301 register set to the drivers using it. I discussed
this design previously with Arnd on the mailing list and we agreed on
the following: ISP1301 is a very low level driver that primarily
separates out the I2C client registration of the ISP1301 chip (including
instantiation via DT), used by other drivers, but it's still just a kind
of helper driver for some OHCI and USB device drivers. Consider the
ISP1301 driver as a register set extension of ohci-nxp, lpc32xx-udc and
isp1301_omap, which in turn know best what to do with the low level
functionality (individual ISP1301 registers and timing, see the
different initialization strategies in those drivers). Those drivers
previously internally duplicated ISP1301 register definitions which is
solved by the new isp1301 driver.

Initially, I actually had register get/set functions defined in
isp1301.h but it turned out that those trivial wrappers around standard
i2c_smbus_*() better had been removed.

So what do you think?

Thanks in advance,

Roland

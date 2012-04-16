Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab2DPQC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:02:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53141 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751173Ab2DPQC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:02:57 -0400
Date: Mon, 16 Apr 2012 12:02:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland Stigge <stigge@antcom.de>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kevin.wells@nxp.com>,
        <srinivas.bakki@nxp.com>, <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/3] USB: Add driver for NXP ISP1301 USB transceiver
In-Reply-To: <4F8C4028.5090602@antcom.de>
Message-ID: <Pine.LNX.4.44L0.1204161201480.1408-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012, Roland Stigge wrote:

> On 04/16/2012 05:09 PM, Alan Stern wrote:
> >>  drivers/usb/Makefile        |    5 ++
> >>  drivers/usb/misc/Kconfig    |   12 ++++++
> >>  drivers/usb/misc/Makefile   |    1 
> >>  drivers/usb/misc/isp1301.c  |   64 ++++++++++++++++++++++++++++++++++
> >>  include/linux/usb/isp1301.h |   82 ++++++++++++++++++++++++++++++++++++++++++++
> > 
> > You know, drivers/usb/misc is meant for miscellaneous USB device 
> > drivers.  Not for host or transceiver drivers.
> > 
> > You should put the new file somewhere else.  Maybe in the otg 
> > directory, although that may not be completely appropriate either.  
> > Maybe something under the host directory.
> 
> The driver is used by drivers in the following directories:
> 
> drivers/usb/host/    (ohci-nxp.c)
> drivers/usb/otg/     (isp1301_omap.c)
> drivers/usb/gadget/  (lpc32xx_udc.c)
> 
> So host/ and otg/ don't look much better.
> 
> Maybe one of (new):
> 
>     drivers/usb/transceiver/
>     drivers/usb/phy/
>     drivers/usb/lowlevel/
> 
> ?
> 
> Otherwise, I will put it in drivers/usb/otg/ even of it doesn't look
> better to me but the chip is advertised as "OTG transceiver". ;-)

I don't know.  Maybe Greg KH or Felipe Balbi will have a
recommendation.  But any of these alternatives would be better than
drivers/usb/misc/.

Alan Stern


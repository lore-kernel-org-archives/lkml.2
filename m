Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab2DPPwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:52:12 -0400
Received: from antcom.de ([188.40.178.216]:43719 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088Ab2DPPwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:52:10 -0400
Message-ID: <4F8C4028.5090602@antcom.de>
Date: Mon, 16 Apr 2012 17:52:08 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] USB: Add driver for NXP ISP1301 USB transceiver
References: <Pine.LNX.4.44L0.1204161106410.1408-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1204161106410.1408-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 05:09 PM, Alan Stern wrote:
>>  drivers/usb/Makefile        |    5 ++
>>  drivers/usb/misc/Kconfig    |   12 ++++++
>>  drivers/usb/misc/Makefile   |    1 
>>  drivers/usb/misc/isp1301.c  |   64 ++++++++++++++++++++++++++++++++++
>>  include/linux/usb/isp1301.h |   82 ++++++++++++++++++++++++++++++++++++++++++++
> 
> You know, drivers/usb/misc is meant for miscellaneous USB device 
> drivers.  Not for host or transceiver drivers.
> 
> You should put the new file somewhere else.  Maybe in the otg 
> directory, although that may not be completely appropriate either.  
> Maybe something under the host directory.

The driver is used by drivers in the following directories:

drivers/usb/host/    (ohci-nxp.c)
drivers/usb/otg/     (isp1301_omap.c)
drivers/usb/gadget/  (lpc32xx_udc.c)

So host/ and otg/ don't look much better.

Maybe one of (new):

    drivers/usb/transceiver/
    drivers/usb/phy/
    drivers/usb/lowlevel/

?

Otherwise, I will put it in drivers/usb/otg/ even of it doesn't look
better to me but the chip is advertised as "OTG transceiver". ;-)

Thanks in advance,

Roland

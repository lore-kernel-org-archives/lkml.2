Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab2CTSUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 14:20:17 -0400
Received: from antcom.de ([188.40.178.216]:45333 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab2CTSUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 14:20:14 -0400
Message-ID: <4F68CA5C.2090406@antcom.de>
Date: Tue, 20 Mar 2012 19:20:12 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH] USB: gadget driver for LPC32xx
References: <1332191930-2433-1-git-send-email-stigge@antcom.de> <201203192130.13583.arnd@arndb.de> <4F67B28D.3060500@antcom.de> <201203201301.50159.arnd@arndb.de>
In-Reply-To: <201203201301.50159.arnd@arndb.de>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 03/20/2012 02:01 PM, Arnd Bergmann wrote:
>> Maybe the right thing is a common low-level isp1301 interface defining
>> all the registers and providing low-level (I2C) access functions,
>> leaving all the "higher level"/"board specific" functions up to the
>> existing drivers?
>>
>> (I guess you meant drivers/usb/otg/isp1301_omap.c ?)
> 
> Yes, that sounds like a very good idea. Can you describe which part of
> the function isp1301 does? It's not clear how the layering between
> that and the platform driver should end up.

The ISP1301 is a relatively simple transceiver where the actual
differential USB signals end up being generated/decoded. It contains
some registers and is controlled via I2C to manipulate electrical
settings (pull up / power etc.).

At a first glance, I found the following drivers to be using it:

ohci-nxp (was: ohci-pnx4008 + ohci-lpc32xx)
isp1301_omap
lpc32xx_udc (WIP)

The common functions that all of them are using are some low-level
functions like read/write byte, read/write word. (For ohci-nxp, I used
smbus commands.) I propose exporting just the defines for all the
registers and their bits together with some accessor functions.

Would those be the correct places for header and driver:

drivers/usb/misc/isp1301.c
include/linux/usb/isp1301.h

?

As an example usage, I would let the next update of the lpc32xx_udc use
it and separately provide patches to make the other drivers above also
use it.

Thanks in advance,

Roland

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab2CTTWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 15:22:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58687 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab2CTTWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 15:22:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH] USB: gadget driver for LPC32xx
Date: Tue, 20 Mar 2012 19:21:50 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        srinivas.bakki@nxp.com
References: <1332191930-2433-1-git-send-email-stigge@antcom.de> <201203201301.50159.arnd@arndb.de> <4F68CA5C.2090406@antcom.de>
In-Reply-To: <4F68CA5C.2090406@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203201921.51253.arnd@arndb.de>
X-Provags-ID: V02:K0:eSPjZLcs1P03kESceWrutHS/5n4z62O3BapsVik6+oj
 RZemkVxAf15QLz/CACAft6zFButwAwd/ZU6KKjqR8HHwbhdbcD
 R0FFQTm4k1bU8r02xObkSTjnQ1yjkIss3le556x7FQvXC5v57a
 iOY35uzqv2GX7f+9tj65FGnkbH7zhq096tvzNfVaZhZkYstYtb
 ODlBOo/EknxYfzuRtZ9KOyIE6b5kA/RSX+Hu65HqjuBLtL7h4W
 URu6mC7jKbZ0nEPtlnieM/hvQjZ3HmskbJoZ1vnD3+Bd41QMlj
 mxYPjruUjcGd6ZE+5qFTyX+YxXWxGdFzK40nACXi2NUCyTeGNz
 A2eyJnjWjoHf+ciQkV6Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 March 2012, Roland Stigge wrote:
> The ISP1301 is a relatively simple transceiver where the actual
> differential USB signals end up being generated/decoded. It contains
> some registers and is controlled via I2C to manipulate electrical
> settings (pull up / power etc.).
> 
> At a first glance, I found the following drivers to be using it:
> 
> ohci-nxp (was: ohci-pnx4008 + ohci-lpc32xx)
> isp1301_omap
> lpc32xx_udc (WIP)
> 
> The common functions that all of them are using are some low-level
> functions like read/write byte, read/write word. (For ohci-nxp, I used
> smbus commands.) I propose exporting just the defines for all the
> registers and their bits together with some accessor functions.

Sounds great. 

> Would those be the correct places for header and driver:
> 
> drivers/usb/misc/isp1301.c
> include/linux/usb/isp1301.h

I believe drivers/usb/misc/ is for usb devices, not for usb hots
(otg or otherwise), but I'm not sure where else it would go.

> As an example usage, I would let the next update of the lpc32xx_udc use
> it and separately provide patches to make the other drivers above also
> use it.

Ok. One thing I'm not sure about is how you would pair the i2c
device with the platform specific driver. The easiest solution would
be to assume that there is always just one of each, so isp1301 binds
to the i2c device and exports functions to be used by the platform
driver. This would fail if you ever have more than one isp1301
in the system, but neither omap nor pnx4008 seem to be doing that.

I guess we can always add support for that later if needed, using
a device tree phandle link, or a pointer to the i2c device in
platform_data.

	Arnd

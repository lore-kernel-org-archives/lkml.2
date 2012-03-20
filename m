Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714Ab2CTQMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:12:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52764 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab2CTQMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:12:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH] USB: gadget driver for LPC32xx
Date: Tue, 20 Mar 2012 13:01:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        srinivas.bakki@nxp.com
References: <1332191930-2433-1-git-send-email-stigge@antcom.de> <201203192130.13583.arnd@arndb.de> <4F67B28D.3060500@antcom.de>
In-Reply-To: <4F67B28D.3060500@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203201301.50159.arnd@arndb.de>
X-Provags-ID: V02:K0:+eyL2XutZMTynwZltycqCMWGhRfba4YQrkmBmG4N8vV
 O7wJndqxOUhGw+vigA8/impVDcmi1S1YDJrDRsjB911Uumj3XE
 Ov1RtWO0uv6+UdqcC4wRUvcJ/GFQNljdWiWpnq2rbEaDlg1Lcz
 7qpOevTTEh7puZUe9DxVetT8QzZthCILvz3Ynz7LDySWlnWzaW
 hUWbSrr1qQuOgv77CxWHHtMflZaJrtQ04TRWEl/LrJw+tD4EYu
 C+XcITgEQaIMxk3I1Mr2tr2Dxb63sMqdxAwm63m6aDUrK1c/qX
 BXDgsoaFaslP+HctbrOS/HHD4f+19wC6EK/rT7JSXbUIvS1NKI
 hO2JrXnDXHz7SpACK9Pk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 March 2012, Roland Stigge wrote:
> Hi Arnd,
> 
> On 19/03/12 22:30, Arnd Bergmann wrote:
> > There is already a driver for the isp1301 otg part in the kernel, I don't
> > think we want to add another one.
> > 
> > From what I can tell, this shares a common ancestry with the omap version
> > but has diverged quite a bit. The best solution would really be to
> > bring the two back together and let them share a common base driver,
> > with the lpc32xx and omap specific bits in another file.
> 
> Yes, it's a good idea to share code where possible and consolidate into
> one driver.
> 
> Please consider:
> 
> The LPC32xx driver is actually using only 3 functions via isp1301:
> 
> isp1301_udc_configure()
> isp1301_set_powerstate()
> isp1301_pullup_set()
> 
> The first of those is LPC32xx specific. The power setting function is
> also done differently in isp1301_omap's power_up()/power_down() ("board
> specific"). For the pullups, there is not (yet?) a dedicated API in the
> OMAP driver, but it's really only two small I2C commands.
> 
> Are you still sure it's worth it to use a common driver when there is
> hardly shared code?

No, I guess I should have looked closed. I found a few common functions
and assumed that this would be the same driver.

> Maybe the right thing is a common low-level isp1301 interface defining
> all the registers and providing low-level (I2C) access functions,
> leaving all the "higher level"/"board specific" functions up to the
> existing drivers?
> 
> (I guess you meant drivers/usb/otg/isp1301_omap.c ?)

Yes, that sounds like a very good idea. Can you describe which part of
the function isp1301 does? It's not clear how the layering between
that and the platform driver should end up.

	Arnd

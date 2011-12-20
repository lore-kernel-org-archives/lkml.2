Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1LTUZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 15:25:18 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58262 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1LTUZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 15:25:14 -0500
MIME-Version: 1.0
In-Reply-To: <20111220110404.GD31842@legolas.emea.dhcp.ti.com>
References: <1324343717-7292-1-git-send-email-felipe.contreras@gmail.com>
	<1324343717-7292-5-git-send-email-felipe.contreras@gmail.com>
	<20111220110404.GD31842@legolas.emea.dhcp.ti.com>
Date: Tue, 20 Dec 2011 22:25:13 +0200
Message-ID: <CAMP44s2-ozKUrXsnjzQ7cNFiWSXeSUCfpVPPBJ9FxYGeh8WNOA@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] usb: simplify hdrc configuration
From: Felipe Contreras <felipe.contreras@gmail.com>
To: balbi@ti.com
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Vladimir Zapolskiy <vz@mleia.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>,
        Benoit Goby <benoit@android.com>, Li Yang <leoli@freescale.com>,
        "open list:MUSB MULTIPOINT H..." <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 1:04 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Dec 20, 2011 at 03:15:17AM +0200, Felipe Contreras wrote:
>> HDRC requires either NOP_USB_XCEIV or TWLX030_USB, and it selects the
>
> that's not entirely true. Like any USB Link controller, MUSB needs a PHY
> to work, but can be any off-the-shelf PHY. Nokia has used isp1704 and
> isp1707 for instance. I guess Nokia also used tusb1211 and none of them
> are listed there.

Then have a CONFIG_MUSB_PHY menu, or whatever.

> I would rather remove all the dependencies because the person compiling
> the kernel should know that a Link needs a PHY.

Are you serious? Most likely the person compiling the kernel doesn't
even know what PHY really means, and just wants the USB to f*cking
work.

> Maybe add a note
> somewhere stating that you should enable the PHY driver for your
> platform ?

You can say the same of pretty much all the dependencies in the
kernel: oh, just add a note saying that this depends on that. And how
would they know what a PHY driver is?

You already know the dependency, it only needs to be written down:
depends on CONFIG_MUSB_PHY. And then you have a menu for
CONFIG_MUSB_PHY and select the correct transceiver.

Right now it's pretty much impossible for a normal person to figure
out a working configuration on his/her own without just enabling
everything.

-- 
Felipe Contreras

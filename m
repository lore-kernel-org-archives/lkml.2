Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab2BIG3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 01:29:23 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49200 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2BIG3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 01:29:21 -0500
MIME-Version: 1.0
In-Reply-To: <201201241537.17194.tim01@iss.tu-darmstadt.de>
References: <201201241537.17194.tim01@iss.tu-darmstadt.de>
Date: Thu, 9 Feb 2012 00:29:15 -0600
Message-ID: <CAKWjMd66rTzM7AipQZsu-c0jDSNw_=CFHnN1Mms4WQp_4aaFWA@mail.gmail.com>
Subject: Re: newbie: phy platform interrupt config
From: Andy Fleming <afleming@gmail.com>
To: Tim Sander <tim01@iss.tu-darmstadt.de>
Cc: netdev@vger.kernel.org, Andy Fleming <afleming@freescale.com>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richard.cochran@omicron.at>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Decotigny <decot@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 8:37 AM, Tim Sander <tim01@iss.tu-darmstadt.de> wrote:
> Hi
>
> I would like to set the interrupt for the phy on the i.mx35 pcm43 in the file
> arch/arm/mach-imx/mach-pcm043.c. Unfortunatly i didn't find a way to specify
> it. So i want to set the field (struct phy_device*)->irq.
>
> What i managed so far is to request the gpio for the interrupt:
> #define IMX_PHY_IRQ IMX_GPIO_NR(2,7)
> gpio_request(IMX_PHY_IRQ, "FEC PHY irq");
> gpio_direction_input(IMX_PHY_IRQ);
>
> Now i guess the result of "gpio_to_irq(IMX_PHY_IRQ)" should go into some kind
> of argument to imx35_add_fec(pdata) which is a macro
> imx_add_fec(&imx35_fec_data, pdata).
> pdata is of type (?) struct fec_platform_data which contains phy_interface_t
> and unsigned char array. So i don't see a way to set the phy interrupt there.
>
> I tried search for a driver which set the phy irq but i didn't find any and
> setting the phy in the phy_fixup function is also not working since the
> interrupt seems not get registered when opening the device.
>
> So how do i set the phy interrupt line in the platform file?

Look in drivers/of/of_mdio.c.

It's the job of the mdio driver to set the IRQs for the device. I
don't honestly know why I designed it that way. I suspect it's because
the MDIO controller's driver is the entity most likely to communicate
directly with the platform code.

So wherever you set up your mdio bus, set the IRQs for all the PHYs on
the bus there.

Andy

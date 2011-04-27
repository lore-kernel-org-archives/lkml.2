Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab1D0WQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:16:55 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:4404 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab1D0WQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:16:54 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1303942612!3493269!8
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.69]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Kyungmin Park <kmpark@infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Nizette <bn@niasdigital.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 27 Apr 2011 17:16:42 -0500
Subject: RE: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Thread-Topic: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Thread-Index: AcwFJjBUjnA0bzC6QZybgn05BsJwEQAAEzyw
Message-ID: <0D753D10438DA54287A00B027084269764D26C391E@AUSP01VMBX24.collaborationhost.net>
References: <92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
	<20110418132629.12d9a106@lxorguk.ukuu.org.uk>
	<6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com>
	<20110419093855.36910400@lxorguk.ukuu.org.uk>
	<BANLkTimqpP2k1tBvRL0BXs9E-Q=3bh0C7Q@mail.gmail.com>
	<BANLkTint6DGgosVkjK-sveyA9SL9WVS4Mg@mail.gmail.com>
	<BANLkTinv-MSg5Sobg2X1cJpAwPkM1Gevcg@mail.gmail.com>
	<BANLkTi=Oc+y+31KugbEy66Mp96=bf_G8Mg@mail.gmail.com>
	<BANLkTinv_-6dJJXAWc=NFTceXGA9sabanA@mail.gmail.com>
	<20110420163238.5f0e5ea6@lxorguk.ukuu.org.uk>
 <20110427215509.GE17290@n2100.arm.linux.org.uk>
In-Reply-To: <20110427215509.GE17290@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 27, 2011 2:55 PM, Russell King wrote:
> On Wed, Apr 20, 2011 at 04:32:38PM +0100, Alan Cox wrote:
>>> Even if some people are only muxing pins that can also be used as GPIO,
>>> this is not always the case. We can shunt out the same pins to be used as
>>> I2C or SPI for example, that means this cannot be handled in a GPIO
>>> driver since it has nothing to do with GPIO pins at all.
>> 
>> It sounds very much to me like it belongs in the GPIO driver. That is the
>> one piece of code which knows what it is doing for all this configuration.
>
> I don't think so.  See PXA devices, where MFP (multifunction pin)
> configuration is entirely separate from GPIO - and there's some MFPs
> which don't even have GPIOs associated with them.
>
> If I'm reading the PXA930 MFP header file right, it also appears that
> GPIOs can be configured on to multiple different pins (eg, GPIO46 can
> be on GPIO46 or DF_nWE.  So refering to GPIO46 does not give you
> sufficient information for exactly what pin is to be configured here.
>
> To complicate matters, MFP configuration on PXA deals with stuff like
> low power mode configuration, drive strength, etc which is completely
> independent of the GPIO layer.

I agree with Russell.  The muxing goes way beyond GPIO use.

On the i.MX for example, the iomux is used to configured what the pads on the
chip are used for.  The pad configuration might be gpio related or it could be
setting the pad for use by one of the internal peripherals.

For instance, on the i.MX35 the uart3 rxd signal can appear on the pads: RTS2,
SD2_DATA0, ATA_DATA10, or FEC_TX_CLK.  All of these pads can also be configured
as a gpio or for use by some other on-board peripheral.

Also, like Russell mentions for the PXA930, some of the gpios can be routed to
multiple pins.  And some of the pads have no gpio use but multiple other uses.

Regards,
Hartley
Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945Ab1D0Vzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 17:55:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42968 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab1D0Vzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 17:55:36 -0400
Date: Wed, 27 Apr 2011 22:55:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kmpark@infradead.org>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Nizette <bn@niasdigital.com>, Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Message-ID: <20110427215509.GE17290@n2100.arm.linux.org.uk>
References: <92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com> <20110418132629.12d9a106@lxorguk.ukuu.org.uk> <6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com> <20110419093855.36910400@lxorguk.ukuu.org.uk> <BANLkTimqpP2k1tBvRL0BXs9E-Q=3bh0C7Q@mail.gmail.com> <BANLkTint6DGgosVkjK-sveyA9SL9WVS4Mg@mail.gmail.com> <BANLkTinv-MSg5Sobg2X1cJpAwPkM1Gevcg@mail.gmail.com> <BANLkTi=Oc+y+31KugbEy66Mp96=bf_G8Mg@mail.gmail.com> <BANLkTinv_-6dJJXAWc=NFTceXGA9sabanA@mail.gmail.com> <20110420163238.5f0e5ea6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420163238.5f0e5ea6@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 04:32:38PM +0100, Alan Cox wrote:
> > Even if some people are only muxing pins that can also be used as GPIO,
> > this is not always the case. We can shunt out the same pins to be used as
> > I2C or SPI for example, that means this cannot be handled in a GPIO
> > driver since it has nothing to do with GPIO pins at all.
> 
> It sounds very much to me like it belongs in the GPIO driver. That is the
> one piece of code which knows what it is doing for all this configuration.

I don't think so.  See PXA devices, where MFP (multifunction pin)
configuration is entirely separate from GPIO - and there's some MFPs
which don't even have GPIOs associated with them.

If I'm reading the PXA930 MFP header file right, it also appears that
GPIOs can be configured on to multiple different pins (eg, GPIO46 can
be on GPIO46 or DF_nWE.  So refering to GPIO46 does not give you
sufficient information for exactly what pin is to be configured here.

To complicate matters, MFP configuration on PXA deals with stuff like
low power mode configuration, drive strength, etc which is completely
independent of the GPIO layer.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934039Ab2EXSD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:03:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51839 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932910Ab2EXSDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:03:24 -0400
Date: Thu, 24 May 2012 19:03:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        marc@cpdesign.com.au, Shawn Guo <shawn.guo@freescale.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Message-ID: <20120524180320.GO5361@opensource.wolfsonmicro.com>
References: <201205221053.21792.marc@cpdesign.com.au>
 <CAOMZO5AYCSVT=s=rB3xPkz5SYEQQZ9q7f=rFbTbJkkVPk7Y7Vw@mail.gmail.com>
 <201205242338.41420.marc@cpdesign.com.au>
 <5844466.kI7qR0Os9A@laptop>
 <20120524163604.GM5361@opensource.wolfsonmicro.com>
 <20120524164101.GW3710@pengutronix.de>
 <CAOMZO5CZbQ9cjh+5Lj8R5hbYhizP891D01LuqbaRq8WTQs8zkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMZO5CZbQ9cjh+5Lj8R5hbYhizP891D01LuqbaRq8WTQs8zkQ@mail.gmail.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 02:39:02PM -0300, Fabio Estevam wrote:
> On Thu, May 24, 2012 at 1:41 PM, Uwe Kleine-König

> > The imx spi driver can do both (GPIO and hardware CS) because not all
> > pins that can do hardware CS are available as GPIO.

> Right, unfortunately on mx31 the SPI CS pins cannot be used as GPIOs.

> On mx51evk the SPI CS are used as GPIOs and that probably explains why
> it worked on mx51evk and fails on mx31pdk.

Oh dear, this affects regmap but it'll probably also affect other things
- how plausible is it that we'll be able to fix in the driver (assuming
it's not just hardware misprogramming)?  We can probably manage to come
up with something for regmap but it's the wrong level to fix things.

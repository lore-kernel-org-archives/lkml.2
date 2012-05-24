Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964856Ab2EXRjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:39:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42635 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab2EXRjF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:39:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120524164101.GW3710@pengutronix.de>
References: <201205221053.21792.marc@cpdesign.com.au>
	<CAOMZO5AYCSVT=s=rB3xPkz5SYEQQZ9q7f=rFbTbJkkVPk7Y7Vw@mail.gmail.com>
	<201205242338.41420.marc@cpdesign.com.au>
	<5844466.kI7qR0Os9A@laptop>
	<20120524163604.GM5361@opensource.wolfsonmicro.com>
	<20120524164101.GW3710@pengutronix.de>
Date: Thu, 24 May 2012 14:39:02 -0300
Message-ID: <CAOMZO5CZbQ9cjh+5Lj8R5hbYhizP891D01LuqbaRq8WTQs8zkQ@mail.gmail.com>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
From: Fabio Estevam <festevam@gmail.com>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        =?UTF-8?Q?Philippe_R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        marc@cpdesign.com.au, Shawn Guo <shawn.guo@freescale.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 1:41 PM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:

>> If this is actually the issue the usual fix for this if the SPI
>> controller hardware can't be persuaded to do the right thing is to put
>> the chip select pin in GPIO mode and manage it by hand, though looking
>> at the driver it appears it should be doingn that already.  If you
>> change to using the bitbanging SPI driver it should do the right thing
>> (but will obviously be hideously slow), that ought to be at least a good
>> reference for expected behaviour here.
> The imx spi driver can do both (GPIO and hardware CS) because not all
> pins that can do hardware CS are available as GPIO.

Right, unfortunately on mx31 the SPI CS pins cannot be used as GPIOs.

On mx51evk the SPI CS are used as GPIOs and that probably explains why
it worked on mx51evk and fails on mx31pdk.

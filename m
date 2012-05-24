Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab2EXTmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:42:39 -0400
Received: from smtp4.epfl.ch ([128.178.224.218]:51145 "HELO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755936Ab2EXTmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:42:37 -0400
Message-ID: <20120524214229.1038515zms1khf6t@webmail.epfl.ch>
Date: Thu, 24 May 2012 21:42:29 +0200
From: philippe.retornaz@epfl.ch
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Fabio Estevam <festevam@gmail.com>,
        Uwe =?iso-8859-1?b?S2xlaW5lLUv2bmln?= 
	<u.kleine-koenig@pengutronix.de>,
        marc@cpdesign.com.au, Shawn Guo <shawn.guo@freescale.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
References: <201205221053.21792.marc@cpdesign.com.au>
 <CAOMZO5AYCSVT=s=rB3xPkz5SYEQQZ9q7f=rFbTbJkkVPk7Y7Vw@mail.gmail.com>
 <201205242338.41420.marc@cpdesign.com.au> <5844466.kI7qR0Os9A@laptop>
 <20120524163604.GM5361@opensource.wolfsonmicro.com>
 <20120524164101.GW3710@pengutronix.de>
 <CAOMZO5CZbQ9cjh+5Lj8R5hbYhizP891D01LuqbaRq8WTQs8zkQ@mail.gmail.com>
 <20120524180320.GO5361@opensource.wolfsonmicro.com>
In-Reply-To: <20120524180320.GO5361@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.3.11)
X-EPFL-User: philippe.retornaz@EPFL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown <broonie@opensource.wolfsonmicro.com> a écrit :

> On Thu, May 24, 2012 at 02:39:02PM -0300, Fabio Estevam wrote:
>> On Thu, May 24, 2012 at 1:41 PM, Uwe Kleine-König
>
>> > The imx spi driver can do both (GPIO and hardware CS) because not all
>> > pins that can do hardware CS are available as GPIO.
>
>> Right, unfortunately on mx31 the SPI CS pins cannot be used as GPIOs.
>
>> On mx51evk the SPI CS are used as GPIOs and that probably explains why
>> it worked on mx51evk and fails on mx31pdk.
>
> Oh dear, this affects regmap but it'll probably also affect other things
> - how plausible is it that we'll be able to fix in the driver (assuming
> it's not just hardware misprogramming)?  We can probably manage to come
> up with something for regmap but it's the wrong level to fix things.
>

Sadly, after looking at the imx31 datasheet it seems it's a hardware  
limitation. We could maybe workaround it by using DMA to access the  
CSPI but even with dma, this would need a single transfer in order to  
keep the CS signal asserted.

Thus, we need to workaround this in the regmap-spi or mc13783-spi driver.
Either we find a way to have regmap-spi to use 32bits transfert or we  
implement a custom bus inside mc13783-spi.

Thanks,

Philippe

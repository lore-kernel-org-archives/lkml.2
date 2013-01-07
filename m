Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3AGXXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 18:23:44 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51989 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3AGXXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 18:23:42 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFT] regulator: lp8788-ldo: Use ldo->en_pin to check if
 regulator is enabled by external pin
Thread-Topic: [PATCH RFT] regulator: lp8788-ldo: Use ldo->en_pin to check if
 regulator is enabled by external pin
Thread-Index: AQHN6xcHWa3VEY62mE+Yi0u7YatEY5g9Mk0AgAFPqBA=
Date: Mon, 7 Jan 2013 23:23:26 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E11935@DQHE02.ent.ti.com>
References: <1357371223.22227.1.camel@phoenix>
 <20130107110818.GB4544@opensource.wolfsonmicro.com>
In-Reply-To: <20130107110818.GB4544@opensource.wolfsonmicro.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Monday, January 07, 2013 8:08 PM
> To: Axel Lin
> Cc: Kim, Milo; Girdwood, Liam; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH RFT] regulator: lp8788-ldo: Use ldo->en_pin to
> check if regulator is enabled by external pin
> 
> On Sat, Jan 05, 2013 at 03:33:43PM +0800, Axel Lin wrote:
> > ldo->en_pin is set iff the regulator is enabled by external pin.
> >
> > This patch sets ldo->en_pin to NULL if lp8788_gpio_request_ldo_en()
> fails, then
> > we can use it to determinate if the regulator is controlled by
> external pin or
> > register.
> 
> Applied, thanks.  However we should be converting the driver to use the
> core support for this - the GPIO can just be given to the core in the
> regulator config which should handle everything transparently.

Thanks, Mark!

I have a question.
Do you mean the dependency of CONFIG_GENERIC_GPIO in this driver?

If yes, lp8788-ldo driver still works.
If the gpio_request_one() gets failed on loading the driver, then the lp8788-ldo
 driver refers to register based by default.
So LDOs can be enabled/disabled by the I2C, not external GPIO pins.
In that case, GPIO functions are not invoked any more.

Milo





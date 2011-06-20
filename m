Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab1FTKRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:17:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56859 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753927Ab1FTKRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:17:42 -0400
Date: Mon, 20 Jun 2011 11:17:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: myungjoo.ham@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        dg77.kim@samsung.com, kyungmin.park@samsung.com,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 1/2] Samsung SoC ADC: use regulator (VDD for ADC).
Message-ID: <20110620101737.GA31864@opensource.wolfsonmicro.com>
References: <1308213003-6526-1-git-send-email-myungjoo.ham@samsung.com>
 <20110618150612.GA25163@sirena.org.uk>
 <BANLkTimHWJ=qgQOxQtBQd9u6-euf79PJTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimHWJ=qgQOxQtBQd9u6-euf79PJTA@mail.gmail.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 02:16:59PM +0900, MyungJoo Ham wrote:
> On Sun, Jun 19, 2011 at 12:06 AM, Mark Brown
> > On Thu, Jun 16, 2011 at 05:30:02PM +0900, MyungJoo Ham wrote:

> >> +     adc->vdd = regulator_get(dev, S3C_ADC_REGULATOR_NAME);

> > I'm not convinced that the #define for the name is terribly good style
> > here, especially given that you actually call it vdd in the code.

> Then, would it be fine to use as [ regulator_get(dev, "vdd"); ] ?

Yes.

> >> +     if (IS_ERR_OR_NULL(adc->vdd)) {
> >> +             dev_dbg(dev, "operating without regulator %s.\n", S3C_ADC_REGULATOR_NAME);
> >> +             adc->vdd = NULL; /* Do not control regulator */
> >> +     }
> >> +

> > No, don't do this.  Just unconditionally assume the regulator is present
> > if power is essential for use of the device.  The regulator API will
> > stub out correctly if it's not in use to allow things to proceed and if
> > vdd is genuinely not hooked up then the driver can't function.

> This ADC driver is for every ADC from S3C24xx series to Exynos4 (and
> its successors as well).
> The regulator (VDD for ADC) is essential for the recent chips
> (S5PC110, S5PV210, and Exynos4).
> I was just worried about the old boards using the same ADC driver
> (mach-s3c2410/mach-*.c, mach-s3c6410/mach-*.c, and so on) without
> ADC-VDD regulators defined.

If the regulator API is in use on a system it is reasonable to expect it
to be set up correctly for the system.

> However, no s3c compliance defconfigs have ever used CONFIG_REGULATOR.
> Thus, it seems that it's safe to enforce using "vdd" with regulators
> in plat-samsung's ADC driver.
> I'll proceed as you have commented.

Note that SMDK6410 and Cragganmore are both using regulators fairly
extensively.

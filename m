Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1FRPGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 11:06:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35304 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1FRPGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 11:06:21 -0400
Date: Sat, 18 Jun 2011 16:06:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        dg77.kim@samsung.com, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 1/2] Samsung SoC ADC: use regulator (VDD for ADC).
Message-ID: <20110618150612.GA25163@sirena.org.uk>
References: <1308213003-6526-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308213003-6526-1-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 05:30:02PM +0900, MyungJoo Ham wrote:

> +	adc->vdd = regulator_get(dev, S3C_ADC_REGULATOR_NAME);

I'm not convinced that the #define for the name is terribly good style
here, especially given that you actually call it vdd in the code.

> +	if (IS_ERR_OR_NULL(adc->vdd)) {
> +		dev_dbg(dev, "operating without regulator %s.\n", S3C_ADC_REGULATOR_NAME);
> +		adc->vdd = NULL; /* Do not control regulator */
> +	}
> +

No, don't do this.  Just unconditionally assume the regulator is present
if power is essential for use of the device.  The regulator API will
stub out correctly if it's not in use to allow things to proceed and if
vdd is genuinely not hooked up then the driver can't function.

> +	if (adc->vdd)
> +		regulator_enable(adc->vdd);

You're not checking the return value here or anywhere else after the
inital get().

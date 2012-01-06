Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab2AFRop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 12:44:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37752 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758864Ab2AFRon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 12:44:43 -0500
Date: Fri, 6 Jan 2012 09:44:39 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Laxman Dewangan <ldewangan.com@nvidia.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH V1] TPS62360: Add tps62360 regulator driver
Message-ID: <20120106174438.GA3485@opensource.wolfsonmicro.com>
References: <1325668818-1096-1-git-send-email-ldewangan@nvidia.com>
 <20120105062919.GI11867@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9E9B@BGMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9E9B@BGMAIL01.nvidia.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 07:18:25PM +0530, Laxman Dewangan wrote:

Please fix your mailer to word wrap at less than 80 columns.  I've
reflowed your text for legibility.

> > > +	/* Configure the output discharge path */
> > > +	st = tps62360_reg_modify_bits(tps, REG_RAMPCTRL, BIT(2), BIT(2));
> > > +	if (st < 0)
> > > +		dev_err(tps->dev, "%s() fails in updating reg %d\n",
> > > +			__func__, REG_RAMPCTRL);
> > > +}

> > I rather suspect that if this is worth doing it's also worth doing over
> > suspend...

> The discharge path should be only enabled when the output voltage will go to 0.
> If it stay in non-zero voltage and enabling discharge path  will consume more power.
> In suspend, it is not necessarily that voltage output will be 0 and hence it should not
> be enabled. In shutdown all power goes off from pmu and hence it is worth to enable
> discharge path for quick fall of output voltage.

> > 
> > > + * @vsel: Select the voltage id register.
> > 
> > What's this?
> There is 4 sets of voltage configuration register for voltage output. The power
> on reset values for this registers are different and selection of the voltage
> configuration register is done by 2 pins of the pmu chip which is board dependent.
> Based on board connection, it need to be program the desired voltage configuration
> Register to achieve the desired output.
> 

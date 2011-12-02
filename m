Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab1LBODI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 09:03:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50485 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756671Ab1LBODG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 09:03:06 -0500
Date: Fri, 2 Dec 2011 14:03:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH 01/11] MFD: DA9052 MFD core module v8
Message-ID: <20111202140304.GT8245@opensource.wolfsonmicro.com>
References: <1321607994.10344.20.camel@dhruva>
 <20111124120541.GG8470@opensource.wolfsonmicro.com>
 <C3AE124F08223B42BC95AEB82F0F6CED1F9CFD03@KCHJEXMB01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CED1F9CFD03@KCHJEXMB01.kpit.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 01:57:49PM +0000, Ashish Jangam wrote:
> > On Fri, Nov 18, 2011 at 02:49:54PM +0530, Ashish Jangam wrote:

> > > +	da9052_i2c->bustype = BUS_I2C;

> > bustype should be redundant now, it certianly doesn't seem to be
> > referred to in this patch.

> This is required in the TSI driver.

You can just query the bus_type of the struct device if you really need
this.

> > > + * Interrupt controller support for Dilaog DA9052 PMICs.

> > This looks very much like it could be replaced with regmap-irq.  The
> > code would be slightly less efficient due to the support for sparse
> > interrupt registers but it'd be less code.

> regmap-irq has a opaque struct regmap_irq_chip_data which has a member
> irq_base and this is required for non-primary irqs registration
> and also the clean-up function regmap_del_irq_chip() requires it.
> So as of now I will keep the current irq implementation as it is. 

I'm not sure how this is relevant to my above comment?  The struct is of
course opaque since it is only used by the implementation.

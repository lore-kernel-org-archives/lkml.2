Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab2JJD4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 23:56:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38851 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689Ab2JJD4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 23:56:32 -0400
Date: Wed, 10 Oct 2012 12:56:23 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <dchen@diasemi.com>, linux-kernel@vger.kernel.org
Subject: Re: [Patch v2 2/7] Regulator: DA9055 Regulator driver
Message-ID: <20121010035622.GH17288@opensource.wolfsonmicro.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED38A84E78@KCHJEXMB03.kpit.com>
 <1349780416.5244.39.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349780416.5244.39.camel@dhruva>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 04:30:16PM +0530, Ashish Jangam wrote:
> On Tue, 2012-10-09 at 15:37 +0530, Mark Brown wrote:
> > On Mon, Oct 08, 2012 at 07:00:39PM +0530, Ashish Jangam wrote:

> > > +		/* Set the GPIO I/P pin for controlling the regulator state. */
> > > +		ret = devm_gpio_request_one(config->dev, gpio, GPIOF_DIR_IN,
> > > +					    name);
> > > +		if (ret < 0)
> > > +			goto err;

> > We never actually appear to use this GPIO anywhere...  why are we
> > requesting it?

> DA9055 regulator changes its state by detecting the rising/failing edge at
> GPI DA9055. Therefore we just need to set the DA9055 GPIO direction to input.

Right, so there's several problems here.  One is that this code is very
obscure - you're really doing pinmux here rather than actually using it
as a GPIO, a better comment would clarify this.  The other is that
you're requiring a defined gpio_base in platform data, it would be
better to allow this to be dynamically assigned as the driver can find
it's own GPIOs easily enough.

> >   Also, why is the ability to read the regulator state via
> > a GPIO associated with controlling it via a GPIO, it's unusual for these
> > things to be tied together.

> There is no connection between state just to differentiate between two strings/labels.
> If required I can change the string.

It's nothing to do with the name, it's that it looks due to the above
like the input GPIO is used by the CPU to read the state of the device.

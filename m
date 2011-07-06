Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab1GFWpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 18:45:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41386 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752959Ab1GFWpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 18:45:04 -0400
Date: Wed, 6 Jul 2011 15:44:42 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: ashishj3 <ashish.jangam@kpitcummins.com>, grant@secretlab.ca,
        arnd@arndb.de, jic23@cam.ac.uk, linux-kernel@vger.kernel.org,
        Dajun <dajun.chen@diasemi.com>, linaro-dev@lists.linaro.org
Subject: Re: [PATCH 02/11] GPIO: DA9052 GPIO module v3
Message-ID: <20110706224442.GA13144@opensource.wolfsonmicro.com>
References: <1309948333.4168.8.camel@L-0532.kpit.com>
 <20110706163656.GF5805@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706163656.GF5805@ponder.secretlab.ca>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 10:36:56AM -0600, Grant Likely wrote:

> It looks like this needs to be merged via the MFD tree since it
> depends on the core da9052 driver patch.

Actually that's not such an issue for new MFDs - since the function
drivers all depend on the core driver they can't be enabled in Kconfig
until the MFD part has been merged so don't do any harm.

> > +static int da9052_gpio_to_irq(struct gpio_chip *gc, u32 offset)
> > +{
> > +	struct da9052_gpio *gpio = to_da9052_gpio(gc);
> > +	struct da9052 *da9052 = gpio->da9052;

> > +	return da9052->irq_base + DA9052_IRQ_GPI0 + offset;

> Who allocates the irq_descs for these irqs?

SoP for MFDs is to do this in the core as part of the larger block of
interrupts, the core driver is doing this.

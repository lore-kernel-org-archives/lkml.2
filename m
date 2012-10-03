Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab2JCSIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:08:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50557 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247Ab2JCSIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:08:12 -0400
Date: Wed, 3 Oct 2012 19:08:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, sameo@linux.intel.com,
        Marek Vasut <marex@denx.de>, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, arnd@arndb.de, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mfd: da9052-core: Use regmap_irq_get_virq() and fix
 the probe
Message-ID: <20121003180808.GH4360@opensource.wolfsonmicro.com>
References: <1348797458-2562-1-git-send-email-festevam@gmail.com>
 <20120928104944.GB30869@opensource.wolfsonmicro.com>
 <5065B534.7040602@freescale.com>
 <20120928142924.GA22101@opensource.wolfsonmicro.com>
 <CAOMZO5DgOjs06BJZWsEay-jP5pjzMNTZTZnvAvzAd-JD9kqs1g@mail.gmail.com>
 <20120928155121.GA22510@opensource.wolfsonmicro.com>
 <CAOMZO5CZ68vozBi4CZwLqFZreb9-Egnx6vi9RBGxgKJB+B2qwg@mail.gmail.com>
 <20121001102246.GE4360@opensource.wolfsonmicro.com>
 <CAOMZO5AKf0uL9p-cSd7D5XeB6Q9s5EPHDjAgwfkXGGXVLPreMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5AKf0uL9p-cSd7D5XeB6Q9s5EPHDjAgwfkXGGXVLPreMw@mail.gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 01:04:33PM -0300, Fabio Estevam wrote:
> On Mon, Oct 1, 2012 at 7:22 AM, Mark Brown

> > I don't understand what this irq_chip or the custom domain you're adding
> > are for?

> I declared da9052_irq_chip because I do the following:

> irq_set_chip_and_handler(virq, &da9052_irq_chip, handle_level_irq);

> I am following the arizona-irq approach.

> If this is not suitable, can you please point me to some driver that
> does not define irq_chip and can still do setup
> "irq_set_chip_and_handler()"?

Any other regmap-irq user.  The reason the Arizona driver is doing this
is that it has two interrupt controllers in it, one for the main chip
and one for the always on domain, which is why it registers two
regmap-irq domains.  Notice that there's only two subinterrupts in the
primary domain.

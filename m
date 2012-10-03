Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab2JCQEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:04:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43063 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab2JCQEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:04:34 -0400
MIME-Version: 1.0
In-Reply-To: <20121001102246.GE4360@opensource.wolfsonmicro.com>
References: <1348797458-2562-1-git-send-email-festevam@gmail.com>
	<20120928104944.GB30869@opensource.wolfsonmicro.com>
	<5065B534.7040602@freescale.com>
	<20120928142924.GA22101@opensource.wolfsonmicro.com>
	<CAOMZO5DgOjs06BJZWsEay-jP5pjzMNTZTZnvAvzAd-JD9kqs1g@mail.gmail.com>
	<20120928155121.GA22510@opensource.wolfsonmicro.com>
	<CAOMZO5CZ68vozBi4CZwLqFZreb9-Egnx6vi9RBGxgKJB+B2qwg@mail.gmail.com>
	<20121001102246.GE4360@opensource.wolfsonmicro.com>
Date: Wed, 3 Oct 2012 13:04:33 -0300
Message-ID: <CAOMZO5AKf0uL9p-cSd7D5XeB6Q9s5EPHDjAgwfkXGGXVLPreMw@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: da9052-core: Use regmap_irq_get_virq() and fix
 the probe
From: Fabio Estevam <festevam@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, sameo@linux.intel.com,
        Marek Vasut <marex@denx.de>, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, arnd@arndb.de, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 1, 2012 at 7:22 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Sep 28, 2012 at 05:34:18PM -0300, Fabio Estevam wrote:
>
>> +static struct irq_chip da9052_irq_chip = {
>> +     .name                   = "da9052",
>> +     .irq_disable            = da9052_irq_disable,
>> +     .irq_enable             = da9052_irq_enable,
>> +};
>
> I don't understand what this irq_chip or the custom domain you're adding
> are for?

I declared da9052_irq_chip because I do the following:

irq_set_chip_and_handler(virq, &da9052_irq_chip, handle_level_irq);

I am following the arizona-irq approach.

If this is not suitable, can you please point me to some driver that
does not define irq_chip and can still do setup
"irq_set_chip_and_handler()"?

Thanks,

Fabio Estevam

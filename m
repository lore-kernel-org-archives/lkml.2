Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab0LCLeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 06:34:06 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33471 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758423Ab0LCLeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 06:34:05 -0500
From: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Drivers <Drivers@analog.com>, "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Date: Fri, 3 Dec 2010 17:03:42 +0530
Subject: RE: [RFC 3/3] IIO: DDS: AD9833 / AD9834 driver
Thread-Topic: [RFC 3/3] IIO: DDS: AD9833 / AD9834 driver
Thread-Index: AcuSHNDjTuzI42DoRs2X9BqvrLAF2QAJXs3QACRGK4AAAm4wEA==
Message-ID: <0680EC522D0CC943BC586913CF3768C0041390E05A@dbde02.ent.ti.com>
References: <1291292489-32362-1-git-send-email-michael.hennerich@analog.com>
 <1291292489-32362-4-git-send-email-michael.hennerich@analog.com>
 <0680EC522D0CC943BC586913CF3768C0041390DDE7@dbde02.ent.ti.com>
 <544AC56F16B56944AEC3BD4E3D591771312F08227A@LIMKCMBX1.ad.analog.com>
In-Reply-To: <544AC56F16B56944AEC3BD4E3D591771312F08227A@LIMKCMBX1.ad.analog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel,
Just a thought not a comment. However I think error handling could be dealt later.

> -----Original Message-----
> From: Hennerich, Michael [mailto:Michael.Hennerich@analog.com]
> Sent: Friday, December 03, 2010 4:13 PM
> To: Datta, Shubhrajyoti; linux-iio@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: Drivers; jic23@cam.ac.uk; device-drivers-devel@blackfin.uclinux.org
> Subject: RE: [RFC 3/3] IIO: DDS: AD9833 / AD9834 driver
> 
> > Datta, Shubhrajyoti wrote on 2010-12-02:
> > > -----Original Message-----
> > > From: linux-iio-owner@vger.kernel.org [mailto:linux-iio-
> > > owner@vger.kernel.org] On Behalf Of michael.hennerich@analog.com
> > > Sent: Thursday, December 02, 2010 5:51 PM
> > > To: linux-iio@vger.kernel.org; linux-kernel@vger.kernel.org
> > > Cc: drivers@analog.com; jic23@cam.ac.uk; device-drivers-
> > > devel@blackfin.uclinux.org; Michael Hennerich
> > > Subject: [RFC 3/3] IIO: DDS: AD9833 / AD9834 driver
> > >
> > > From: Michael Hennerich <michael.hennerich@analog.com>
> > >
> > > Example driver using the proposed ABI
> > >
> > > Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> > > ---
> > >  drivers/staging/iio/dds/Kconfig  |    7 +
> > >  drivers/staging/iio/dds/Makefile |    1 +
> > >  drivers/staging/iio/dds/ad9834.c |  483
> > > ++++++++++++++++++++++++++++++++++++++
> > >  drivers/staging/iio/dds/ad9834.h |  112 +++++++++
> > >  4 files changed, 603 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/staging/iio/dds/ad9834.c
> > >  create mode 100644 drivers/staging/iio/dds/ad9834.h
> > >
> > > diff --git a/drivers/staging/iio/dds/Kconfig
> > > b/drivers/staging/iio/dds/Kconfig
> > > index 7969be2..4c9cce3 100644
> > > --- a/drivers/staging/iio/dds/Kconfig
> > > +++ b/drivers/staging/iio/dds/Kconfig
> > > @@ -17,6 +17,13 @@ config AD9832
> > >         Say yes here to build support for Analog Devices DDS chip
> > >         ad9832 and ad9835, provides direct access via sysfs.
> > >
> > > +config AD9834
> > > +     tristate "Analog Devices ad9833/4/ driver"
> > > +     depends on SPI
> > > +     help
> > > +       Say yes here to build support for Analog Devices DDS chip
> > > +       AD9833 and AD9834, provides direct access via sysfs.
> > > +
> > >  config AD9850
> > >       tristate "Analog Devices ad9850/1 driver"
> > >       depends on SPI
> > > diff --git a/drivers/staging/iio/dds/Makefile
> > > b/drivers/staging/iio/dds/Makefile
> > > index 6f274ac..1477461 100644
> > > --- a/drivers/staging/iio/dds/Makefile
> > > +++ b/drivers/staging/iio/dds/Makefile
> > > @@ -4,6 +4,7 @@
> > >
> > >  obj-$(CONFIG_AD5930) += ad5930.o
> > >  obj-$(CONFIG_AD9832) += ad9832.o
> > > +obj-$(CONFIG_AD9834) += ad9834.o
> > >  obj-$(CONFIG_AD9850) += ad9850.o
> > >  obj-$(CONFIG_AD9852) += ad9852.o
> > >  obj-$(CONFIG_AD9910) += ad9910.o
> > > diff --git a/drivers/staging/iio/dds/ad9834.c
> > > b/drivers/staging/iio/dds/ad9834.c
> > > new file mode 100644
> > > index 0000000..eb1fabf
> > > --- /dev/null
> > > +++ b/drivers/staging/iio/dds/ad9834.c
> > > @@ -0,0 +1,483 @@
> > > +/*
> > > + * AD9834 SPI DAC driver
> > > + *
> > > + * Copyright 2010 Analog Devices Inc.
> > > + *
> > > + * Licensed under the GPL-2 or later.
> > > + */
> > > +
> > > +#include <linux/interrupt.h>
> > > +#include <linux/workqueue.h>
> > > +#include <linux/device.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/sysfs.h>
> > > +#include <linux/list.h>
> > > +#include <linux/spi/spi.h>
> > > +#include <linux/regulator/consumer.h>
> > > +#include <linux/err.h>
> > > +#include <asm/div64.h>
> > > +
> > > +#include "../iio.h"
> > > +#include "../sysfs.h"
> > > +#include "dds.h"
> > > +
> > > +#include "ad9834.h"
> > > +
> > > +static unsigned int ad9834_calc_freqreg(unsigned long mclk, unsigned
> > long
> > > fout)
> > > +{
> > > +     unsigned long long freqreg = (u64) fout * (u64) (1 <<
> > > AD9834_FREQ_BITS);
> > > +     do_div(freqreg, mclk);
> > > +     return freqreg;
> > > +}
> > > +
> > > +static int ad9834_write_frequency(struct ad9834_state *st,
> > > +                               unsigned long addr, unsigned long
> > fout)
> > > +{
> > > +     unsigned long regval;
> > > +
> > > +     if (fout > (st->mclk / 2))
> > > +             return -EINVAL;
> > > +
> > > +     regval = ad9834_calc_freqreg(st->mclk, fout);
> > > +
> > > +     st->freq_data[0] = cpu_to_be16(addr | (regval &
> > > +                                    RES_MASK(AD9834_FREQ_BITS /
> > 2)));
> > > +     st->freq_data[1] = cpu_to_be16(addr | ((regval >>
> > > +                                    (AD9834_FREQ_BITS / 2)) &
> > > +                                    RES_MASK(AD9834_FREQ_BITS /
> > 2)));
> > > +
> > > +     return spi_sync(st->spi, &st->freq_msg);;
> > > +}
> > > +
> > > +static int ad9834_write_phase(struct ad9834_state *st,
> > > +                               unsigned long addr, unsigned long
> > phase)
> > > +{
> > > +     if (phase > (1 << AD9834_PHASE_BITS))
> > > +             return -EINVAL;
> > > +     st->data = cpu_to_be16(addr | phase);
> > > +
> > > +     return spi_sync(st->spi, &st->msg);
> > > +}
> > > +
> > > +static ssize_t ad9834_write(struct device *dev,
> > > +             struct device_attribute *attr,
> > > +             const char *buf,
> > > +             size_t len)
> > > +{
> > > +     struct iio_dev *dev_info = dev_get_drvdata(dev);
> > > +     struct ad9834_state *st = dev_info->dev_data;
> > > +     struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
> > > +     int ret;
> > > +     long val;
> > > +
> > > +     ret = strict_strtol(buf, 10, &val);
> > > +     if (ret)
> > > +             goto error_ret;
> > Could we do some bounds check.
> The functions called with val as argument from the switch cases below, do
> some bound checking, where necessary.
> It's questionable whether these simple enable switch cases, should return
> with
> error if someone writes something other than 0 or 1.

In that case we could we at least consider ret = strict_strtoul(buf, 10, &val);

> > > +
> > > +     mutex_lock(&dev_info->mlock);
> > > +     switch (this_attr->address) {
> > > +     case AD9834_REG_FREQ0:
> > > +     case AD9834_REG_FREQ1:
> > > +             ret = ad9834_write_frequency(st, this_attr->address,
> > val);
> > > +             break;
> > > +     case AD9834_REG_PHASE0:
> > > +     case AD9834_REG_PHASE1:
> > > +             ret = ad9834_write_phase(st, this_attr->address, val);
> > > +             break;
> > > +
> > > +     case AD9834_OPBITEN:
> > > +             if (st->control & AD9834_MODE) {
> > > +                     ret = -EINVAL;  /* AD9843 reserved mode */
> > > +                     break;
> > > +             }
> > > +
> > > +             if (val)
> > > +                     st->control &= ~AD9834_OPBITEN;
> > > +             else
> > > +                     st->control |= AD9834_OPBITEN;
Here you check for something other than 0 if the user passes -1 then it may go through.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab1KBO3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 10:29:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37266 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab1KBO3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 10:29:17 -0400
MIME-Version: 1.0
In-Reply-To: <20111025082815.GB4605@ponder.secretlab.ca>
References: <1319487676-27181-1-git-send-email-ricardo.ribalda@gmail.com>
 <1319487676-27181-6-git-send-email-ricardo.ribalda@gmail.com>
 <20111024214020.GC4394@ponder.secretlab.ca> <CAPybu_2vRWV6RiPtHvj17oTaDa-18FsFa_JhOhWv2k55B0ZaEg@mail.gmail.com>
 <20111025082815.GB4605@ponder.secretlab.ca>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 2 Nov 2011 15:28:36 +0100
Message-ID: <CAPybu_1yX85JkH-wVk3c76_-Q7miF_A01ZUEs_CMuta1OjdRsA@mail.gmail.com>
Subject: Re: [PATCHv4 5/6] Input: add CMR3000 gyrsocope driver
To: Grant Likely <grant.likely@secretlab.ca>
Cc: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        jic23@cam.ac.uk, aghayal@codeaurora.org, david@hardeman.nu,
        Shubhrajyoti@ti.com, saaguirre@ti.com, hemanthv@ti.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Grant

 Thanks for your feedback.  I think I will remove this patch from the
patchset, I am already in the 5th iteration :S... When the cma
supports devicetree and spi I will try to re-engineer this driver.

 Thanks again

On Tue, Oct 25, 2011 at 10:28, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Tue, Oct 25, 2011 at 09:26:10AM +0200, Ricardo Ribalda Delgado wrote:
>> Hello Grant
>>
>>  It is similar to the crm, because they came from the same
>> manufacturer and they share some commands, but that is all.
>>
>> the crm is a gyroscope and the cma is an accelerometer. I tried to put
>> both drivers together and the result was a bit too messy, I think it
>> is easier to understand as two separate drivers, but if you believe
>> they have to live together and help me making it more understandable,
>> I have to problem in coding it.
>
> Alternately, are there any parts of the cma driver that can be
> generalized and used by both?  A lot of the driver looks like
> boilerplate to me, which I'd rather not see duplicated.
>
> And I've filled in a few more comments below.
>
> g.
>
>>
>>    Regards!
>>
>> On Mon, Oct 24, 2011 at 23:40, Grant Likely <grant.likely@secretlab.ca> wrote:
>> > On Mon, Oct 24, 2011 at 10:21:15PM +0200, Ricardo Ribalda Delgado wrote:
>> >> Add support for CMR3000 Tri-axis accelerometer. CMR3000 supports both
>> >> I2C/SPI bus communication, currently the driver supports SPI
>> >> communication, since I have no hardware to test the I2C communication.
>> >
>> > How different is this driver from the cma3000?  Is it a cut and paste job?
>> >
>> > g.
>> >
>> >>
>> >> ---
>> >>
>> >> v4: Fixes suggested by Dmitry Torokhov
>> >>       -Do not release the input device until the irq has been released
>> >>
>> >> v3: Fixes suggested by Jonathan Cameron
>> >>       -Support DT
>> >>       -Cleaner spi read/write
>> >>
>> >> v2: Fixes suggested by Jonathan Cameron
>> >>       -Code Stype
>> >>       -Check pdata!=NULL
>> >>       -SPI align Cacheline
>> >>       -More clear based on
>> >>       -%s/set/write/
>> >>       -%s/accl/gyro/
>> >>       -remove READ/SET macros
>> >>
>> >> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>> >> ---
>> >>  drivers/input/misc/Kconfig           |   24 ++
>> >>  drivers/input/misc/Makefile          |    2 +
>> >>  drivers/input/misc/cmr3000_d0x.c     |  426 ++++++++++++++++++++++++++++++++++
>> >>  drivers/input/misc/cmr3000_d0x.h     |   45 ++++
>> >>  drivers/input/misc/cmr3000_d0x_spi.c |  144 ++++++++++++
>> >>  include/linux/input/cmr3000.h        |   54 +++++
>> >>  6 files changed, 695 insertions(+), 0 deletions(-)
>> >>  create mode 100644 drivers/input/misc/cmr3000_d0x.c
>> >>  create mode 100644 drivers/input/misc/cmr3000_d0x.h
>> >>  create mode 100644 drivers/input/misc/cmr3000_d0x_spi.c
>> >>  create mode 100644 include/linux/input/cmr3000.h
>> >>
>> >> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
>> >> index b9f2e93..7c56f94 100644
>> >> --- a/drivers/input/misc/Kconfig
>> >> +++ b/drivers/input/misc/Kconfig
>> >> @@ -524,6 +524,30 @@ config INPUT_CMA3000_SPI
>> >>         To compile this driver as a module, choose M here: the
>> >>         module will be called cma3000_d0x_spi.
>> >>
>> >> +config INPUT_CMR3000
>> >> +     tristate "VTI CMR3000 Tri-axis gyroscope"
>> >> +     help
>> >> +       Say Y here if you want to use VTI CMR3000_D0x Gyroscope
>> >> +       driver
>> >> +
>> >> +       This driver currently only supports SPI interface to the
>> >> +       controller. Also select the SPI method.
>> >> +
>> >> +       If unsure, say N
>> >> +
>> >> +       To compile this driver as a module, choose M here: the
>> >> +       module will be called cmr3000_d0x.
>> >> +
>> >> +config INPUT_CMR3000_SPI
>> >> +     tristate "Support SPI bus connection"
>> >> +     depends on INPUT_CMR3000 && SPI
>> >> +     help
>> >> +       Say Y here if you want to use VTI CMR3000_D0x Gyroscope
>> >> +       through SPI interface.
>> >> +
>> >> +       To compile this driver as a module, choose M here: the
>> >> +       module will be called cmr3000_d0x_spi.
>> >> +
>> >>  config INPUT_XEN_KBDDEV_FRONTEND
>> >>       tristate "Xen virtual keyboard and mouse support"
>> >>       depends on XEN_FBDEV_FRONTEND
>> >> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
>> >> index 7305f6f..c7fe09a 100644
>> >> --- a/drivers/input/misc/Makefile
>> >> +++ b/drivers/input/misc/Makefile
>> >> @@ -21,6 +21,8 @@ obj-$(CONFIG_INPUT_CM109)           += cm109.o
>> >>  obj-$(CONFIG_INPUT_CMA3000)          += cma3000_d0x.o
>> >>  obj-$(CONFIG_INPUT_CMA3000_I2C)              += cma3000_d0x_i2c.o
>> >>  obj-$(CONFIG_INPUT_CMA3000_SPI)              += cma3000_d0x_spi.o
>> >> +obj-$(CONFIG_INPUT_CMR3000)          += cmr3000_d0x.o
>> >> +obj-$(CONFIG_INPUT_CMR3000_SPI)              += cmr3000_d0x_spi.o
>> >>  obj-$(CONFIG_INPUT_COBALT_BTNS)              += cobalt_btns.o
>> >>  obj-$(CONFIG_INPUT_DM355EVM)         += dm355evm_keys.o
>> >>  obj-$(CONFIG_HP_SDC_RTC)             += hp_sdc_rtc.o
>> >> diff --git a/drivers/input/misc/cmr3000_d0x.c b/drivers/input/misc/cmr3000_d0x.c
>> >> new file mode 100644
>> >> index 0000000..d046149
>> >> --- /dev/null
>> >> +++ b/drivers/input/misc/cmr3000_d0x.c
>> >> @@ -0,0 +1,426 @@
>> >> +/*
>> >> + * VTI CMR3000_D0x Gyroscope driver
>> >> + *
>> >> + * Copyright (C) 2011 Qtechnology
>> >> + * Author: Ricardo Ribalda <ricardo.ribalda@gmail.com>
>> >> + *
>> >> + * Based on:
>> >> + *   drivers/input/misc/cma3000_d0x.c by: Hemanth V
>> >> + *
>> >> + * This program is free software; you can redistribute it and/or modify it
>> >> + * under the terms of the GNU General Public License version 2 as published by
>> >> + * the Free Software Foundation.
>> >> + *
>> >> + * This program is distributed in the hope that it will be useful, but WITHOUT
>> >> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> >> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> >> + * more details.
>> >> + *
>> >> + * You should have received a copy of the GNU General Public License along with
>> >> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> >> + */
>> >> +
>> >> +#include <linux/types.h>
>> >> +#include <linux/interrupt.h>
>> >> +#include <linux/delay.h>
>> >> +#include <linux/slab.h>
>> >> +#include <linux/input.h>
>> >> +#include <linux/input/cmr3000.h>
>> >> +#include <linux/of.h>
>> >> +
>> >> +#include "cmr3000_d0x.h"
>> >> +
>> >> +#define CMR3000_REV         0x21
>> >> +
>> >> +#define CMR3000_WHOAMI      0x00
>> >> +#define CMR3000_REVID       0x01
>> >> +#define CMR3000_CTRL        0x02
>> >> +#define CMR3000_STATUS      0x03
>> >> +#define CMR3000_X_LSB       0x0C
>> >> +#define CMR3000_X_MSB       0x0D
>> >> +#define CMR3000_Y_LSB       0x0E
>> >> +#define CMR3000_Y_MSB       0x0F
>> >> +#define CMR3000_Z_LSB       0x10
>> >> +#define CMR3000_Z_MSB       0x11
>> >> +#define CMR3000_I2C_ADDR    0x22
>> >> +#define CMR3000_PDR         0x26
>> >> +
>> >> +#define CMR3000_IRQDIS     (1 << 0)
>> >> +#define CMR3000_MODEMASK   (3 << 1)
>> >> +#define CMR3000_BUSI2C     (0 << 4)
>> >> +#define CMR3000_BUSSPI     (1 << 4)
>> >> +#define CMR3000_INTLOW     (1 << 6)
>> >> +#define CMR3000_INTHIGH    (0 << 6)
>> >> +#define CMR3000_RST        (1 << 7)
>> >> +
>> >> +#define CMRMODE_SHIFT      1
>> >> +#define CMRIRQLEVEL_SHIFT  6
>> >> +
>> >> +#define CMR3000_STATUS_PERR    (1 << 0)
>> >> +#define CMR3000_STATUS_PORST   (1 << 3)
>> >> +
>> >> +/* Settling time delay in ms */
>> >> +#define CMR3000_SETDELAY    30
>> >> +
>> >> +/*
>> >> + * Bit weights mult/div in dps for bit 0, other bits need
>> >> + * multipy factor 2^n. 11th bit is the sign bit.
>> >> + */
>> >> +#define BIT_TO_DPS_MUL  3
>> >> +#define BIT_TO_DPS_DIV 32
>> >> +
>> >> +static struct cmr3000_platform_data cmr3000_default_pdata = {
>> >> +     .irq_level = CMR3000_INTHIGH,
>> >> +     .mode = CMRMODE_MEAS80,
>> >> +     .fuzz_x = 1,
>> >> +     .fuzz_y = 1,
>> >> +     .fuzz_z = 1,
>> >> +     .irqflags = 0,
>> >> +};
>> >> +
>> >> +struct cmr3000_gyro_data {
>> >> +     const struct cmr3000_bus_ops *bus_ops;
>> >> +     struct cmr3000_platform_data pdata;
>> >> +
>> >> +     struct device *dev;
>> >> +     struct input_dev *input_dev;
>> >> +
>> >> +     int irq_level;
>> >> +     u8 mode;
>> >> +
>> >> +     int bit_to_mg;
>> >> +     int irq;
>> >> +
>> >> +     struct mutex mutex;
>> >> +     bool opened;
>> >> +     bool suspended;
>> >> +};
>> >> +
>> >> +static void decode_dps(struct cmr3000_gyro_data *data, int *datax,
>> >> +                    int *datay, int *dataz)
>> >> +{
>> >> +     /* Data in 2's complement, convert to dps */
>> >> +     *datax = (((s16) ((*datax) << 2)) * BIT_TO_DPS_MUL) / BIT_TO_DPS_DIV;
>> >> +     *datay = (((s16) ((*datay) << 2)) * BIT_TO_DPS_MUL) / BIT_TO_DPS_DIV;
>> >> +     *dataz = (((s16) ((*dataz) << 2)) * BIT_TO_DPS_MUL) / BIT_TO_DPS_DIV;
>> >> +}
>> >> +
>> >> +static irqreturn_t cmr3000_thread_irq(int irq, void *dev_id)
>> >> +{
>> >> +     struct cmr3000_gyro_data *data = dev_id;
>> >> +     int datax, datay, dataz;
>> >> +     u8 mode, intr_status;
>> >> +
>> >> +     intr_status = data->bus_ops->read(data->dev, CMR3000_STATUS,
>> >> +                                                     "irq status");
>> >> +     intr_status = data->bus_ops->read(data->dev, CMR3000_CTRL,
>> >> +                                                     "control mode");
>> >> +     if (intr_status < 0)
>> >> +             return IRQ_NONE;
>> >> +
>> >> +     /* Interrupt not for this device */
>> >> +     if (intr_status & CMR3000_IRQDIS)
>> >> +             return IRQ_NONE;
>> >> +
>> >> +     mode = (intr_status & CMR3000_MODEMASK) >> CMRMODE_SHIFT;
>> >> +     if ((mode != CMRMODE_MEAS80)
>> >> +         && (mode != CMRMODE_MEAS20))
>> >> +             return IRQ_NONE;
>> >> +
>> >> +     datax = (data->bus_ops->read(data->dev, CMR3000_X_MSB, "X_MSB")) << 8;
>> >> +     datax |= data->bus_ops->read(data->dev, CMR3000_X_LSB, "X_LSB");
>> >> +     datay = (data->bus_ops->read(data->dev, CMR3000_Y_MSB, "Y_MSB")) << 8;
>> >> +     datay |= data->bus_ops->read(data->dev, CMR3000_Y_LSB, "Y_LSB");
>> >> +     dataz = (data->bus_ops->read(data->dev, CMR3000_Z_MSB, "Z_MSB")) << 8;
>> >> +     dataz |= data->bus_ops->read(data->dev, CMR3000_Z_LSB, "Z_LSB");
>> >> +
>> >> +     /* Device closed */
>> >> +     if ((data->mode != CMRMODE_MEAS80)
>> >> +         && (data->mode != CMRMODE_MEAS20))
>> >> +             return IRQ_NONE;
>> >> +
>> >> +     /* Decode register values to dps */
>> >> +     decode_dps(data, &datax, &datay, &dataz);
>> >> +
>> >> +     input_report_abs(data->input_dev, ABS_X, datax);
>> >> +     input_report_abs(data->input_dev, ABS_Y, datay);
>> >> +     input_report_abs(data->input_dev, ABS_Z, dataz);
>> >> +     input_sync(data->input_dev);
>> >> +
>> >> +     return IRQ_HANDLED;
>> >> +}
>> >> +
>> >> +static int cmr3000_poweron(struct cmr3000_gyro_data *data)
>> >> +{
>> >> +     const struct cmr3000_platform_data *pdata = &data->pdata;
>> >> +     u8 ctrl;
>> >> +     int ret;
>> >> +
>> >> +     ctrl = pdata->irq_level << CMRIRQLEVEL_SHIFT;
>> >> +     ctrl |= data->mode << CMRMODE_SHIFT;
>> >> +     ctrl |= data->bus_ops->ctrl_mod;
>> >> +     ret = data->bus_ops->write(data->dev, CMR3000_CTRL, ctrl,
>> >> +                                                     "Mode setting");
>> >> +     if (ret < 0)
>> >> +             return -EIO;
>> >> +
>> >> +     msleep(CMR3000_SETDELAY);
>> >> +
>> >> +     return 0;
>> >> +}
>> >> +
>> >> +static int cmr3000_poweroff(struct cmr3000_gyro_data *data)
>> >> +{
>> >> +     int ret;
>> >> +     u8 ctrl = CMRMODE_POFF;
>> >> +
>> >> +     ctrl |= data->bus_ops->ctrl_mod;
>> >> +     ctrl |= CMR3000_IRQDIS;
>> >> +
>> >> +     ret = data->bus_ops->write(data->dev, CMR3000_CTRL, ctrl,
>> >> +                                                     "Mode setting");
>> >> +     msleep(CMR3000_SETDELAY);
>> >> +
>> >> +     return ret;
>> >> +}
>> >> +
>> >> +static int cmr3000_reset(struct cmr3000_gyro_data *data)
>> >> +{
>> >> +     int val;
>> >> +
>> >> +     /* Reset chip */
>> >> +     data->bus_ops->write(data->dev, CMR3000_CTRL, CMR3000_RST, "Reset");
>> >> +     mdelay(2);
>> >> +
>> >> +     /* Settling time delay */
>> >> +     val = data->bus_ops->read(data->dev, CMR3000_STATUS, "Status");
>> >> +     if (val < 0) {
>> >> +             dev_err(data->dev, "Reset failed\n");
>> >> +             return val;
>> >> +     }
>> >> +
>> >> +     if (val & CMR3000_STATUS_PERR) {
>> >> +             dev_err(data->dev, "Parity Error\n");
>> >> +             return -EIO;
>> >> +     }
>> >> +
>> >> +     return cmr3000_poweroff(data);
>> >> +}
>> >> +
>> >> +static int cmr3000_open(struct input_dev *input_dev)
>> >> +{
>> >> +     struct cmr3000_gyro_data *data = input_get_drvdata(input_dev);
>> >> +
>> >> +     mutex_lock(&data->mutex);
>> >> +
>> >> +     if (!data->suspended)
>> >> +             cmr3000_poweron(data);
>> >> +
>> >> +     data->opened = true;
>> >> +
>> >> +     mutex_unlock(&data->mutex);
>> >> +
>> >> +     return 0;
>> >> +}
>> >> +
>> >> +static void cmr3000_close(struct input_dev *input_dev)
>> >> +{
>> >> +     struct cmr3000_gyro_data *data = input_get_drvdata(input_dev);
>> >> +
>> >> +     mutex_lock(&data->mutex);
>> >> +
>> >> +     if (!data->suspended)
>> >> +             cmr3000_poweroff(data);
>> >> +
>> >> +     data->opened = false;
>> >> +
>> >> +     mutex_unlock(&data->mutex);
>> >> +}
>> >> +
>> >> +void cmr3000_suspend(struct cmr3000_gyro_data *data)
>> >> +{
>> >> +     mutex_lock(&data->mutex);
>> >> +
>> >> +     if (!data->suspended && data->opened)
>> >> +             cmr3000_poweroff(data);
>> >> +
>> >> +     data->suspended = true;
>> >> +
>> >> +     mutex_unlock(&data->mutex);
>> >> +}
>> >> +EXPORT_SYMBOL(cmr3000_suspend);
>> >> +
>> >> +void cmr3000_resume(struct cmr3000_gyro_data *data)
>> >> +{
>> >> +     mutex_lock(&data->mutex);
>> >> +
>> >> +     if (data->suspended && data->opened)
>> >> +             cmr3000_poweron(data);
>> >> +
>> >> +     data->suspended = false;
>> >> +
>> >> +     mutex_unlock(&data->mutex);
>> >> +}
>> >> +EXPORT_SYMBOL(cmr3000_resume);
>
> These four functions bother me.  All they are doing is wrapping
> poweron/poweroff operation.  It makes me wonder what is missing from
> core code that makes this song-and-dance necessary (or is there
> something available in core code that this driver should be using).
>
>> >> +
>> >> +#ifdef CONFIG_OF
>> >> +void cmr3000_get_pdata_of(struct device *dev, struct cmr3000_gyro_data *data)
>> >> +{
>> >> +     const __be32 *property;
>> >> +     int len;
>> >> +
>> >> +     property = of_get_property(dev->of_node, "vti,irq_level", &len);
>> >> +     if (property && len == sizeof(int))
>> >> +             data->pdata.irq_level = be32_to_cpup(property);
>> >> +
>> >> +     property = of_get_property(dev->of_node, "vti,mode", &len);
>> >> +     if (property && len == sizeof(int))
>> >> +             data->pdata.mode = be32_to_cpup(property);
>> >> +
>> >> +     property = of_get_property(dev->of_node, "vti,fuzz_x", &len);
>> >> +     if (property && len == sizeof(int))
>> >> +             data->pdata.fuzz_x = be32_to_cpup(property);
>> >> +
>> >> +     property = of_get_property(dev->of_node, "vti,fuzz_y", &len);
>> >> +     if (property && len == sizeof(int))
>> >> +             data->pdata.fuzz_y = be32_to_cpup(property);
>> >> +
>> >> +     property = of_get_property(dev->of_node, "vti,fuzz_z", &len);
>> >> +     if (property && len == sizeof(int))
>> >> +             data->pdata.fuzz_z = be32_to_cpup(property);
>> >> +
>> >> +     property = of_get_property(dev->of_node, "vti,irqflags", &len);
>> >> +     if (property && len == sizeof(int))
>> >> +             data->pdata.irqflags = be32_to_cpup(property);
>> >> +
>> >> +     return;
>> >> +}
>> >> +#endif
>> >> +
>> >> +struct cmr3000_gyro_data *cmr3000_init(struct device *dev, int irq,
>> >> +                                    const struct cmr3000_bus_ops *bops)
>> >> +{
>> >> +     struct cmr3000_platform_data *pdata;
>> >> +     struct cmr3000_gyro_data *data;
>> >> +     struct input_dev *input_dev;
>> >> +     int rev;
>> >> +     int error;
>> >> +
>> >> +     /* if no IRQ return error */
>> >> +     if (irq == 0) {
>> >> +             error = -EINVAL;
>> >> +             goto err_out;
>> >> +     }
>> >> +
>> >> +     data = kzalloc(sizeof(struct cmr3000_gyro_data), GFP_KERNEL);
>
> Consider devm_kzalloc() so the driver doesn't need to worry about
> rewinding it.
>
> Also, use 'sizeof(*data)' it's safer.
>
> g.
>



-- 
Ricardo Ribalda

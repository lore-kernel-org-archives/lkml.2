Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab0GHP7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 11:59:22 -0400
Received: from imr3.ericy.com ([198.24.6.13]:44075 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757874Ab0GHP7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 11:59:20 -0400
Date: Thu, 8 Jul 2010 08:59:14 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Paul Goyette <paul@whooppee.com>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: Add support for JEDEC JC 42.4 compliant
 temperature sensors
Message-ID: <20100708155914.GA12003@ericsson.com>
References: <1278598294-6974-1-git-send-email-guenter.roeck@ericsson.com>
 <Pine.NEB.4.64.1007080827210.29536@quicky.whooppee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Pine.NEB.4.64.1007080827210.29536@quicky.whooppee.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 11:28:07AM -0400, Paul Goyette wrote:
> 
> You might want to include the MAXIM 6604 chip as well.  This has been
> part of my initial NetBSD sdtemp(4) driver since I wrote it...
> 
> #define MAXIM_MANUFACTURER_ID           0x004D
> #define MAX_6604_DEVICE_ID              0x3E00
> #define MAX_6604_MASK                   0xFFFF
> 
Sure, will do. Also, good idea to use only one define per manufacturer -
I'll update the other defines to reflect that.

Guenter

> 
> On Thu, 8 Jul 2010, Guenter Roeck wrote:
> 
> > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > ---
> > Documentation/hwmon/jc42 |   86 +++++++
> > MAINTAINERS              |    7 +
> > drivers/hwmon/Kconfig    |   11 +
> > drivers/hwmon/Makefile   |    1 +
> > drivers/hwmon/jc42.c     |  575 ++++++++++++++++++++++++++++++++++++++++++++++
> > 5 files changed, 680 insertions(+), 0 deletions(-)
> > create mode 100644 Documentation/hwmon/jc42
> > create mode 100644 drivers/hwmon/jc42.c
> >
> > diff --git a/Documentation/hwmon/jc42 b/Documentation/hwmon/jc42
> > new file mode 100644
> > index 0000000..f7c9701
> > --- /dev/null
> > +++ b/Documentation/hwmon/jc42
> > @@ -0,0 +1,86 @@
> > +Kernel driver jc42
> > +==================
> > +
> > +Supported chips:
> > +  * Analog Devices ADT7408
> > +    Prefix: 'adt7408'
> > +    Addresses scanned: I2C 0x18 - 0x1f
> > +    Datasheets:
> > +        http://www.analog.com/static/imported-files/data_sheets/ADT7408.pdf
> > +  * NXP Semiconductors SE97, SE97B
> > +    Prefix: 'se97'
> > +    Addresses scanned: I2C 0x18 - 0x1f
> > +    Datasheets:
> > +        http://www.nxp.com/documents/data_sheet/SE97.pdf
> > +        http://www.nxp.com/documents/data_sheet/SE97B.pdf
> > +  * NXP Semiconductors SE98
> > +    Prefix: 'se98'
> > +    Addresses scanned: I2C 0x18 - 0x1f
> > +    Datasheets:
> > +     http://www.nxp.com/documents/data_sheet/SE98.pdf
> > +  * Microchip MCP9805, MCP98242, MCP98243, MCP9843
> > +    Prefixes: 'mcp9805', 'mcp98242', 'mcp98243', 'mcp9843'
> > +    Addresses scanned: I2C 0x18 - 0x1f
> > +    Datasheets:
> > +        http://ww1.microchip.com/downloads/en/DeviceDoc/21977b.pdf
> > +        http://ww1.microchip.com/downloads/en/DeviceDoc/21996a.pdf
> > +        http://ww1.microchip.com/downloads/en/DeviceDoc/22153c.pdf
> > +  * ON Semiconductor CAT34TS02, CAT6095
> > +    Prefix: 'cat34ts02', 'cat6095'
> > +    Addresses scanned: I2C 0x18 - 0x1f
> > +    Datasheet:
> > +        http://www.onsemi.com/pub_link/Collateral/CAT34TS02-D.PDF
> > +        http://www.onsemi.com/pub/Collateral/CAT6095-D.PDF
> > +  * ST Microelectronics STTS424, STTS424E02
> > +    Prefix: 'stts424'
> > +    Addresses scanned: I2C 0x18 - 0x1f
> > +    Datasheets:
> > +        http://www.st.com/stonline/products/literature/ds/13447/stts424.pdf
> > +        http://www.st.com/stonline/products/literature/ds/13448/stts424e02.pdf
> > +  * JEDEC JC 42.4 compliant temperature sensor chips
> > +    Prefix: 'jc42'
> > +    Addresses scanned: I2C 0x18 - 0x1f
> > +    Datasheet: -
> > +
> > +Author:
> > +        Guenter Roeck <guenter.roeck@ericsson.com>
> > +
> > +
> > +Description
> > +-----------
> > +
> > +This driver implements support for JEDEC JC 42.4 compliant temperature sensors.
> > +The driver auto-detects the chips listed above, but can be manually instantiated
> > +to support other JC 42.4 compliant chips.
> > +
> > +Example: the following will load the driver for a generic JC 42.4 compliant
> > +temperature sensor at address 0x18 on I2C bus #1:
> > +
> > +# modprobe jc42
> > +# echo jc42 0x18 > /sys/bus/i2c/devices/i2c-1/new_device
> > +
> > +A JC 42.4 compliant chip supports a single temperature sensor. Minimum, maximum,
> > +and critical temperature can be configured. There are alarms for high, low,
> > +and critical thresholds.
> > +
> > +There is also an hysteresis to control the thresholds for resetting alarms.
> > +Per JC 42.4 specification, the hysteresis threshold can be configured to 0, 1.5,
> > +3.0, and 6.0 degrees C. Configured hysteresis values will be rounded to those
> > +limits. The chip supports only a single register to configure the hysteresis,
> > +which applies to all limits. This register can be written by writing into
> > +temp1_crit_hyst. Other hysteresis attributes are read-only.
> > +
> > +Sysfs entries
> > +-------------
> > +
> > +temp1_input          Temperature (RO)
> > +temp1_min            Minimum temperature (RW)
> > +temp1_max            Maximum temperature (RW)
> > +temp1_crit           Critical high temperature (RW)
> > +
> > +temp1_crit_hyst              Critical hysteresis temperature (RW)
> > +temp1_max_hyst               Maximum hysteresis temperature (RO)
> > +
> > +temp1_min_alarm              Temperature low alarm
> > +temp1_max_alarm              Temperature high alarm
> > +temp1_crit_alarm     Temperature critical alarm
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index a07a49d..c7e4841 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -3182,6 +3182,13 @@ F:     Documentation/video4linux/*.ivtv
> > F:    drivers/media/video/ivtv/
> > F:    include/linux/ivtv*
> >
> > +JC42.4 TEMPERATURE SENSOR DRIVER
> > +M:   Guenter Roeck <linux@roeck-us.net>
> > +L:   lm-sensors@lm-sensors.org
> > +S:   Maintained
> > +F:   drivers/hwmon/jc42.c
> > +F:   Documentation/hwmon/jc42
> > +
> > JFS FILESYSTEM
> > M:    Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> > L:    jfs-discussion@lists.sourceforge.net
> > diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> > index e19cf8e..cf0d99b 100644
> > --- a/drivers/hwmon/Kconfig
> > +++ b/drivers/hwmon/Kconfig
> > @@ -446,6 +446,17 @@ config SENSORS_IT87
> >         This driver can also be built as a module.  If so, the module
> >         will be called it87.
> >
> > +config SENSORS_JC42
> > +     tristate "JEDEC JC42.4 compliant temperature sensors"
> > +     help
> > +       If you say yes here you get support for Jedec JC42.4 compliant
> > +       temperature sensors. Support will include, but not be limited to,
> > +       ADT7408, SE97, SE98, MCP9805, MCP98242, MCP98243, MCP9843, CAT34TS02,
> > +       CAT6095, and STTS424.
> > +
> > +       This driver can also be built as a module.  If so, the module
> > +       will be called jc42.
> > +
> > config SENSORS_LM63
> >       tristate "National Semiconductor LM63 and LM64"
> >       depends on I2C
> > diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> > index 2138ceb..6a93615 100644
> > --- a/drivers/hwmon/Makefile
> > +++ b/drivers/hwmon/Makefile
> > @@ -55,6 +55,7 @@ obj-$(CONFIG_SENSORS_I5K_AMB)       += i5k_amb.o
> > obj-$(CONFIG_SENSORS_IBMAEM)  += ibmaem.o
> > obj-$(CONFIG_SENSORS_IBMPEX)  += ibmpex.o
> > obj-$(CONFIG_SENSORS_IT87)    += it87.o
> > +obj-$(CONFIG_SENSORS_JC42)   += jc42.o
> > obj-$(CONFIG_SENSORS_K8TEMP)  += k8temp.o
> > obj-$(CONFIG_SENSORS_K10TEMP) += k10temp.o
> > obj-$(CONFIG_SENSORS_LIS3LV02D) += lis3lv02d.o hp_accel.o
> > diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
> > new file mode 100644
> > index 0000000..da146ff
> > --- /dev/null
> > +++ b/drivers/hwmon/jc42.c
> > @@ -0,0 +1,575 @@
> > +/*
> > + * jc42.c - driver for Jedec JC42.4 compliant temperature sensors
> > + *
> > + * Copyright (c) 2010  Ericsson AB.
> > + *
> > + * Derived from lm77.c by Andras BALI <drewie@freemail.hu>.
> > + *
> > + * JC42.4 compliant temperature sensors are typically used on memory modules.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/slab.h>
> > +#include <linux/jiffies.h>
> > +#include <linux/i2c.h>
> > +#include <linux/hwmon.h>
> > +#include <linux/hwmon-sysfs.h>
> > +#include <linux/err.h>
> > +#include <linux/mutex.h>
> > +
> > +/* Addresses to scan */
> > +static const unsigned short normal_i2c[] = {
> > +    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, I2C_CLIENT_END };
> > +
> > +/* JC42 registers. All registers are 16 bit. */
> > +#define JC42_REG_CAP         0x00
> > +#define JC42_REG_CONFIG              0x01
> > +#define JC42_REG_TEMP_UPPER  0x02
> > +#define JC42_REG_TEMP_LOWER  0x03
> > +#define JC42_REG_TEMP_CRITICAL       0x04
> > +#define JC42_REG_TEMP                0x05
> > +#define JC42_REG_MANID               0x06
> > +#define JC42_REG_DEVICEID    0x07
> > +
> > +/* Status bits in temperature register */
> > +#define JC42_ALARM_CRIT_BIT  15
> > +#define JC42_ALARM_MAX_BIT   14
> > +#define JC42_ALARM_MIN_BIT   13
> > +
> > +/* Configuration register defines */
> > +#define JC42_CFG_CRIT_ONLY   (1 << 2)
> > +#define JC42_CFG_SHUTDOWN    (1 << 8)
> > +#define JC42_CFG_HYST_SHIFT  9
> > +#define JC42_CFG_HYST_MASK   0x03
> > +
> > +/* Capabilities */
> > +#define JC42_CAP_RANGE               (1 << 2)
> > +
> > +/* Supported chips */
> > +#define SE97_MANID           0x1131
> > +#define SE97_DEVID           0xa200
> > +#define SE97_DEVID_MASK              0xfffc
> > +
> > +#define SE98_MANID           0x1131
> > +#define SE98_DEVID           0xa100
> > +#define SE98_DEVID_MASK              0xfffc
> > +
> > +#define STTS424_MANID                0x104a
> > +#define STTS424_DEVID                0x0101
> > +#define STTS424_DEVID_MASK   0xffff
> > +
> > +#define STTS424E_MANID               0x104a
> > +#define STTS424E_DEVID               0x0000
> > +#define STTS424E_DEVID_MASK  0xfffe
> > +
> > +#define CAT6095_MANID                0x1b09
> > +#define CAT6095_DEVID                0x0800  /* Also matches CAT34TS02 */
> > +#define CAT6095_DEVID_MASK   0xffe0
> > +
> > +#define MCP98242_MANID               0x0054
> > +#define MCP98242_DEVID               0x2000
> > +#define MCP98242_DEVID_MASK  0xfffc
> > +
> > +#define MCP98243_MANID               0x0054
> > +#define MCP98243_DEVID               0x2100
> > +#define MCP98243_DEVID_MASK  0xfffc
> > +
> > +#define MCP9843_MANID                0x0054
> > +#define MCP9843_DEVID                0x0000  /* Also matches mcp9805 */
> > +#define MCP9843_DEVID_MASK   0xfffe
> > +
> > +#define ADT7408_MANID                0x11d4
> > +#define ADT7408_DEVID                0x0801
> > +#define ADT7408_DEVID_MASK   0xffff
> > +
> > +static u16 jc42_hysteresis[] = { 0, 1500, 3000, 6000 };
> > +
> > +struct jc42_chips {
> > +     u16 manid;
> > +     u16 devid;
> > +     u16 devid_mask;
> > +};
> > +
> > +static struct jc42_chips jc42_chips[] = {
> > +     { SE97_MANID, SE97_DEVID, SE97_DEVID_MASK },
> > +     { SE98_MANID, SE98_DEVID, SE98_DEVID_MASK },
> > +     { STTS424_MANID, STTS424_DEVID, STTS424_DEVID_MASK },
> > +     { STTS424E_MANID, STTS424E_DEVID, STTS424E_DEVID_MASK },
> > +     { CAT6095_MANID, CAT6095_DEVID, CAT6095_DEVID_MASK },
> > +     { MCP98242_MANID, MCP98242_DEVID, MCP98242_DEVID_MASK },
> > +     { MCP98243_MANID, MCP98243_DEVID, MCP98243_DEVID_MASK },
> > +     { MCP9843_MANID, MCP9843_DEVID, MCP9843_DEVID_MASK },
> > +     { ADT7408_MANID, ADT7408_DEVID, ADT7408_DEVID_MASK },
> > +};
> > +
> > +/* Each client has this additional data */
> > +struct jc42_data {
> > +     struct device   *hwmon_dev;
> > +     struct mutex    update_lock;
> > +     bool            extended;       /* true if extended range supported */
> > +     bool            valid;
> > +     unsigned long   last_updated;   /* In jiffies */
> > +     u16             orig_config;    /* original configuration */
> > +     u16             config;         /* configuration */
> > +     u16             temp_input;     /* Temperatures */
> > +     u16             temp_crit;
> > +     u16             temp_min;
> > +     u16             temp_max;
> > +};
> > +
> > +static int jc42_probe(struct i2c_client *client,
> > +                   const struct i2c_device_id *id);
> > +static int jc42_detect(struct i2c_client *client, struct i2c_board_info *info);
> > +static int jc42_remove(struct i2c_client *client);
> > +static int jc42_read_value(struct i2c_client *client, u8 reg);
> > +static int jc42_write_value(struct i2c_client *client, u8 reg, u16 value);
> > +
> > +static struct jc42_data *jc42_update_device(struct device *dev);
> > +
> > +static const struct i2c_device_id jc42_id[] = {
> > +     { "adt7408", 0 },
> > +     { "cat94ts02", 0 },
> > +     { "cat6095", 0 },
> > +     { "jc42", 0 },
> > +     { "mcp9805", 0 },
> > +     { "mcp98242", 0 },
> > +     { "mcp98243", 0 },
> > +     { "mcp9843", 0 },
> > +     { "se97", 0 },
> > +     { "se97b", 0 },
> > +     { "se98", 0 },
> > +     { "stts424", 0 },
> > +     { }
> > +};
> > +MODULE_DEVICE_TABLE(i2c, jc42_id);
> > +
> > +#ifdef CONFIG_PM
> > +
> > +static int jc42_suspend(struct device *dev)
> > +{
> > +     struct i2c_client *client = to_i2c_client(dev);
> > +     struct jc42_data *data = i2c_get_clientdata(client);
> > +
> > +     data->config |= JC42_CFG_SHUTDOWN;
> > +     jc42_write_value(client, JC42_REG_CONFIG, data->config);
> > +     return 0;
> > +}
> > +
> > +static int jc42_resume(struct device *dev)
> > +{
> > +     struct i2c_client *client = to_i2c_client(dev);
> > +     struct jc42_data *data = i2c_get_clientdata(client);
> > +
> > +     data->config &= ~JC42_CFG_SHUTDOWN;
> > +     jc42_write_value(client, JC42_REG_CONFIG, data->config);
> > +     return 0;
> > +}
> > +
> > +static const struct dev_pm_ops jc42_dev_pm_ops = {
> > +     .suspend = jc42_suspend,
> > +     .resume = jc42_resume,
> > +};
> > +
> > +#define JC42_DEV_PM_OPS (&jc42_dev_pm_ops)
> > +#else
> > +#define JC42_DEV_PM_OPS NULL
> > +#endif /* CONFIG_PM */
> > +
> > +/* This is the driver that will be inserted */
> > +static struct i2c_driver jc42_driver = {
> > +     .class          = I2C_CLASS_HWMON,
> > +     .driver = {
> > +             .name   = "jc42",
> > +             .pm = JC42_DEV_PM_OPS,
> > +     },
> > +     .probe          = jc42_probe,
> > +     .remove         = jc42_remove,
> > +     .id_table       = jc42_id,
> > +     .detect         = jc42_detect,
> > +     .address_list   = normal_i2c,
> > +};
> > +
> > +#define JC42_TEMP_MIN_EXTENDED       (-40000)
> > +#define JC42_TEMP_MIN                0
> > +#define JC42_TEMP_MAX                125000
> > +
> > +static u16 jc42_temp_to_reg(int temp, bool extended)
> > +{
> > +     int ntemp = SENSORS_LIMIT(temp,
> > +                               extended ? JC42_TEMP_MIN_EXTENDED :
> > +                               JC42_TEMP_MIN, JC42_TEMP_MAX);
> > +
> > +     /* convert from 0.001 to 0.0625 resolution */
> > +     return (ntemp * 2 / 125) & 0x1fff;
> > +}
> > +
> > +static int jc42_temp_from_reg(s16 reg)
> > +{
> > +     reg &= 0x1fff;
> > +
> > +     /* sign extend register */
> > +     if (reg & 0x1000)
> > +             reg |= 0xf000;
> > +
> > +     /* convert from 0.0625 to 0.001 resolution */
> > +     return reg * 125 / 2;
> > +}
> > +
> > +/* sysfs stuff */
> > +
> > +/* read routines for temperature limits */
> > +#define show(value)  \
> > +static ssize_t show_##value(struct device *dev,                              \
> > +                         struct device_attribute *attr,              \
> > +                         char *buf)                                  \
> > +{                                                                    \
> > +     struct jc42_data *data = jc42_update_device(dev);               \
> > +     if (IS_ERR(data))                                               \
> > +             return PTR_ERR(data);                                   \
> > +     return sprintf(buf, "%d\n", jc42_temp_from_reg(data->value));   \
> > +}
> > +
> > +show(temp_input);
> > +show(temp_crit);
> > +show(temp_min);
> > +show(temp_max);
> > +
> > +/* read routines for hysteresis values */
> > +static ssize_t show_temp_crit_hyst(struct device *dev,
> > +                                struct device_attribute *attr, char *buf)
> > +{
> > +     struct jc42_data *data = jc42_update_device(dev);
> > +     int temp, hyst;
> > +
> > +     if (IS_ERR(data))
> > +             return PTR_ERR(data);
> > +
> > +     temp = jc42_temp_from_reg(data->temp_crit);
> > +     hyst = jc42_hysteresis[(data->config >> JC42_CFG_HYST_SHIFT)
> > +                            & JC42_CFG_HYST_MASK];
> > +     return sprintf(buf, "%d\n", temp - hyst);
> > +}
> > +
> > +static ssize_t show_temp_max_hyst(struct device *dev,
> > +                               struct device_attribute *attr, char *buf)
> > +{
> > +     struct jc42_data *data = jc42_update_device(dev);
> > +     int temp, hyst;
> > +
> > +     if (IS_ERR(data))
> > +             return PTR_ERR(data);
> > +
> > +     temp = jc42_temp_from_reg(data->temp_max);
> > +     hyst = jc42_hysteresis[(data->config >> JC42_CFG_HYST_SHIFT)
> > +                            & JC42_CFG_HYST_MASK];
> > +     return sprintf(buf, "%d\n", temp - hyst);
> > +}
> > +
> > +/* write routines */
> > +#define set(value, reg)      \
> > +static ssize_t set_##value(struct device *dev,                               \
> > +                        struct device_attribute *attr,               \
> > +                        const char *buf, size_t count)               \
> > +{                                                                    \
> > +     struct i2c_client *client = to_i2c_client(dev);                 \
> > +     struct jc42_data *data = i2c_get_clientdata(client);            \
> > +     int err, ret = count;                                           \
> > +     long val;                                                       \
> > +     if (strict_strtol(buf, 10, &val) < 0)                           \
> > +             return -EINVAL;                                         \
> > +     mutex_lock(&data->update_lock);                                 \
> > +     data->value = jc42_temp_to_reg(val, data->extended);            \
> > +     err = jc42_write_value(client, reg, data->value);               \
> > +     if (err < 0)                                                    \
> > +             ret = err;                                              \
> > +     mutex_unlock(&data->update_lock);                               \
> > +     return ret;                                                     \
> > +}
> > +
> > +set(temp_min, JC42_REG_TEMP_LOWER);
> > +set(temp_max, JC42_REG_TEMP_UPPER);
> > +set(temp_crit, JC42_REG_TEMP_CRITICAL);
> > +
> > +/* JC42.4 compliant chips only support four hysteresis values.
> > + * Pick best choice and go from there. */
> > +static ssize_t set_temp_crit_hyst(struct device *dev,
> > +                               struct device_attribute *attr,
> > +                               const char *buf, size_t count)
> > +{
> > +     struct i2c_client *client = to_i2c_client(dev);
> > +     struct jc42_data *data = i2c_get_clientdata(client);
> > +     long val;
> > +     int diff, hyst;
> > +     int err;
> > +     int ret = count;
> > +
> > +     if (strict_strtoul(buf, 10, &val) < 0)
> > +             return -EINVAL;
> > +
> > +     diff = jc42_temp_from_reg(data->temp_crit) - val;
> > +     hyst = 0;
> > +     if (diff > 0) {
> > +             if (diff < 2250)
> > +                     hyst = 1;       /* 1.5 degrees C */
> > +             else if (diff < 4500)
> > +                     hyst = 2;       /* 3.0 degrees C */
> > +             else
> > +                     hyst = 3;       /* 6.0 degrees C */
> > +     }
> > +
> > +     mutex_lock(&data->update_lock);
> > +     data->config = (data->config
> > +                     & ~(JC42_CFG_HYST_MASK << JC42_CFG_HYST_SHIFT))
> > +       | (hyst << JC42_CFG_HYST_SHIFT);
> > +     err = jc42_write_value(client, JC42_REG_CONFIG, data->config);
> > +     if (err < 0)
> > +             ret = err;
> > +     mutex_unlock(&data->update_lock);
> > +     return ret;
> > +}
> > +
> > +static ssize_t show_alarm(struct device *dev,
> > +                       struct device_attribute *attr, char *buf)
> > +{
> > +     u16 bit = to_sensor_dev_attr(attr)->index;
> > +     struct jc42_data *data = jc42_update_device(dev);
> > +     u16 val;
> > +
> > +     if (IS_ERR(data))
> > +             return PTR_ERR(data);
> > +
> > +     val = data->temp_input;
> > +     if (bit != JC42_ALARM_CRIT_BIT && (data->config & JC42_CFG_CRIT_ONLY))
> > +             val = 0;
> > +     return sprintf(buf, "%u\n", (val >> bit) & 1);
> > +}
> > +
> > +static DEVICE_ATTR(temp1_input, S_IRUGO,
> > +                show_temp_input, NULL);
> > +static DEVICE_ATTR(temp1_crit, S_IWUSR | S_IRUGO,
> > +                show_temp_crit, set_temp_crit);
> > +static DEVICE_ATTR(temp1_min, S_IWUSR | S_IRUGO,
> > +                show_temp_min, set_temp_min);
> > +static DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO,
> > +                show_temp_max, set_temp_max);
> > +
> > +static DEVICE_ATTR(temp1_crit_hyst, S_IWUSR | S_IRUGO,
> > +                show_temp_crit_hyst, set_temp_crit_hyst);
> > +static DEVICE_ATTR(temp1_max_hyst, S_IRUGO,
> > +                show_temp_max_hyst, NULL);
> > +
> > +static SENSOR_DEVICE_ATTR(temp1_crit_alarm, S_IRUGO, show_alarm, NULL,
> > +                       JC42_ALARM_CRIT_BIT);
> > +static SENSOR_DEVICE_ATTR(temp1_min_alarm, S_IRUGO, show_alarm, NULL,
> > +                       JC42_ALARM_MIN_BIT);
> > +static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO, show_alarm, NULL,
> > +                       JC42_ALARM_MAX_BIT);
> > +
> > +static struct attribute *jc42_attributes[] = {
> > +     &dev_attr_temp1_input.attr,
> > +     &dev_attr_temp1_crit.attr,
> > +     &dev_attr_temp1_min.attr,
> > +     &dev_attr_temp1_max.attr,
> > +     &dev_attr_temp1_crit_hyst.attr,
> > +     &dev_attr_temp1_max_hyst.attr,
> > +     &sensor_dev_attr_temp1_crit_alarm.dev_attr.attr,
> > +     &sensor_dev_attr_temp1_min_alarm.dev_attr.attr,
> > +     &sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
> > +     NULL
> > +};
> > +
> > +static const struct attribute_group jc42_group = {
> > +     .attrs = jc42_attributes,
> > +};
> > +
> > +/* Return 0 if detection is successful, -ENODEV otherwise */
> > +static int jc42_detect(struct i2c_client *new_client,
> > +                    struct i2c_board_info *info)
> > +{
> > +     struct i2c_adapter *adapter = new_client->adapter;
> > +     int i, config, cap, manid, devid;
> > +
> > +     if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
> > +                                  I2C_FUNC_SMBUS_WORD_DATA))
> > +             return -ENODEV;
> > +
> > +     cap = jc42_read_value(new_client, JC42_REG_CAP);
> > +     config = jc42_read_value(new_client, JC42_REG_CONFIG);
> > +     manid = jc42_read_value(new_client, JC42_REG_MANID);
> > +     devid = jc42_read_value(new_client, JC42_REG_DEVICEID);
> > +
> > +     if (cap < 0 || config < 0 || manid < 0 || devid < 0)
> > +             return -ENODEV;
> > +
> > +     if ((cap & 0xff00) || (config & 0xf800))
> > +             return -ENODEV;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(jc42_chips); i++) {
> > +             if (manid == jc42_chips[i].manid
> > +                 && (devid & jc42_chips[i].devid_mask) ==
> > +                                         jc42_chips[i].devid) {
> > +                     strlcpy(info->type, "jc42", I2C_NAME_SIZE);
> > +                     return 0;
> > +             }
> > +     }
> > +     return -ENODEV;
> > +}
> > +
> > +static int jc42_probe(struct i2c_client *new_client,
> > +                   const struct i2c_device_id *id)
> > +{
> > +     struct jc42_data *data;
> > +     int config, cap, err;
> > +
> > +     data = kzalloc(sizeof(struct jc42_data), GFP_KERNEL);
> > +     if (!data) {
> > +             err = -ENOMEM;
> > +             goto exit;
> > +     }
> > +
> > +     i2c_set_clientdata(new_client, data);
> > +     data->valid = false;
> > +     mutex_init(&data->update_lock);
> > +
> > +     cap = jc42_read_value(new_client, JC42_REG_CAP);
> > +     if (cap < 0) {
> > +             err = -EINVAL;
> > +             goto exit_free;
> > +     }
> > +     data->extended = !!(cap & JC42_CAP_RANGE);
> > +
> > +     config = jc42_read_value(new_client, JC42_REG_CONFIG);
> > +     if (config < 0) {
> > +             err = -EINVAL;
> > +             goto exit_free;
> > +     }
> > +     data->orig_config = config;
> > +     if (config & JC42_CFG_SHUTDOWN) {
> > +             config &= ~JC42_CFG_SHUTDOWN;
> > +             jc42_write_value(new_client, JC42_REG_CONFIG, config);
> > +     }
> > +     data->config = config;
> > +
> > +     /* Register sysfs hooks */
> > +     err = sysfs_create_group(&new_client->dev.kobj, &jc42_group);
> > +     if (err)
> > +             goto exit_free;
> > +
> > +     data->hwmon_dev = hwmon_device_register(&new_client->dev);
> > +     if (IS_ERR(data->hwmon_dev)) {
> > +             err = PTR_ERR(data->hwmon_dev);
> > +             goto exit_remove;
> > +     }
> > +
> > +     return 0;
> > +
> > +exit_remove:
> > +     sysfs_remove_group(&new_client->dev.kobj, &jc42_group);
> > +exit_free:
> > +     kfree(data);
> > +exit:
> > +     return err;
> > +}
> > +
> > +static int jc42_remove(struct i2c_client *client)
> > +{
> > +     struct jc42_data *data = i2c_get_clientdata(client);
> > +     hwmon_device_unregister(data->hwmon_dev);
> > +     sysfs_remove_group(&client->dev.kobj, &jc42_group);
> > +     if (data->config != data->orig_config)
> > +             jc42_write_value(client, JC42_REG_CONFIG, data->orig_config);
> > +     kfree(data);
> > +     return 0;
> > +}
> > +
> > +/* All registers are word-sized. */
> > +static int jc42_read_value(struct i2c_client *client, u8 reg)
> > +{
> > +     int ret = i2c_smbus_read_word_data(client, reg);
> > +     if (ret < 0)
> > +             return ret;
> > +     return swab16(ret);
> > +}
> > +
> > +static int jc42_write_value(struct i2c_client *client, u8 reg, u16 value)
> > +{
> > +     return i2c_smbus_write_word_data(client, reg, swab16(value));
> > +}
> > +
> > +static struct jc42_data *jc42_update_device(struct device *dev)
> > +{
> > +     struct i2c_client *client = to_i2c_client(dev);
> > +     struct jc42_data *data = i2c_get_clientdata(client);
> > +     struct jc42_data *ret = data;
> > +     int val;
> > +
> > +     mutex_lock(&data->update_lock);
> > +
> > +     if (time_after(jiffies, data->last_updated + HZ) || !data->valid) {
> > +             val = jc42_read_value(client, JC42_REG_TEMP);
> > +             if (val < 0) {
> > +                     ret = ERR_PTR(val);
> > +                     goto abort;
> > +             }
> > +             data->temp_input = val;
> > +
> > +             val = jc42_read_value(client, JC42_REG_TEMP_CRITICAL);
> > +             if (val < 0) {
> > +                     ret = ERR_PTR(val);
> > +                     goto abort;
> > +             }
> > +             data->temp_crit = val;
> > +
> > +             val = jc42_read_value(client, JC42_REG_TEMP_LOWER);
> > +             if (val < 0) {
> > +                     ret = ERR_PTR(val);
> > +                     goto abort;
> > +             }
> > +             data->temp_min = val;
> > +
> > +             val = jc42_read_value(client, JC42_REG_TEMP_UPPER);
> > +             if (val < 0) {
> > +                     ret = ERR_PTR(val);
> > +                     goto abort;
> > +             }
> > +             data->temp_max = val;
> > +
> > +             data->last_updated = jiffies;
> > +             data->valid = true;
> > +     }
> > +abort:
> > +     mutex_unlock(&data->update_lock);
> > +     return ret;
> > +}
> > +
> > +static int __init sensors_jc42_init(void)
> > +{
> > +     return i2c_add_driver(&jc42_driver);
> > +}
> > +
> > +static void __exit sensors_jc42_exit(void)
> > +{
> > +     i2c_del_driver(&jc42_driver);
> > +}
> > +
> > +MODULE_AUTHOR("Guenter Roeck <guenter.roeck@ericsson.com>");
> > +MODULE_DESCRIPTION("JC42 driver");
> > +MODULE_LICENSE("GPL");
> > +
> > +module_init(sensors_jc42_init);
> > +module_exit(sensors_jc42_exit);
> > --
> > 1.7.0.87.g0901d
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> -------------------------------------------------------------------------
> | Paul Goyette     | PGP Key fingerprint:     | E-mail addresses:       |
> | Customer Service | FA29 0E3B 35AF E8AE 6651 | paul at whooppee.com    |
> | Network Engineer | 0786 F758 55DE 53BA 7731 | pgoyette at juniper.net |
> | Kernel Developer |                          | pgoyette at netbsd.org  |
> -------------------------------------------------------------------------

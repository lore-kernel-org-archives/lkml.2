Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab0FYPEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 11:04:30 -0400
Received: from ppsw-30.csi.cam.ac.uk ([131.111.8.130]:47544 "EHLO
	ppsw-30.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0FYPE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 11:04:29 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C24C637.6000905@jic23.retrosnub.co.uk>
Date: Fri, 25 Jun 2010 16:07:35 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100426 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "sfking@fdwdc.com" <sfking@fdwdc.com>
Subject: Re: add Honeywell hmc5843 3-Axis Magnetometer (digital compass) driver.
References: <0680EC522D0CC943BC586913CF3768C003B3553F73@dbde02.ent.ti.com> <0680EC522D0CC943BC586913CF3768C003B3553F77@dbde02.ent.ti.com>
In-Reply-To: <0680EC522D0CC943BC586913CF3768C003B3553F77@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/10 14:32, Datta, Shubhrajyoti wrote:
> 
> 
>> Steven King - 2009-12-11 06:50:12
>> Signed-off-by: Steven King <sfking@fdwdc.com>
>>
>> ---
>>
>>  drivers/input/misc/Kconfig   |   10 +
>>  drivers/input/misc/Makefile  |    1 +
>>  drivers/input/misc/hmc5843.c |  515
>> ++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 526 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/input/misc/hmc5843.c
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>> Jonathan Cameron - 2009-12-11 12:45:24
>> Dear Steven,
>>
>> Mostly looks good to me.  Couple of minor comments inline below.
>>
>> I'd also like to see some documentation for this chip.  We don't really
>> want people to have to read the data sheet in order to find out what the
>> various modes and frequency settings are for example. Datasheets have
>> a nasty habit of disappearing in the long run.  Probably needs something
>> in Documentation directory rather than merely comments in the code.
>>
>> Only one I'm really fussy about is making sure you use the unsigned
>> strict_strtoul where appropriate.  Fix that and you can add
>> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
>>
>> I'm not entirely convinced this one should be in input as I can't really
>> believe
>> it is commonly used as an input device?  Over to Dmitry and others for
>> that
>> though.   We can always move it at a later date. The requirements of a
>> chip
>> this simple (interface wise) would make that trivial.
> So can we recommend it in  drivers/misc with input interface.
Not unless you can convince Dmitry this is a typical human input
device.  He has recently allowed some 3d accelerometers in on the basis
that is what many people use them for. Here I for one am unconvinced.
Can't see people controlling games or mouse pointer based on a compass.

misc with a simple sysfs interface seems most logical to me if you
don't want to go with IIO.
> 
>>
>> Jonathan
>>> Signed-off-by: Steven King <sfking@fdwdc.com>
>>>
>>> ---
>>>
>>>  drivers/input/misc/Kconfig   |   10 +
>>>  drivers/input/misc/Makefile  |    1 +
>>>  drivers/input/misc/hmc5843.c |  515
>> ++++++++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 526 insertions(+), 0 deletions(-)
>>>  create mode 100644 drivers/input/misc/hmc5843.c
>>>
>>> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
>>> index a9bb254..7564b96 100644
>>> --- a/drivers/input/misc/Kconfig
>>> +++ b/drivers/input/misc/Kconfig
>>> @@ -317,4 +317,14 @@ config INPUT_PCAP
>>>       To compile this driver as a module, choose M here: the
>>>       module will be called pcap_keys.
>>>
>>> +config INPUT_HMC5843
>>> +   tristate "Honeywell HMC5843 3-Axis Magnetometer"
>>> +   depends on I2C && SYSFS
>>> +   select INPUT_POLLDEV
>>> +   help
>>> +     Say Y here to add support for the Honeywell HMC 5843 3-Axis
>>> +     Magnetometer (digital compass).
>>> +
>>> +     To compile this driver as a module, choose M here: the module
>>> +     will be called hmc5843.
>>>  endif
>>> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
>>> index a8b8485..825b70c 100644
>>> --- a/drivers/input/misc/Makefile
>>> +++ b/drivers/input/misc/Makefile
>>> @@ -30,4 +30,5 @@ obj-$(CONFIG_INPUT_WINBOND_CIR)           += winbond-
>> cir.o
>>>  obj-$(CONFIG_INPUT_WISTRON_BTNS)   += wistron_btns.o
>>>  obj-$(CONFIG_INPUT_WM831X_ON)              += wm831x-on.o
>>>  obj-$(CONFIG_INPUT_YEALINK)                += yealink.o
>>> +obj-$(CONFIG_INPUT_HMC5843)                += hmc5843.o
>>>
>>> diff --git a/drivers/input/misc/hmc5843.c b/drivers/input/misc/hmc5843.c
>>> new file mode 100644
>>> index 0000000..51bb86c
>>> --- /dev/null
>>> +++ b/drivers/input/misc/hmc5843.c
>>> @@ -0,0 +1,515 @@
>>> +/*
>>> + * Driver for the Honeywell HMC5843 3-Axis Magnetometer.
>>> + *
>>> + * Author: Steven King <sfking@fdwdc.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License as published by
>>> + * the Free Software Foundation; either version 2 of the License, or
>>> + * (at your option) any later version.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + *
>>> + * You should have received a copy of the GNU General Public License
>>> + * along with this program; if not, write to the Free Software
>>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
>> USA
>>> + */
>>> +
>>> +#include <linux/kernel.h>
>>> +#include <linux/module.h>
>>> +#include <linux/jiffies.h>
>>> +#include <linux/err.h>
>>> +#include <linux/i2c.h>
>>> +#include <linux/input-polldev.h>
>>> +
>>> +#define    HMC5843_CFG_A_REG                       0
>>> +#define            HMC5843_CFG_A_BIAS_MASK         0x03
>>> +#define            HMC5843_CFG_A_RATE_MASK         0x1c
>>> +#define            HMC5843_CFG_A_RATE_SHIFT        2
>>> +#define    HMC5843_CFG_B_REG                       1
>>> +#define            MMC5843_CFG_B_GAIN_MASK         0xe0
>>> +#define            MMC5843_CFG_B_GAIN_SHIFT        5
>>> +#define    HMC5843_MODE_REG                        2
>>> +#define            HMC5843_MODE_REPEAT             0
>>> +#define            HMC5843_MODE_ONCE               1
>>> +#define            HMC5843_MODE_IDLE               2
>>> +#define            HMC5843_MODE_SLEEP              3
>>> +#define    HMC5843_X_DATA_REG                      3
>>> +#define    HMC5843_Y_DATA_REG                      5
>>> +#define    HMC5843_Z_DATA_REG                      7
>>> +#define    HMC5843_STATUS_REG                      9
>>> +#define            HMC5843_STATUS_REN              0x04
>>> +#define            HMC5843_STATUS_LOCK             0x02
>>> +#define            HMC5843_STATUS_RDY              0x01
>>> +#define    HMC5843_ID_REG_A                        10
>>> +#define    HMC5843_ID_REG_B                        11
>>> +#define    HMC5843_ID_REG_C                        12
>>> +#define    HMC5843_LAST_REG                        12
>>> +#define    HMC5843_NUM_REG                         13
>>> +
>>> +struct hmc5843 {
>>> +   struct i2c_client       *client;
>>> +   struct mutex            lock;
>>> +   struct input_polled_dev *ipdev;
>> Size is of this is rather large given it can only be 0,1,2. U8 would
>> make more sense. Same is true of the other elements here.  It's a small
>> saving, but why bloat the kernel for no gain?
>>> +   int                     bias;
>>> +   int                     gain;
>> rate is only between 0 and 6 so again U8. On this element, might it be
>> better to go with meaningful readings rather than an index? Not sure what
>> similar drivers do.
>>> +   int                     rate;
>>
>>> +   int                     mode;
>>> +   int                     index;
>>> +};
>>> +
>>> +/* interval between samples for the different rates, in msecs */
>>> +static const unsigned int hmc5843_sample_interval[] = {
>>> +   1000 * 2,       1000,           1000 / 2,       1000 / 5,
>>> +   1000 / 10,      1000 / 20,      1000 / 50,
>>> +};
>>> +
>>> +/*
>>> + * From the datasheet:
>>> + *
>>> + * The devices uses an address pointer to indicate which register
>> location is
>>> + * to be read from or written to. These pointer locations are sent from
>> the
>>> + * master to this slave device and succeed the 7-bit address plus 1 bit
>>> + * read/write identifier.
>>> + *
>>> + * To minimize the communication between the master and this device,
>> the
>>> + * address pointer updated automatically without master intervention.
>> This
>>> + * automatic address pointer update has two additional features. First
>> when
>>> + * address 12 or higher is accessed the pointer updates to address 00
>> and
>>> + * secondly when address 09 is reached, the pointer rolls back to
>> address 03.
>>> + * Logically, the address pointer operation functions as shown below.
>>> + *
>>> + * If (address pointer = 09) then address pointer = 03
>>> + * Else if (address pointer >= 12) then address pointer = 0
>>> + * Else (address pointer) = (address pointer) + 1
>>> + *
>>> + * Since the set of operations performed by this driver is pretty
>> simple,
>>> + * we keep track of the register being written to when updating the
>>> + * configuration and when reading data only update the address ptr when
>> its not
>>> + * pointing to the first data register.
>>> +*/
>>> +
>>> +static int hmc5843_write_register(struct hmc5843 *hmc5843, int index)
>>> +{
>>> +   u8 buf[2];
>>> +   int result;
>>> +
>>> +   buf[0] = index;
>> A switch statement might make this easier to read.
>>> +   if (index == HMC5843_CFG_A_REG)
>>> +           buf[1] = hmc5843->bias |
>>> +                   (hmc5843->rate << HMC5843_CFG_A_RATE_SHIFT);
>>> +   else if (index == HMC5843_CFG_B_REG)
>>> +           buf[1] = hmc5843->gain << MMC5843_CFG_B_GAIN_SHIFT;
>>> +   else if (index == HMC5843_MODE_REG)
>>> +           buf[1] = hmc5843->mode;
>>> +   else
>>> +           return -EINVAL;
>>> +   result = i2c_master_send(hmc5843->client, buf, sizeof(buf));
>>> +
>> Blank line here is a bit unconventional. (feel free to ignore this sort of
>> comment!)
>>> +   if (result != 2) {
>>> +           hmc5843->index = -1;
>>> +           return result;
>>> +   }
>>> +   hmc5843->index = index + 1;
>> Fussy formatting puts a blank line here.
>>> +   return 0;
>>> +}
>>> +
>>> +static int hmc5843_read_xyz(struct hmc5843 *hmc5843, int *x, int *y,
>> int *z)
>>> +{
>>> +   struct i2c_msg msgs[2];
>>> +   u8 buf[6];
>>> +   int n = 0;
>>> +   int result;
>>> +
>>> +   if (hmc5843->index != HMC5843_X_DATA_REG) {
>>> +           buf[0]          = HMC5843_X_DATA_REG;
>>> +
>>> +           msgs[0].addr    = hmc5843->client->addr;
>>> +           msgs[0].flags   = 0;
>>> +           msgs[0].buf     = buf;
>>> +           msgs[0].len     = 1;
>>> +
>>> +           hmc5843->index  = HMC5843_X_DATA_REG;
>>> +           n = 1;
>>> +   }
>>> +   msgs[n].addr    = hmc5843->client->addr;
>>> +   msgs[n].flags   = I2C_M_RD;
>>> +   msgs[n].buf     = buf;
>>> +   msgs[n].len     = 6;
>>> +   ++n;
>>> +
>>> +   result = i2c_transfer(hmc5843->client->adapter, msgs, n);
>>> +   if (result != n) {
>>> +           hmc5843->index = -1;
>>> +           return result;
>>> +   }
>>> +
>>> +   *x = (((int)((s8)buf[0])) << 8) | buf[1];
>>> +   *y = (((int)((s8)buf[2])) << 8) | buf[3];
>>> +   *z = (((int)((s8)buf[4])) << 8) | buf[5];
>>> +   return 0;
>>> +}
>>> +
>>> +/* sysfs stuff */
>>> +
>>> +/* bias */
>>> +static ssize_t hmc5843_show_bias(struct device *dev,
>>> +                            struct device_attribute *attr,
>>> +                            char *buf)
>>> +{
>>> +   struct i2c_client *client = to_i2c_client(dev);
>>> +   struct hmc5843 *hmc5843 = i2c_get_clientdata(client);
>>> +
>>> +   return sprintf(buf, "%d\n", hmc5843->bias);
>>> +}
>>> +
>>> +static ssize_t hmc5843_store_bias(struct device *dev,
>>> +                             struct device_attribute *attr,
>>> +                             const char *buf, size_t count)
>>> +{
>>> +   struct i2c_client *client = to_i2c_client(dev);
>>> +   struct hmc5843 *hmc5843 = i2c_get_clientdata(client);
>>> +   unsigned long val;
>>> +   int status = count;
>>> +
>>> +   if ((strict_strtol(buf, 10, &val) < 0) || (val > 2))
>>> +           return -EINVAL;
>>> +   mutex_lock(&hmc5843->lock);
>>> +   if (hmc5843->bias != val) {
>>> +           hmc5843->bias = val;
>>> +           status = hmc5843_write_register(hmc5843, HMC5843_CFG_A_REG);
>>> +   }
>>> +   mutex_unlock(&hmc5843->lock);
>>> +   return status;
>>> +}
>>> +
>>> +static DEVICE_ATTR(bias, S_IWUSR | S_IRUGO, hmc5843_show_bias,
>>> +           hmc5843_store_bias);
>>> +
>>> +/* rate */
>>> +static ssize_t hmc5843_show_rate(struct device *dev,
>>> +                            struct device_attribute *attr,
>>> +                            char *buf)
>>> +{
>>> +   struct i2c_client *client = to_i2c_client(dev);
>>> +   struct hmc5843 *hmc5843 = i2c_get_clientdata(client);
>>> +
>>> +   return sprintf(buf, "%d\n", hmc5843->rate);
>>> +}
>>> +
>>> +static ssize_t hmc5843_store_rate(struct device *dev,
>>> +                             struct device_attribute *attr,
>>> +                             const char *buf, size_t count)
>>> +{
>>> +   struct i2c_client *client = to_i2c_client(dev);
>>> +   struct hmc5843 *hmc5843 = i2c_get_clientdata(client);
>>> +   unsigned long val;
>>> +   int status = count;
>>> +   if ((strict_strtol(buf, 10, &val) < 0) || (val > 6))
>>> +           return -EINVAL;
>>> +   mutex_lock(&hmc5843->lock);
>>> +   if (hmc5843->rate != val) {
>>> +           hmc5843->rate = val;
>>> +           hmc5843->ipdev->poll_interval = hmc5843_sample_interval[val];
>>> +           status = hmc5843_write_register(hmc5843, HMC5843_CFG_A_REG);
>>> +   }
>>> +   mutex_unlock(&hmc5843->lock);
>>> +   return status;
>>> +}
>>> +
>>> +static DEVICE_ATTR(rate, S_IWUSR | S_IRUGO, hmc5843_show_rate,
>>> +           hmc5843_store_rate);
>>> +
>>> +/* gain */
>>> +static ssize_t hmc5843_show_gain(struct device *dev,
>>> +                            struct device_attribute *attr,
>>> +                            char *buf)
>>> +{
>>> +   struct i2c_client *client = to_i2c_client(dev);
>>> +   struct hmc5843 *hmc5843 = i2c_get_clientdata(client);
>>> +
>>> +   return sprintf(buf, "%d\n", hmc5843->gain);
>>> +}
>>> +
>>> +static ssize_t hmc5843_store_gain(struct device *dev,
>>> +                             struct device_attribute *attr,
>>> +                             const char *buf, size_t count)
>>> +{
>>> +   struct i2c_client *client = to_i2c_client(dev);
>>> +   struct hmc5843 *hmc5843 = i2c_get_clientdata(client);
>>> +   unsigned long val;
>>> +   int status = count;
>> You want strict_strtoul as it is unsigned. (probably true elsewhere in
>> driver
>> I just noticed it here!)
>>> +   if ((strict_strtol(buf, 10, &val) < 0) || (val > 6))
>>> +           return -EINVAL;
>>> +   mutex_lock(&hmc5843->lock);
>>> +   if (hmc5843->gain != val) {
>>> +           hmc5843->gain = val;
>>> +           status = hmc5843_write_register(hmc5843, HMC5843_CFG_B_REG);
>>> +   }
>>> +   mutex_unlock(&hmc5843->lock);
>>> +   return status;
>>> +}
>>> +
>>> +static DEVICE_ATTR(gain, S_IWUSR | S_IRUGO, hmc5843_show_gain,
>>> +           hmc5843_store_gain);
>>> +
>>> +/* mode */
>>> +static ssize_t hmc5843_show_mode(struct device *dev,
>>> +                            struct device_attribute *attr,
>>> +                            char *buf)
>>> +{
>>> +   struct i2c_client *client = to_i2c_client(dev);
>>> +   struct hmc5843 *hmc5843 = i2c_get_clientdata(client);
>>> +
>>> +   return sprintf(buf, "%d\n", hmc5843->mode);
>>> +}
>>> +
>>> +static ssize_t hmc5843_store_mode(struct device *dev,
>>> +                             struct device_attribute *attr,
>>> +                             const char *buf, size_t count)
>>> +{
>>> +   struct i2c_client *client = to_i2c_client(dev);
>>> +   struct hmc5843 *hmc5843 = i2c_get_clientdata(client);
>>> +   unsigned long val;
>>> +   int status = count;
>>> +
>> strict_strtoul
>>> +   if ((strict_strtol(buf, 10, &val) < 0) || (val > 3))
>>> +           return -EINVAL;
>>> +   mutex_lock(&hmc5843->lock);
>>> +   if (hmc5843->mode != val) {
>>> +           hmc5843->mode = val;
>>> +           status = hmc5843_write_register(hmc5843, HMC5843_MODE_REG);
>>> +   }
>>> +   mutex_unlock(&hmc5843->lock);
>>> +   return status;
>>> +}
>>> +
>>> +static DEVICE_ATTR(mode, S_IWUSR | S_IRUGO, hmc5843_show_mode,
>>> +           hmc5843_store_mode);
>>> +
>>> +static struct attribute *hmc5843_attributes[] = {
>>> +   &dev_attr_bias.attr,
>>> +   &dev_attr_rate.attr,
>>> +   &dev_attr_gain.attr,
>>> +   &dev_attr_mode.attr,
>>> +   NULL,
>>> +};
>>> +
>>> +static const struct attribute_group hmc5843_attr_group = {
>>> +   .attrs = hmc5843_attributes,
>>> +};
>>> +
>>> +/* use polled input device */
>>> +
>>> +static void hmc5843_poll(struct input_polled_dev *ipdev)
>>> +{
>>> +   struct hmc5843 *hmc5843 = ipdev->private;
>>> +   int x, y, z;
>>> +
>>> +   mutex_lock(&hmc5843->lock);
>>> +   if (!hmc5843_read_xyz(hmc5843, &x, &y, &z)) {
>>> +           input_report_abs(ipdev->input, ABS_X, x);
>>> +           input_report_abs(ipdev->input, ABS_Y, y);
>>> +           input_report_abs(ipdev->input, ABS_Z, z);
>>> +           input_sync(ipdev->input);
>>> +   }
>>> +   mutex_unlock(&hmc5843->lock);
>>> +}
>>> +
>>> +static int __devinit hmc5843_input_init(struct hmc5843 *hmc5843)
>>> +{
>>> +   int status;
>>> +   struct input_polled_dev *ipdev;
>>> +
>>> +   ipdev = input_allocate_polled_device();
>>> +   if (!ipdev) {
>>> +           dev_dbg(&hmc5843->client->dev, "error creating input
>> device\n");
>>> +           return -ENOMEM;
>>> +   }
>>> +   ipdev->poll = hmc5843_poll;
>>> +   ipdev->poll_interval = hmc5843_sample_interval[hmc5843->rate];
>>> +   ipdev->private = hmc5843;
>>> +
>>> +   ipdev->input->name = "Honeywell HMC5843 3-Axis Magnetometer";
>>> +   ipdev->input->phys = "hmc5843/input0";
>>> +   ipdev->input->id.bustype = BUS_HOST;
>>> +
>>> +   set_bit(EV_ABS, ipdev->input->evbit);
>>> +
>>> +   input_set_abs_params(ipdev->input, ABS_X, -2047, 2047, 0, 0);
>>> +   input_set_abs_params(ipdev->input, ABS_Y, -2047, 2047, 0, 0);
>>> +   input_set_abs_params(ipdev->input, ABS_Z, -2047, 2047, 0, 0);
>>> +
>>> +   status = input_register_polled_device(ipdev);
>>> +   if (status) {
>>> +           dev_dbg(&hmc5843->client->dev,
>>> +                           "error registering input device\n");
>>> +           input_free_polled_device(ipdev);
>>> +           goto exit;
>>> +   }
>>> +   hmc5843->ipdev = ipdev;
>>> +exit:
>>> +   return status;
>>> +}
>>> +
>>> +static int __devinit hmc5843_device_init(struct hmc5843 *hmc5843)
>>> +{
>>> +   struct i2c_client *client = hmc5843->client;
>>> +   int status;
>>> +
>>> +   struct i2c_msg msgs[2];
>>> +   u8 buf[6] = { HMC5843_ID_REG_A }; /* start reading at 1st id reg */
>>> +
>>> +   msgs[0].addr = client->addr;
>>> +   msgs[0].flags = 0;
>>> +   msgs[0].buf = buf;
>>> +   msgs[0].len = 1;
>>> +   msgs[1].addr = client->addr;
>>> +   msgs[1].flags = I2C_M_RD;
>>> +   msgs[1].buf = buf; /* overwrite sent address on read */
>>> +   msgs[1].len = 6; /* 3 id regs + cfg_a, cfg_b & mode reg */
>>> +
>>> +   status = i2c_transfer(client->adapter, msgs, 2);
>>> +   if (status != 2) {
>>> +           dev_dbg(&client->dev, "unable to contact device\n");
>>> +           return status;
>>> +   }
>>> +   if (strncmp(buf, "H43", 3)) {
>>> +           dev_dbg(&client->dev, "incorrect device id %-3.3s", buf);
>>> +           return -EINVAL;
>>> +   }
>>> +   /* the read will have wrapped to 0, bytes 3-6 are cfg_a, cfg_b, mode
>> */
>>> +   hmc5843->bias = buf[3] & HMC5843_CFG_A_BIAS_MASK;
>>> +   hmc5843->rate = buf[3] >> HMC5843_CFG_A_RATE_SHIFT;
>>> +   hmc5843->gain = buf[4] >> MMC5843_CFG_B_GAIN_SHIFT;
>>> +   hmc5843->mode = buf[5];
>>> +
>>> +   hmc5843->index = 3;
>>> +   mutex_init(&hmc5843->lock);
>>> +   return 0;
>>> +}
>>> +
>>> +static int __devinit hmc5843_i2c_probe(struct i2c_client *client,
>>> +                                   const struct i2c_device_id *id)
>>> +{
>>> +   int status;
>>> +   struct hmc5843 *hmc5843;
>>> +
>>> +   if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
>>> +           dev_dbg(&client->dev, "adapter doesn't support I2C\n");
>>> +           return -ENODEV;
>>> +   }
>>> +
>>> +   hmc5843 = kzalloc(sizeof(*hmc5843), GFP_KERNEL);
>>> +   if (!hmc5843) {
>>> +           dev_dbg(&client->dev, "unable to allocate memory\n");
>>> +           return -ENOMEM;
>>> +   }
>>> +
>>> +   hmc5843->client = client;
>>> +   i2c_set_clientdata(client, hmc5843);
>>> +
>>> +   status = hmc5843_device_init(hmc5843);
>>> +   if (status)
>>> +           goto fail0;
>>> +
>>> +   status = hmc5843_input_init(hmc5843);
>>> +   if (status)
>>> +           goto fail0;
>>> +
>>> +   status = sysfs_create_group(&client->dev.kobj, &hmc5843_attr_group);
>>> +   if (status) {
>>> +           dev_dbg(&client->dev, "could not create sysfs files\n");
>>> +           goto fail1;
>>> +   }
>>> +   return 0;
>>> +fail1:
>>> +   input_unregister_polled_device(hmc5843->ipdev);
>>> +fail0:
>>> +   kfree(hmc5843);
>>> +   return status;
>>> +}
>>> +
>>> +static int __devexit hmc5843_i2c_remove(struct i2c_client *client)
>>> +{
>>> +   struct hmc5843 *hmc5843 = i2c_get_clientdata(client);
>>> +
>>> +   sysfs_remove_group(&client->dev.kobj, &hmc5843_attr_group);
>>> +   input_unregister_polled_device(hmc5843->ipdev);
>>> +   i2c_set_clientdata(client, NULL);
>>> +   kfree(hmc5843);
>>> +   return 0;
>>> +}
>>> +
>>> +#ifdef CONFIG_PM
>>> +static int hmc5843_suspend(struct device *dev)
>>> +{
>>> +   struct i2c_client *client = dev_get_drvdata(dev);
>>> +   struct hmc5843 *hmc5843 = i2c_get_clientdata(client);
>>> +
>>> +   /* save our current mode for resume and put device to sleep */
>>> +   int m = hmc5843->mode;
>> Not entirely certain but perhaps need a lock here to prevent user
>> changing mode just as suspend occurs? I haven't worked out what exactly
>> happens in that case though.
>>> +   hmc5843->mode = HMC5843_MODE_SLEEP;
>>> +   hmc5843_write_register(hmc5843, HMC5843_MODE_REG);
>>> +   hmc5843->mode = m;
>>> +   return 0;
>>> +}
>>> +
>>> +static int hmc5843_resume(struct device *dev)
>>> +{
>>> +   struct i2c_client *client = dev_get_drvdata(dev);
>>> +   struct hmc5843 *hmc5843 = i2c_get_clientdata(client);
>>> +
>>> +   /* restore whatever mode we were in before suspending */
>>> +   hmc5843_write_register(hmc5843, HMC5843_MODE_REG);
>>> +   return 0;
>>> +}
>>> +
>>> +static struct dev_pm_ops hmc5843_dev_pm_ops = {
>>> +   .suspend        = hmc5843_suspend,
>>> +   .resume         = hmc5843_resume,
>>> +};
>>> +
>>> +#define HMC5843_DEV_PM_OPS (&hmc5843_dev_pm_ops)
>>> +#else
>>> +#define    HMC5843_DEV_PM_OPS NULL
>>> +#endif
>>> +
>>> +static const struct i2c_device_id hmc5843_id[] = {
>>> +   { "hmc5843", 0 },
>>> +   { },
>>> +};
>>> +
>>> +MODULE_DEVICE_TABLE(i2c, hmc5843_id);
>>> +
>>> +static struct i2c_driver hmc5843_i2c_driver = {
>>> +   .driver         = {
>>> +           .name   = "hmc5843",
>>> +           .owner  = THIS_MODULE,
>>> +           .pm     = HMC5843_DEV_PM_OPS,
>>> +   },
>>> +   .probe          = hmc5843_i2c_probe,
>>> +   .remove         = __devexit_p(hmc5843_i2c_remove),
>>> +   .id_table       = hmc5843_id,
>>> +};
>>> +
>>> +static int __init hmc5843_init(void)
>>> +{
>>> +   return i2c_add_driver(&hmc5843_i2c_driver);
>>> +}
>>> +module_init(hmc5843_init);
>>> +
>>> +static void __exit hmc5843_exit(void)
>>> +{
>>> +   i2c_del_driver(&hmc5843_i2c_driver);
>>> +}
>>> +module_exit(hmc5843_exit);
>>> +
>>> +MODULE_AUTHOR("Steven King <sfking@fdwdc.com>");
>>> +MODULE_DESCRIPTION("Honeywell HMC5843 3-Axis Magnetometer driver");
>>> +MODULE_LICENSE("GPL");
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-input"
>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


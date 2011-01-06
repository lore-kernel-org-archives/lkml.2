Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab1AFH30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 02:29:26 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44459 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab1AFH3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 02:29:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NZdc9oMVhMDfVpvQA7WfliVMXjOKkX7hMroYGxhAkVaJaQ8gU4TRoiHwux6BQb7Nxp
         uh4IHygbXd4k2+p4It54k6o/1gOnSOc1TF2nPLvbO1f2rvd1kscHRhYIiWGWoiUKLW61
         TMWJ0cxKlDEx0E+oEJ8344+p96ow1fIAw8UD8=
MIME-Version: 1.0
In-Reply-To: <20110106025949.GJ9496@kai-debian>
References: <20110106025949.GJ9496@kai-debian>
Date: Thu, 6 Jan 2011 08:29:22 +0100
Message-ID: <AANLkTi=B1XeBTogjVPWqOSFgJMD72gTpNZgg4znAR0t3@mail.gmail.com>
Subject: Re: [PATCH] platform-driver-x86: ACPI EC Extra driver for Oaktrail
From: Corentin Chary <corentin.chary@gmail.com>
To: Yin Kangkai <kangkai.yin@linux.intel.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Liu, Bing Wei" <bing.wei.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 6, 2011 at 3:59 AM, Yin Kangkai <kangkai.yin@linux.intel.com> wrote:
> Hi,
>
> This driver implements an Extra ACPI EC driver for products based on
> Intel Oaktrail platform.  It is programming the EC space, through
> existing ACPI EC driver, to provide user space layer the sysfs and
> rfkill interfaces to enable/disable the Camera, Bluetooth, GPS, WiFi,
> 3G, and to show the status of Touchscreen.
>
> $ ./scripts/checkpatch.pl
> 0001-platform-driver-x86-ACPI-EC-Extra-driver-for-Oaktrai.patch
> total: 0 errors, 0 warnings, 366 lines checked
>
> 0001-platform-driver-x86-ACPI-EC-Extra-driver-for-Oaktrai.patch has no
> obvious style problems and is ready for submission.
>
>
> From 5d817d0b120b52ae3685edf1d67a552ab7b6b12a Mon Sep 17 00:00:00 2001
> From: Yin Kangkai <kangkai.yin@intel.com>
> Date: Wed, 22 Dec 2010 10:53:36 +0800
> Subject: [PATCH] platform-driver-x86: ACPI EC Extra driver for Oaktrail
>
> This driver implements an Extra ACPI EC driver for products based on Intel
> Oaktrail platform.  It is programming the EC space, through existing ACPI EC
> driver, to provide user space layer the sysfs and rfkill interfaces to
> enable/disable the Camera, Bluetooth, GPS, WiFi, 3G, and to show the status of
> Touchscreen.
>
> Signed-off-by: Yin Kangkai <kangkai.yin@intel.com>
> ---
>  drivers/platform/x86/Kconfig          |    9 +
>  drivers/platform/x86/Makefile         |    1 +
>  drivers/platform/x86/intel_oaktrail.c |  349 +++++++++++++++++++++++++++++++++
>  3 files changed, 359 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/platform/x86/intel_oaktrail.c
>
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 2b4038a..d1f6981 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -655,4 +655,13 @@ config XO1_RFKILL
>          Support for enabling/disabling the WLAN interface on the OLPC XO-1
>          laptop.
>
> +config INTEL_OAKTRAIL
> +       tristate "Intel Oaktrail Platform Extras"
> +       depends on ACPI
> +       depends on RFKILL
> +       ---help---
> +         Intel Oaktrail platform need this driver to provide interfaces to
> +         enable/disable the Camera, WiFi, BT etc. devices. If in doubt, say Y
> +         here; it will only load on supported platforms.
> +
>  endif # X86_PLATFORM_DEVICES
> diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
> index 7ff60e6..add8ab7 100644
> --- a/drivers/platform/x86/Makefile
> +++ b/drivers/platform/x86/Makefile
> @@ -35,3 +35,4 @@ obj-$(CONFIG_INTEL_IPS)               += intel_ips.o
>  obj-$(CONFIG_GPIO_INTEL_PMIC)  += intel_pmic_gpio.o
>  obj-$(CONFIG_XO1_RFKILL)       += xo1-rfkill.o
>  obj-$(CONFIG_IBM_RTL)          += ibm_rtl.o
> +obj-$(CONFIG_INTEL_OAKTRAIL)   += intel_oaktrail.o
> diff --git a/drivers/platform/x86/intel_oaktrail.c b/drivers/platform/x86/intel_oaktrail.c
> new file mode 100644
> index 0000000..d28d14c
> --- /dev/null
> +++ b/drivers/platform/x86/intel_oaktrail.c
> @@ -0,0 +1,349 @@
> +/*-*-linux-c-*-*/

I don't know what's our general policy about that, but I don't think
each text editor should be allowed to add its own header on each
files. Most of the time you can configure your editor to set the
right indent style based on the path of the file or something like that.

> +/*
> +  Copyright (C) 2010 Intel Corporation
> +  Author: Yin Kangkai (kangkai.yin@intel.com)
> +
> +  based on Compal driver
> +
> +  Copyright (C) 2008 Cezary Jackiewicz <cezary.jackiewicz (at) gmail.com>
> +
> +  based on MSI driver
> +
> +  Copyright (C) 2006 Lennart Poettering <mzxreary (at) 0pointer (dot) de>
> +
> +  This program is free software; you can redistribute it and/or modify
> +  it under the terms of the GNU General Public License as published by
> +  the Free Software Foundation; either version 2 of the License, or
> +  (at your option) any later version.
> +
> +  This program is distributed in the hope that it will be useful, but
> +  WITHOUT ANY WARRANTY; without even the implied warranty of
> +  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> +  General Public License for more details.
> +
> +  You should have received a copy of the GNU General Public License
> +  along with this program; if not, write to the Free Software
> +  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> +  02110-1301, USA.
> + */
> +
> +/*
> + * intel_oaktrail.c - Intel OakTrail Platform support.
> + *
> + * This driver exports a few files in /sys/devices/platform/intel_oaktrail/:
> + *
> + * gps - GPS subsystem enabled: contains either 0 or 1. (rw)
> + * wifi - WiFi subsystem enabled: contains either 0 or 1. (rw)
> + * wwan - WWAN (3G) subsystem enabled: contains either 0 or 1. (rw)

Is there a reason do add these files in /sys/devices/platform while the
functionality is already provided by rfkill ?

> + * camera - Camera subsystem enabled: contains either 0 or 1. (rw)
> + * bluetooth - Bluetooth subsystem enabled: contains either 0 or 1. (rw)
> + * touchscreen - Touchscreen subsystem enabled: contains either 0 or 1. (ro)

This should be in Documentation/ABI/testing/

> + * In addition to these platform device attributes the driver registers itself
> + * in the Linux rfkill subsystem and is available to userspace under
> + * /sys/class/rfkill/rfkillX/
> + *
> + * This driver might work on other products based on Oaktrail. If you
> + * want to try it you can pass force=1 as argument to the module which
> + * will force it to load even when the DMI data doesn't identify the
> + * product as compatible.
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/acpi.h>
> +#include <linux/platform_device.h>
> +#include <linux/dmi.h>
> +#include <linux/rfkill.h>
> +
> +#define DRIVER_NAME    "intel_oaktrail"
> +#define DRIVER_VERSION "0.1"
> +
> +/*
> + * This is the devices status address in EC space, and the control bits
> + * definition:
> + *
> + * (1 << 0):   Camera enable/disable, RW.
> + * (1 << 1):   Bluetooth enable/disable, RW.
> + * (1 << 2):   GPS enable/disable, RW.
> + * (1 << 3):   WiFi enable/disable, RW.
> + * (1 << 4):   WWAN (3G) enable/disalbe, RW.
> + * (1 << 5):   Touchscreen enable/disable, Read Only.
> + */
> +#define OT_EC_DEVICE_STATE_ADDRESS     0xD6
> +
> +#define OT_EC_CAMERA_MASK      (1 << 0)
> +#define OT_EC_BT_MASK          (1 << 1)
> +#define OT_EC_GPS_MASK         (1 << 2)
> +#define OT_EC_WIFI_MASK                (1 << 3)
> +#define OT_EC_WWAN_MASK                (1 << 4)
> +#define OT_EC_TS_MASK          (1 << 5)
> +
> +static int force;
> +module_param(force, bool, 0);
> +MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
> +
> +static struct platform_device *oaktrail_device;
> +static struct rfkill *bt_rfkill;
> +static struct rfkill *gps_rfkill;
> +static struct rfkill *wifi_rfkill;
> +static struct rfkill *wwan_rfkill;

Here you could create two (four ?) helpers that contains the logic,
and craft dummy functions which only call the helpers with the right
parameters in your macros.

These helpers could also be used by later functions.

> +#define SIMPLE_MASKED_STORE_SHOW(NAME, MASK)                           \
> +static ssize_t NAME##_show(struct device *dev,                         \
> +       struct device_attribute *attr, char *buf)                       \
> +{                                                                      \
> +       u8 value;                                                       \
> +       ec_read(OT_EC_DEVICE_STATE_ADDRESS, &value);                    \
> +       return sprintf(buf, "%d\n", ((value & MASK) != 0));             \
> +}                                                                      \
> +static ssize_t NAME##_store(struct device *dev,                                \
> +       struct device_attribute *attr, const char *buf, size_t count)   \
> +{                                                                      \
> +       int state;                                                      \
> +       u8 old_val;                                                     \
> +       ec_read(OT_EC_DEVICE_STATE_ADDRESS, &old_val);                  \
> +       if (sscanf(buf, "%d", &state) != 1 || (state < 0 || state > 1)) \
> +               return -EINVAL;                                         \
> +       ec_write(OT_EC_DEVICE_STATE_ADDRESS, state ?                    \
> +                (old_val | MASK) : (old_val & ~MASK));                 \
> +       return count;                                                   \
> +}
> +
> +SIMPLE_MASKED_STORE_SHOW(camera, OT_EC_CAMERA_MASK)
> +SIMPLE_MASKED_STORE_SHOW(bluetooth, OT_EC_BT_MASK)
> +SIMPLE_MASKED_STORE_SHOW(gps, OT_EC_GPS_MASK)
> +SIMPLE_MASKED_STORE_SHOW(wifi, OT_EC_WIFI_MASK)
> +SIMPLE_MASKED_STORE_SHOW(wwan, OT_EC_WWAN_MASK)
> +SIMPLE_MASKED_STORE_SHOW(touchscreen, OT_EC_TS_MASK)
> +
> +static DEVICE_ATTR(camera, 0644, camera_show, camera_store);
> +static DEVICE_ATTR(bluetooth, 0644, bluetooth_show, bluetooth_store);
> +static DEVICE_ATTR(gps, 0644, gps_show, gps_store);
> +static DEVICE_ATTR(wifi, 0644, wifi_show, wifi_store);
> +static DEVICE_ATTR(wwan, 0644, wwan_show, wwan_store);
> +static DEVICE_ATTR(touchscreen, 0444, touchscreen_show, NULL);
> +
> +static struct attribute *oaktrail_attributes[] = {
> +       &dev_attr_camera.attr,
> +       &dev_attr_bluetooth.attr,
> +       &dev_attr_gps.attr,
> +       &dev_attr_wifi.attr,
> +       &dev_attr_wwan.attr,
> +       &dev_attr_touchscreen.attr,
> +       NULL
> +};
> +
> +static struct attribute_group oaktrail_attribute_group = {
> +       .attrs = oaktrail_attributes
> +};
> +
> +static int oaktrail_rfkill_set(void *data, bool blocked)
> +{
> +       u8 value;
> +       u8 result;
> +       unsigned long radio = (unsigned long) data;
> +
> +       ec_read(OT_EC_DEVICE_STATE_ADDRESS, &result);
> +
> +       if (!blocked)
> +               value = (u8) (result | radio);
> +       else
> +               value = (u8) (result & ~radio);
> +
> +       ec_write(OT_EC_DEVICE_STATE_ADDRESS, value);
> +
> +       return 0;
> +}
> +
> +static const struct rfkill_ops oaktrail_rfkill_ops = {
> +       .set_block = oaktrail_rfkill_set,
> +};
> +
> +static int setup_rfkill(void)

oaktrail_rfkill_init() ?

> +{
> +       int ret;
> +
> +       wifi_rfkill = rfkill_alloc("oaktrail-wifi", &oaktrail_device->dev,
> +                               RFKILL_TYPE_WLAN, &oaktrail_rfkill_ops,
> +                               (void *) OT_EC_WIFI_MASK);
> +       if (!wifi_rfkill)
> +               return -ENOMEM;
> +
> +       ret = rfkill_register(wifi_rfkill);
> +       if (ret)
> +               goto err_register_wifi;
> +
> +       bt_rfkill = rfkill_alloc("oaktrail-bluetooth", &oaktrail_device->dev,
> +                               RFKILL_TYPE_BLUETOOTH, &oaktrail_rfkill_ops,
> +                               (void *) OT_EC_BT_MASK);
> +       if (!bt_rfkill) {
> +               ret = -ENOMEM;
> +               goto err_allocate_bt;
> +       }
> +       ret = rfkill_register(bt_rfkill);
> +       if (ret)
> +               goto err_register_bt;
> +
> +       gps_rfkill = rfkill_alloc("oaktrail-gps", &oaktrail_device->dev,
> +                               RFKILL_TYPE_GPS, &oaktrail_rfkill_ops,
> +                               (void *) OT_EC_GPS_MASK);
> +       if (!gps_rfkill) {
> +               ret = -ENOMEM;
> +               goto err_allocate_gps;
> +       }
> +       ret = rfkill_register(gps_rfkill);
> +       if (ret)
> +               goto err_register_gps;
> +
> +       wwan_rfkill = rfkill_alloc("oaktrail-wwan", &oaktrail_device->dev,
> +                               RFKILL_TYPE_WWAN, &oaktrail_rfkill_ops,
> +                               (void *) OT_EC_WWAN_MASK);
> +       if (!wwan_rfkill) {
> +               ret = -ENOMEM;
> +               goto err_allocate_wwan;
> +       }
> +       ret = rfkill_register(wwan_rfkill);
> +       if (ret)
> +               goto err_register_wwan;
> +
> +       return 0;
> +
> +err_register_wwan:
> +       rfkill_destroy(wwan_rfkill);
> +err_allocate_wwan:
> +       rfkill_unregister(gps_rfkill);
> +err_register_gps:
> +       rfkill_destroy(gps_rfkill);
> +err_allocate_gps:
> +       rfkill_unregister(bt_rfkill);
> +err_register_bt:
> +       rfkill_destroy(bt_rfkill);
> +err_allocate_bt:
> +       rfkill_unregister(wifi_rfkill);
> +err_register_wifi:
> +       rfkill_destroy(wifi_rfkill);
> +
> +       return ret;
> +}

Here  I'd write an helper function to call rfkill_alloc,
rfkill_register and handle
rfkill_register failure. And then, if any of the helper calls fail, just call
oaktrail_rfkill_exit (which which rfkill if the rfkill pointer is NULL or not).

oaktrail_rfkill_exit could also be used in the module exit function.

> +static int __devinit oaktrail_probe(struct platform_device *pdev)
> +{
> +       int err;
> +
> +       err = sysfs_create_group(&pdev->dev.kobj, &oaktrail_attribute_group);
> +       return err;
> +}

return sysfs_create_group(&pdev->dev.kobj, &oaktrail_attribute_group);

we don't really need err right now, do we ?

> +static int __devexit oaktrail_remove(struct platform_device *pdev)
> +{
> +       sysfs_remove_group(&pdev->dev.kobj, &oaktrail_attribute_group);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver oaktrail_driver = {
> +       .driver = {
> +               .name = DRIVER_NAME,
> +               .owner = THIS_MODULE,
> +       },
> +       .probe  = oaktrail_probe,
> +       .remove = __devexit_p(oaktrail_remove)
> +};
> +
> +static int dmi_check_cb(const struct dmi_system_id *id)
> +{
> +       pr_info("Identified model '%s'\n", id->ident);
> +       return 0;
> +}
> +
> +static struct dmi_system_id __initdata oaktrail_dmi_table[] = {
> +       {
> +               .ident = "OakTrail platform",
> +               .matches = {
> +                       DMI_MATCH(DMI_PRODUCT_NAME, "OakTrail platform"),
> +               },
> +               .callback = dmi_check_cb
> +       },
> +       { }
> +};
> +
> +static int __init oaktrail_init(void)
> +{
> +       int ret;
> +
> +       if (acpi_disabled) {
> +               pr_err("ACPI needs to be enabled for this driver to work!\n");
> +               return -ENODEV;
> +       }
> +
> +       if (!force && !dmi_check_system(oaktrail_dmi_table)) {
> +               pr_err("Platform not recognized (You could try the module's force-parameter)");
> +               return -ENODEV;
> +       }
> +
> +       ret = platform_driver_register(&oaktrail_driver);
> +       if (ret) {
> +               pr_warning("Unable to register platform driver\n");
> +               goto err_driver_reg;
> +       }
> +
> +       oaktrail_device = platform_device_alloc(DRIVER_NAME, -1);
> +       if (!oaktrail_device) {
> +               pr_warning("Unable to allocate platform device\n");
> +               ret = -ENOMEM;
> +               goto err_device_alloc;
> +       }
> +
> +       ret = platform_device_add(oaktrail_device);
> +       if (ret) {
> +               pr_warning("Unable to add platform device\n");
> +               goto err_device_add;
> +       }
> +
> +       ret = setup_rfkill();
> +       if (ret) {
> +               pr_warning("Setup rfkill failed\n");
> +               goto err_rfkill;
> +       }
> +
> +       pr_info("Driver "DRIVER_VERSION" successfully loaded\n");
> +       return 0;
> +
> +err_rfkill:
> +       platform_device_del(oaktrail_device);
> +err_device_add:
> +       platform_device_put(oaktrail_device);
> +err_device_alloc:
> +       platform_driver_unregister(&oaktrail_driver);
> +err_driver_reg:
> +       return ret;
> +}
> +
> +static void __exit oaktrail_cleanup(void)
> +{
> +       platform_device_unregister(oaktrail_device);
> +       platform_driver_unregister(&oaktrail_driver);
> +       rfkill_unregister(wifi_rfkill);
> +       rfkill_unregister(bt_rfkill);
> +       rfkill_unregister(gps_rfkill);
> +       rfkill_unregister(wwan_rfkill);
> +       rfkill_destroy(wifi_rfkill);
> +       rfkill_destroy(bt_rfkill);
> +       rfkill_destroy(gps_rfkill);
> +       rfkill_destroy(wwan_rfkill);
> +
> +       pr_info("Driver unloaded\n");
> +}
> +
> +module_init(oaktrail_init);
> +module_exit(oaktrail_cleanup);
> +
> +MODULE_AUTHOR("Yin Kangkai (kangkai.yin@intel.com)");
> +MODULE_DESCRIPTION("Intel Oaktrail Platform ACPI Extras");
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL");

Maybe you could add some MODULE_ALIAS("dmi:xxxxx") lines
to enable module autoloading ?

Thanks,
-- 
Corentin Chary
http://xf.iksaif.net

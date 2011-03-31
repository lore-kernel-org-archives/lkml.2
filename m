Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814Ab1CaHSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 03:18:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40092 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068Ab1CaHS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 03:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xAUwenic7bdWvwEyikgN7cw7nBDlhHzcne/DIqrrcwMFfu8NiwH+IjnsegrWZ54c+e
         puffY+F6jQEEG7Ha6FkYFiu0rRiqEZJZD+GB1uXazbV5eXtV8PIa2+mDbe8DiwM43srn
         TiOINtSoiA6eKSwpJZnGMBevRjA3/mnmGyRtc=
MIME-Version: 1.0
In-Reply-To: <3fe846159e15df6b1ea821210bf175ddae63f098.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
	<3fe846159e15df6b1ea821210bf175ddae63f098.1301436234.git.joe@perches.com>
Date: Thu, 31 Mar 2011 09:18:25 +0200
Message-ID: <AANLkTimuXoCR+b0aObZv487dx6iK_MpfzkQ9OEbJ0XRs@mail.gmail.com>
Subject: Re: [PATCH 04/23] asus: Add pr_fmt and convert printks to pr_<level>
From: Corentin Chary <corentin.chary@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2V7IkVS026969

On Wed, Mar 30, 2011 at 12:21 AM, Joe Perches <joe@perches.com> wrote:
> Add pr_fmt, prefixes each log message.
> Convert printks to pr_<level>.
> Convert pr_warning to pr_warn.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Corentin Chary <corentincj@iksaif.net>

> ---
>  drivers/platform/x86/asus-laptop.c |   34 ++++++++--------
>  drivers/platform/x86/asus-wmi.c    |   20 +++++-----
>  drivers/platform/x86/asus_acpi.c   |   77 +++++++++++++++---------------------
>  3 files changed, 59 insertions(+), 72 deletions(-)
>
> diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
> index c53b3ff..d65df92 100644
> --- a/drivers/platform/x86/asus-laptop.c
> +++ b/drivers/platform/x86/asus-laptop.c
> @@ -318,7 +318,7 @@ static int acpi_check_handle(acpi_handle handle, const char *method,
>
>        if (status != AE_OK) {
>                if (ret)
> -                       pr_warning("Error finding %s\n", method);
> +                       pr_warn("Error finding %s\n", method);
>                return -ENODEV;
>        }
>        return 0;
> @@ -383,7 +383,7 @@ static int asus_kled_lvl(struct asus_laptop *asus)
>        rv = acpi_evaluate_integer(asus->handle, METHOD_KBD_LIGHT_GET,
>                                   &params, &kblv);
>        if (ACPI_FAILURE(rv)) {
> -               pr_warning("Error reading kled level\n");
> +               pr_warn("Error reading kled level\n");
>                return -ENODEV;
>        }
>        return kblv;
> @@ -397,7 +397,7 @@ static int asus_kled_set(struct asus_laptop *asus, int kblv)
>                kblv = 0;
>
>        if (write_acpi_int(asus->handle, METHOD_KBD_LIGHT_SET, kblv)) {
> -               pr_warning("Keyboard LED display write failed\n");
> +               pr_warn("Keyboard LED display write failed\n");
>                return -EINVAL;
>        }
>        return 0;
> @@ -531,7 +531,7 @@ static int asus_read_brightness(struct backlight_device *bd)
>        rv = acpi_evaluate_integer(asus->handle, METHOD_BRIGHTNESS_GET,
>                                   NULL, &value);
>        if (ACPI_FAILURE(rv))
> -               pr_warning("Error reading brightness\n");
> +               pr_warn("Error reading brightness\n");
>
>        return value;
>  }
> @@ -541,7 +541,7 @@ static int asus_set_brightness(struct backlight_device *bd, int value)
>        struct asus_laptop *asus = bl_get_data(bd);
>
>        if (write_acpi_int(asus->handle, METHOD_BRIGHTNESS_SET, value)) {
> -               pr_warning("Error changing brightness\n");
> +               pr_warn("Error changing brightness\n");
>                return -EIO;
>        }
>        return 0;
> @@ -730,7 +730,7 @@ static ssize_t store_ledd(struct device *dev, struct device_attribute *attr,
>        rv = parse_arg(buf, count, &value);
>        if (rv > 0) {
>                if (write_acpi_int(asus->handle, METHOD_LEDD, value)) {
> -                       pr_warning("LED display write failed\n");
> +                       pr_warn("LED display write failed\n");
>                        return -ENODEV;
>                }
>                asus->ledd_status = (u32) value;
> @@ -752,7 +752,7 @@ static int asus_wireless_status(struct asus_laptop *asus, int mask)
>        rv = acpi_evaluate_integer(asus->handle, METHOD_WL_STATUS,
>                                   NULL, &status);
>        if (ACPI_FAILURE(rv)) {
> -               pr_warning("Error reading Wireless status\n");
> +               pr_warn("Error reading Wireless status\n");
>                return -EINVAL;
>        }
>        return !!(status & mask);
> @@ -764,7 +764,7 @@ static int asus_wireless_status(struct asus_laptop *asus, int mask)
>  static int asus_wlan_set(struct asus_laptop *asus, int status)
>  {
>        if (write_acpi_int(asus->handle, METHOD_WLAN, !!status)) {
> -               pr_warning("Error setting wlan status to %d", status);
> +               pr_warn("Error setting wlan status to %d\n", status);
>                return -EIO;
>        }
>        return 0;
> @@ -792,7 +792,7 @@ static ssize_t store_wlan(struct device *dev, struct device_attribute *attr,
>  static int asus_bluetooth_set(struct asus_laptop *asus, int status)
>  {
>        if (write_acpi_int(asus->handle, METHOD_BLUETOOTH, !!status)) {
> -               pr_warning("Error setting bluetooth status to %d", status);
> +               pr_warn("Error setting bluetooth status to %d\n", status);
>                return -EIO;
>        }
>        return 0;
> @@ -821,7 +821,7 @@ static ssize_t store_bluetooth(struct device *dev,
>  static int asus_wimax_set(struct asus_laptop *asus, int status)
>  {
>        if (write_acpi_int(asus->handle, METHOD_WIMAX, !!status)) {
> -               pr_warning("Error setting wimax status to %d", status);
> +               pr_warn("Error setting wimax status to %d\n", status);
>                return -EIO;
>        }
>        return 0;
> @@ -850,7 +850,7 @@ static ssize_t store_wimax(struct device *dev,
>  static int asus_wwan_set(struct asus_laptop *asus, int status)
>  {
>        if (write_acpi_int(asus->handle, METHOD_WWAN, !!status)) {
> -               pr_warning("Error setting wwan status to %d", status);
> +               pr_warn("Error setting wwan status to %d\n", status);
>                return -EIO;
>        }
>        return 0;
> @@ -880,7 +880,7 @@ static void asus_set_display(struct asus_laptop *asus, int value)
>  {
>        /* no sanity check needed for now */
>        if (write_acpi_int(asus->handle, METHOD_SWITCH_DISPLAY, value))
> -               pr_warning("Error setting display\n");
> +               pr_warn("Error setting display\n");
>        return;
>  }
>
> @@ -909,7 +909,7 @@ static ssize_t store_disp(struct device *dev, struct device_attribute *attr,
>  static void asus_als_switch(struct asus_laptop *asus, int value)
>  {
>        if (write_acpi_int(asus->handle, METHOD_ALS_CONTROL, value))
> -               pr_warning("Error setting light sensor switch\n");
> +               pr_warn("Error setting light sensor switch\n");
>        asus->light_switch = value;
>  }
>
> @@ -937,7 +937,7 @@ static ssize_t store_lssw(struct device *dev, struct device_attribute *attr,
>  static void asus_als_level(struct asus_laptop *asus, int value)
>  {
>        if (write_acpi_int(asus->handle, METHOD_ALS_LEVEL, value))
> -               pr_warning("Error setting light sensor level\n");
> +               pr_warn("Error setting light sensor level\n");
>        asus->light_level = value;
>  }
>
> @@ -976,7 +976,7 @@ static int asus_gps_status(struct asus_laptop *asus)
>        rv = acpi_evaluate_integer(asus->handle, METHOD_GPS_STATUS,
>                                   NULL, &status);
>        if (ACPI_FAILURE(rv)) {
> -               pr_warning("Error reading GPS status\n");
> +               pr_warn("Error reading GPS status\n");
>                return -ENODEV;
>        }
>        return !!status;
> @@ -1284,7 +1284,7 @@ static int asus_laptop_get_info(struct asus_laptop *asus)
>         */
>        status = acpi_get_table(ACPI_SIG_DSDT, 1, &asus->dsdt_info);
>        if (ACPI_FAILURE(status))
> -               pr_warning("Couldn't get the DSDT table header\n");
> +               pr_warn("Couldn't get the DSDT table header\n");
>
>        /* We have to write 0 on init this far for all ASUS models */
>        if (write_acpi_int_ret(asus->handle, "INIT", 0, &buffer)) {
> @@ -1296,7 +1296,7 @@ static int asus_laptop_get_info(struct asus_laptop *asus)
>        status =
>            acpi_evaluate_integer(asus->handle, "BSTS", NULL, &bsts_result);
>        if (ACPI_FAILURE(status))
> -               pr_warning("Error calling BSTS\n");
> +               pr_warn("Error calling BSTS\n");
>        else if (bsts_result)
>                pr_notice("BSTS called, 0x%02x returned\n",
>                       (uint) bsts_result);
> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
> index c382af6..8edc882 100644
> --- a/drivers/platform/x86/asus-wmi.c
> +++ b/drivers/platform/x86/asus-wmi.c
> @@ -425,7 +425,7 @@ static void asus_rfkill_hotplug(struct asus_wmi *asus)
>        if (asus->hotplug_slot) {
>                bus = pci_find_bus(0, 1);
>                if (!bus) {
> -                       pr_warning("Unable to find PCI bus 1?\n");
> +                       pr_warn("Unable to find PCI bus 1?\n");
>                        goto out_unlock;
>                }
>
> @@ -436,12 +436,12 @@ static void asus_rfkill_hotplug(struct asus_wmi *asus)
>                absent = (l == 0xffffffff);
>
>                if (blocked != absent) {
> -                       pr_warning("BIOS says wireless lan is %s, "
> -                                  "but the pci device is %s\n",
> -                                  blocked ? "blocked" : "unblocked",
> -                                  absent ? "absent" : "present");
> -                       pr_warning("skipped wireless hotplug as probably "
> -                                  "inappropriate for this model\n");
> +                       pr_warn("BIOS says wireless lan is %s, "
> +                               "but the pci device is %s\n",
> +                               blocked ? "blocked" : "unblocked",
> +                               absent ? "absent" : "present");
> +                       pr_warn("skipped wireless hotplug as probably "
> +                               "inappropriate for this model\n");
>                        goto out_unlock;
>                }
>
> @@ -500,7 +500,7 @@ static int asus_register_rfkill_notifier(struct asus_wmi *asus, char *node)
>                                                     ACPI_SYSTEM_NOTIFY,
>                                                     asus_rfkill_notify, asus);
>                if (ACPI_FAILURE(status))
> -                       pr_warning("Failed to register notify on %s\n", node);
> +                       pr_warn("Failed to register notify on %s\n", node);
>        } else
>                return -ENODEV;
>
> @@ -1583,12 +1583,12 @@ static int asus_wmi_probe(struct platform_device *pdev)
>        int ret;
>
>        if (!wmi_has_guid(ASUS_WMI_MGMT_GUID)) {
> -               pr_warning("Management GUID not found\n");
> +               pr_warn("Management GUID not found\n");
>                return -ENODEV;
>        }
>
>        if (wdrv->event_guid && !wmi_has_guid(wdrv->event_guid)) {
> -               pr_warning("Event GUID not found\n");
> +               pr_warn("Event GUID not found\n");
>                return -ENODEV;
>        }
>
> diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
> index f503607..d9312b3 100644
> --- a/drivers/platform/x86/asus_acpi.c
> +++ b/drivers/platform/x86/asus_acpi.c
> @@ -30,6 +30,8 @@
>  *
>  */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> @@ -581,8 +583,7 @@ static int read_led(const char *ledname, int ledmask)
>                if (read_acpi_int(NULL, ledname, &led_status))
>                        return led_status;
>                else
> -                       printk(KERN_WARNING "Asus ACPI: Error reading LED "
> -                              "status\n");
> +                       pr_warn("Error reading LED status\n");
>        }
>        return (hotk->status & ledmask) ? 1 : 0;
>  }
> @@ -621,8 +622,7 @@ write_led(const char __user *buffer, unsigned long count,
>                led_out = !led_out;
>
>        if (!write_acpi_int(hotk->handle, ledname, led_out, NULL))
> -               printk(KERN_WARNING "Asus ACPI: LED (%s) write failed\n",
> -                      ledname);
> +               pr_warn("LED (%s) write failed\n", ledname);
>
>        return rv;
>  }
> @@ -679,8 +679,7 @@ static ssize_t ledd_proc_write(struct file *file, const char __user *buffer,
>        if (rv > 0) {
>                if (!write_acpi_int
>                    (hotk->handle, hotk->methods->mt_ledd, value, NULL))
> -                       printk(KERN_WARNING
> -                              "Asus ACPI: LED display write failed\n");
> +                       pr_warn("LED display write failed\n");
>                else
>                        hotk->ledd_status = (u32) value;
>        }
> @@ -838,8 +837,7 @@ static int get_lcd_state(void)
>        } else {
>                /* We don't have to check anything if we are here */
>                if (!read_acpi_int(NULL, hotk->methods->lcd_status, &lcd))
> -                       printk(KERN_WARNING
> -                              "Asus ACPI: Error reading LCD status\n");
> +                       pr_warn("Error reading LCD status\n");
>
>                if (hotk->model == L2D)
>                        lcd = ~lcd;
> @@ -871,7 +869,7 @@ static int set_lcd_state(int value)
>                           the exact behaviour is simulated here */
>                }
>                if (ACPI_FAILURE(status))
> -                       printk(KERN_WARNING "Asus ACPI: Error switching LCD\n");
> +                       pr_warn("Error switching LCD\n");
>        }
>        return 0;
>
> @@ -915,13 +913,11 @@ static int read_brightness(struct backlight_device *bd)
>        if (hotk->methods->brightness_get) {    /* SPLV/GPLV laptop */
>                if (!read_acpi_int(hotk->handle, hotk->methods->brightness_get,
>                                   &value))
> -                       printk(KERN_WARNING
> -                              "Asus ACPI: Error reading brightness\n");
> +                       pr_warn("Error reading brightness\n");
>        } else if (hotk->methods->brightness_status) {  /* For D1 for example */
>                if (!read_acpi_int(NULL, hotk->methods->brightness_status,
>                                   &value))
> -                       printk(KERN_WARNING
> -                              "Asus ACPI: Error reading brightness\n");
> +                       pr_warn("Error reading brightness\n");
>        } else                  /* No GPLV method */
>                value = hotk->brightness;
>        return value;
> @@ -939,8 +935,7 @@ static int set_brightness(int value)
>        if (hotk->methods->brightness_set) {
>                if (!write_acpi_int(hotk->handle, hotk->methods->brightness_set,
>                                    value, NULL)) {
> -                       printk(KERN_WARNING
> -                              "Asus ACPI: Error changing brightness\n");
> +                       pr_warn("Error changing brightness\n");
>                        ret = -EIO;
>                }
>                goto out;
> @@ -955,8 +950,7 @@ static int set_brightness(int value)
>                                              NULL, NULL);
>                (value > 0) ? value-- : value++;
>                if (ACPI_FAILURE(status)) {
> -                       printk(KERN_WARNING
> -                              "Asus ACPI: Error changing brightness\n");
> +                       pr_warn("Error changing brightness\n");
>                        ret = -EIO;
>                }
>        }
> @@ -1008,7 +1002,7 @@ static void set_display(int value)
>        /* no sanity check needed for now */
>        if (!write_acpi_int(hotk->handle, hotk->methods->display_set,
>                            value, NULL))
> -               printk(KERN_WARNING "Asus ACPI: Error setting display\n");
> +               pr_warn("Error setting display\n");
>        return;
>  }
>
> @@ -1021,8 +1015,7 @@ static int disp_proc_show(struct seq_file *m, void *v)
>        int value = 0;
>
>        if (!read_acpi_int(hotk->handle, hotk->methods->display_get, &value))
> -               printk(KERN_WARNING
> -                      "Asus ACPI: Error reading display status\n");
> +               pr_warn("Error reading display status\n");
>        value &= 0x07;  /* needed for some models, shouldn't hurt others */
>        seq_printf(m, "%d\n", value);
>        return 0;
> @@ -1068,7 +1061,7 @@ asus_proc_add(char *name, const struct file_operations *proc_fops, mode_t mode,
>        proc = proc_create_data(name, mode, acpi_device_dir(device),
>                                proc_fops, acpi_driver_data(device));
>        if (!proc) {
> -               printk(KERN_WARNING "  Unable to create %s fs entry\n", name);
> +               pr_warn("  Unable to create %s fs entry\n", name);
>                return -1;
>        }
>        proc->uid = asus_uid;
> @@ -1085,8 +1078,8 @@ static int asus_hotk_add_fs(struct acpi_device *device)
>                mode = S_IFREG | S_IRUGO | S_IWUSR | S_IWGRP;
>        } else {
>                mode = S_IFREG | S_IRUSR | S_IRGRP | S_IWUSR | S_IWGRP;
> -               printk(KERN_WARNING "  asus_uid and asus_gid parameters are "
> -                      "deprecated, use chown and chmod instead!\n");
> +               pr_warn("  asus_uid and asus_gid parameters are "
> +                       "deprecated, use chown and chmod instead!\n");
>        }
>
>        acpi_device_dir(device) = asus_proc_dir;
> @@ -1099,8 +1092,7 @@ static int asus_hotk_add_fs(struct acpi_device *device)
>                proc->uid = asus_uid;
>                proc->gid = asus_gid;
>        } else {
> -               printk(KERN_WARNING "  Unable to create " PROC_INFO
> -                      " fs entry\n");
> +               pr_warn("  Unable to create " PROC_INFO " fs entry\n");
>        }
>
>        if (hotk->methods->mt_wled) {
> @@ -1283,20 +1275,19 @@ static int asus_hotk_get_info(void)
>         */
>        status = acpi_get_table(ACPI_SIG_DSDT, 1, &asus_info);
>        if (ACPI_FAILURE(status))
> -               printk(KERN_WARNING "  Couldn't get the DSDT table header\n");
> +               pr_warn("  Couldn't get the DSDT table header\n");
>
>        /* We have to write 0 on init this far for all ASUS models */
>        if (!write_acpi_int(hotk->handle, "INIT", 0, &buffer)) {
> -               printk(KERN_ERR "  Hotkey initialization failed\n");
> +               pr_err("  Hotkey initialization failed\n");
>                return -ENODEV;
>        }
>
>        /* This needs to be called for some laptops to init properly */
>        if (!read_acpi_int(hotk->handle, "BSTS", &bsts_result))
> -               printk(KERN_WARNING "  Error calling BSTS\n");
> +               pr_warn("  Error calling BSTS\n");
>        else if (bsts_result)
> -               printk(KERN_NOTICE "  BSTS called, 0x%02x returned\n",
> -                      bsts_result);
> +               pr_notice("  BSTS called, 0x%02x returned\n", bsts_result);
>
>        /*
>         * Try to match the object returned by INIT to the specific model.
> @@ -1324,23 +1315,21 @@ static int asus_hotk_get_info(void)
>                if (asus_info &&
>                    strncmp(asus_info->oem_table_id, "ODEM", 4) == 0) {
>                        hotk->model = P30;
> -                       printk(KERN_NOTICE
> -                              "  Samsung P30 detected, supported\n");
> +                       pr_notice("  Samsung P30 detected, supported\n");
>                        hotk->methods = &model_conf[hotk->model];
>                        kfree(model);
>                        return 0;
>                } else {
>                        hotk->model = M2E;
> -                       printk(KERN_NOTICE "  unsupported model %s, trying "
> -                              "default values\n", string);
> -                       printk(KERN_NOTICE
> -                              "  send /proc/acpi/dsdt to the developers\n");
> +                       pr_notice("  unsupported model %s, trying default values\n",
> +                                 string);
> +                       pr_notice("  send /proc/acpi/dsdt to the developers\n");
>                        kfree(model);
>                        return -ENODEV;
>                }
>        }
>        hotk->methods = &model_conf[hotk->model];
> -       printk(KERN_NOTICE "  %s model detected, supported\n", string);
> +       pr_notice("  %s model detected, supported\n", string);
>
>        /* Sort of per-model blacklist */
>        if (strncmp(string, "L2B", 3) == 0)
> @@ -1385,7 +1374,7 @@ static int asus_hotk_check(void)
>        if (hotk->device->status.present) {
>                result = asus_hotk_get_info();
>        } else {
> -               printk(KERN_ERR "  Hotkey device not present, aborting\n");
> +               pr_err("  Hotkey device not present, aborting\n");
>                return -EINVAL;
>        }
>
> @@ -1399,8 +1388,7 @@ static int asus_hotk_add(struct acpi_device *device)
>        acpi_status status = AE_OK;
>        int result;
>
> -       printk(KERN_NOTICE "Asus Laptop ACPI Extras version %s\n",
> -              ASUS_ACPI_VERSION);
> +       pr_notice("Asus Laptop ACPI Extras version %s\n", ASUS_ACPI_VERSION);
>
>        hotk = kzalloc(sizeof(struct asus_hotk), GFP_KERNEL);
>        if (!hotk)
> @@ -1428,15 +1416,14 @@ static int asus_hotk_add(struct acpi_device *device)
>                    acpi_evaluate_object(NULL, hotk->methods->brightness_down,
>                                         NULL, NULL);
>                if (ACPI_FAILURE(status))
> -                       printk(KERN_WARNING "  Error changing brightness\n");
> +                       pr_warn("  Error changing brightness\n");
>                else {
>                        status =
>                            acpi_evaluate_object(NULL,
>                                                 hotk->methods->brightness_up,
>                                                 NULL, NULL);
>                        if (ACPI_FAILURE(status))
> -                               printk(KERN_WARNING "  Strange, error changing"
> -                                      " brightness\n");
> +                               pr_warn("  Strange, error changing brightness\n");
>                }
>        }
>
> @@ -1488,7 +1475,7 @@ static int __init asus_acpi_init(void)
>
>        asus_proc_dir = proc_mkdir(PROC_ASUS, acpi_root_dir);
>        if (!asus_proc_dir) {
> -               printk(KERN_ERR "Asus ACPI: Unable to create /proc entry\n");
> +               pr_err("Unable to create /proc entry\n");
>                acpi_bus_unregister_driver(&asus_hotk_driver);
>                return -ENODEV;
>        }
> @@ -1513,7 +1500,7 @@ static int __init asus_acpi_init(void)
>                                                          &asus_backlight_data,
>                                                          &props);
>        if (IS_ERR(asus_backlight_device)) {
> -               printk(KERN_ERR "Could not register asus backlight device\n");
> +               pr_err("Could not register asus backlight device\n");
>                asus_backlight_device = NULL;
>                asus_acpi_exit();
>                return -ENODEV;
> --
> 1.7.4.2.g597a6.dirty
>
>



-- 
Corentin Chary
http://xf.iksaif.net
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�

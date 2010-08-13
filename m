Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286Ab0HMCtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 22:49:22 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59133 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab0HMCtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 22:49:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lxc1G1Gavv/tBT5kzmRn+B2YPeXCQfV24NR5jbz7KGcTwtPfk9W8XxyTzxS7o2/YrI
         iEPpc/bgAGGYyFBazIh4IaNDKDzPIE8W8BKJbxqnZl97hpkZ0wwQDuvxQaraPoc3tYey
         L4nDClfDFWjG3gU7JqrtNgv5HrvZYkg5RzkC0=
Date: Thu, 12 Aug 2010 19:49:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Neil Leeder <nleeder@codeaurora.org>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>, linux-input@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Trilok Soni <tsoni@codeaurora.org>
Subject: Re: [PATCH v2] input: mouse: add qci touchpad driver
Message-ID: <20100813024912.GA2661@core.coreip.homeip.net>
References: <1281631760-15589-1-git-send-email-nleeder@codeaurora.org>
 <4C642E6D.6000908@codeaurora.org>
 <4C64363A.4080406@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C64363A.4080406@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 01:58:18PM -0400, Neil Leeder wrote:
> On 8/12/2010 1:25 PM, Stepan Moskovchenko wrote:
> >On 8/12/2010 9:49 AM, Neil Leeder wrote:
> >>+config MOUSE_QCITP
> >>+ tristate "Quanta Computer Inc. Touchpad"
> >>+ depends on I2C
> >>+ help
> >>+ This driver supports the touchpad on Quanta smartbook devices.
> >>+
> >>+ Say Y here if you have a Quanta-based smartboot or notepad
> >Sorry, very minor point - do you mean "smartbook" here?
> >
> >A lot of machines are made by Quanta. Should this be given a description
> >/ option name that is more specific, ie, "Quanta [chip name] Touchpad"
> >or even "Quanta I2C Touchpad" ? What you have might be fine, however...
> >
> 
> Good catch on the typo. I can update the Kconfig item to include I2C
> as you suggested.
> 

Actually, since this is not a new touchpad but simply a PS/2 interface
it should be implemented as a serio driver, not input device driver.

Could you please tell me if the following works for you? Note that it
expects IRQ to be set up properly (edge vs. level trigger) by the
platform code

Thanks.

-- 
Dmitry

Input: wpce775x-serio - add driver for WPCE775x PS/2 interface

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

This is a driver for PS/2 interface part of Nuvoton WPCE775x family of
Advanced Embedded Controllers.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/serio/Kconfig          |   12 +
 drivers/input/serio/Makefile         |    1 
 drivers/input/serio/wpce775x_serio.c |  377 ++++++++++++++++++++++++++++++++++
 3 files changed, 389 insertions(+), 1 deletions(-)
 create mode 100644 drivers/input/serio/wpce775x_serio.c


diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 3bfe8fa..259e550 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -215,7 +215,7 @@ config SERIO_AMS_DELTA
 	depends on MACH_AMS_DELTA
 	default y
 	select AMS_DELTA_FIQ
-	---help---
+	help
 	  Say Y here if you have an E3 and want to use its mailboard,
 	  or any standard AT keyboard connected to the mailboard port.
 
@@ -226,4 +226,14 @@ config SERIO_AMS_DELTA
 	  To compile this driver as a module, choose M here;
 	  the module will be called ams_delta_serio.
 
+config SERIO_WPCE775X
+	tristate "WPCE775x EC PS/2 interface support"
+	depends on I2C
+	help
+	  Say Y here if you have a system with Nuvoton WPCE775x Advanced
+	  Embedded Controller chip and want to use its PS/2 interface part.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wpce775x_serio.
+
 endif
diff --git a/drivers/input/serio/Makefile b/drivers/input/serio/Makefile
index 84c80bf..e442550 100644
--- a/drivers/input/serio/Makefile
+++ b/drivers/input/serio/Makefile
@@ -24,3 +24,4 @@ obj-$(CONFIG_SERIO_RAW)		+= serio_raw.o
 obj-$(CONFIG_SERIO_AMS_DELTA)	+= ams_delta_serio.o
 obj-$(CONFIG_SERIO_XILINX_XPS_PS2)	+= xilinx_ps2.o
 obj-$(CONFIG_SERIO_ALTERA_PS2)	+= altera_ps2.o
+obj-$(CONFIG_SERIO_WPCE775X)	+= wpce775x_serio.o
diff --git a/drivers/input/serio/wpce775x_serio.c b/drivers/input/serio/wpce775x_serio.c
new file mode 100644
index 0000000..6c8dcee
--- /dev/null
+++ b/drivers/input/serio/wpce775x_serio.c
@@ -0,0 +1,377 @@
+/*
+ * Driver for PS/2 Interface part of WPCE775x Embedded Controller
+ *
+ * Copyright (c) 2010 Dmitry Torokhov
+ * Copyright (C) 2009 Quanta Computer Inc.
+ * Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ * Author: Hsin Wu <hsin.wu@quantatw.com>
+ * Author: Austin Lai <austin.lai@quantatw.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/serio.h>
+#include <linux/delay.h>
+
+struct wpce775x_ps2if {
+	struct i2c_client *client;
+	struct serio *serio;
+	unsigned int gpio;
+	unsigned int irq;
+	struct work_struct recv_work;
+	struct work_struct send_work;
+	spinlock_t send_lock;
+	unsigned char data_in[16];
+	unsigned char data_queued[8];
+	unsigned char data_out[8];
+	unsigned int out_len;
+	struct mutex pm_mutex;
+	bool opened;		/* protected by pm_mutex */
+	bool suspended;		/* protected by pm_mutex */
+};
+
+static DEFINE_MUTEX(wpce775x_wq_mutex);
+static struct workqueue_struct *wpce775x_wq;
+static int wpce775x_count;
+
+static void wpce775x_recv(struct work_struct *work)
+{
+	struct wpce775x_ps2if *ps2if =
+			container_of(work, struct wpce775x_ps2if, recv_work);
+	int count;
+	int i;
+
+	count = i2c_master_recv(ps2if->client, ps2if->data_in,
+				sizeof(ps2if->data_in));
+	if (count < 0) {
+		dev_err(&ps2if->client->dev,
+			"failed to read data, error %d", count);
+	} else {
+		for (i = 0; i < count; i++)
+			serio_interrupt(ps2if->serio, ps2if->data_in[1], 0);
+	}
+}
+
+static void wpce775x_send(struct work_struct *work)
+{
+	struct wpce775x_ps2if *ps2if =
+			container_of(work, struct wpce775x_ps2if, send_work);
+	unsigned long flags;
+	unsigned int len;
+	int error;
+
+	spin_lock_irqsave(&ps2if->send_lock, flags);
+
+	len = ps2if->out_len;
+	memcpy(ps2if->data_queued, ps2if->data_out, len);
+	ps2if->out_len = 0;
+
+	spin_unlock_irqrestore(&ps2if->send_lock, flags);
+
+	error = i2c_master_send(ps2if->client, ps2if->data_queued, len);
+	if (error < 0)
+		dev_err(&ps2if->client->dev,
+			"failed to send data, error: %d", error);
+}
+
+static int wpce775x_write(struct serio *serio, unsigned char data)
+{
+	struct wpce775x_ps2if *ps2if = serio->port_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ps2if->send_lock, flags);
+
+	ps2if->data_out[ps2if->out_len++] = data;
+	queue_work(wpce775x_wq, &ps2if->send_work);
+
+	spin_unlock_irqrestore(&ps2if->send_lock, flags);
+
+	return 0;
+}
+
+static irqreturn_t wpce775x_interrupt(int irq, void *dev_id)
+{
+	struct wpce775x_ps2if *ps2if = dev_id;
+
+	queue_work(wpce775x_wq, &ps2if->recv_work);
+
+	return IRQ_HANDLED;
+}
+
+static int wpce775x_start_wq(struct wpce775x_ps2if *ps2if)
+{
+	int retval;
+
+	retval = mutex_lock_interruptible(&wpce775x_wq_mutex);
+	if (retval)
+		return retval;
+
+	if (wpce775x_count == 0) {
+		wpce775x_wq = create_singlethread_workqueue("wpce775x-serio");
+		if (!wpce775x_wq) {
+			dev_err(&ps2if->client->dev,
+				"Failed to create wpce775x-serio workqueue\n");
+			retval = -ENOMEM;
+			goto out;
+		}
+	}
+
+	wpce775x_count++;
+
+out:
+	mutex_unlock(&wpce775x_wq_mutex);
+	return retval;
+}
+
+static void wpce775x_stop_wq(struct wpce775x_ps2if *ps2if)
+{
+	mutex_lock(&wpce775x_wq_mutex);
+
+	if (!--wpce775x_count)
+		destroy_workqueue(wpce775x_wq);
+
+	mutex_unlock(&wpce775x_wq_mutex);
+}
+
+static void wpce775x_enable(struct wpce775x_ps2if *ps2if)
+{
+	enable_irq(ps2if->irq);
+}
+
+static void wpce775x_disable(struct wpce775x_ps2if *ps2if)
+{
+	disable_irq(ps2if->irq);
+
+	cancel_work_sync(&ps2if->recv_work);
+	cancel_work_sync(&ps2if->send_work);
+}
+
+static int wpce775x_open(struct serio *serio)
+{
+	struct wpce775x_ps2if *ps2if = serio->port_data;
+	int retval;
+
+	retval = mutex_lock_interruptible(&ps2if->pm_mutex);
+	if (retval)
+		return retval;
+
+	retval = wpce775x_start_wq(ps2if);
+	if (retval)
+		goto out;
+
+	if (!ps2if->suspended)
+		wpce775x_enable(ps2if);
+
+	ps2if->opened = true;
+
+out:
+	mutex_unlock(&ps2if->pm_mutex);
+	return retval;
+}
+
+static void wpce775x_close(struct serio *serio)
+{
+	struct wpce775x_ps2if *ps2if = serio->port_data;
+
+	mutex_lock(&ps2if->pm_mutex);
+
+	if (!ps2if->suspended)
+		wpce775x_disable(ps2if);
+
+	wpce775x_stop_wq(ps2if);
+
+	ps2if->opened = false;
+
+	mutex_unlock(&ps2if->pm_mutex);
+}
+
+#ifdef CONFIG_PM
+static int wpce775x_suspend(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct wpce775x_ps2if *ps2if = i2c_get_clientdata(client);
+
+	mutex_lock(&ps2if->pm_mutex);
+
+	if (!ps2if->suspended && ps2if->opened)
+		wpce775x_disable(ps2if);
+
+	ps2if->suspended = true;
+
+	mutex_unlock(&ps2if->pm_mutex);
+
+	return 0;
+}
+
+static int wpce775x_resume(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct wpce775x_ps2if *ps2if = i2c_get_clientdata(client);
+
+	mutex_lock(&ps2if->pm_mutex);
+
+	if (ps2if->suspended && ps2if->opened)
+		wpce775x_enable(ps2if);
+
+	ps2if->suspended = false;
+
+	mutex_unlock(&ps2if->pm_mutex);
+
+	return 0;
+}
+
+static const struct dev_pm_ops wpce775x_pm_ops = {
+	.suspend  = wpce775x_suspend,
+	.resume   = wpce775x_resume,
+};
+
+#endif
+
+static int __devinit wpce775x_probe(struct i2c_client *client,
+				    const struct i2c_device_id *id)
+{
+	struct wpce775x_ps2if *ps2if;
+	struct serio *serio;
+	int irq;
+	int error;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev, "missing required i2c functionality\n");
+		return -ENODEV;
+	}
+
+	ps2if = kzalloc(sizeof(struct wpce775x_ps2if), GFP_KERNEL);
+	serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
+	if (!ps2if || !serio) {
+		error = -ENOMEM;
+		goto err_free_mem;
+	}
+
+	serio->id.type = SERIO_8042;
+	serio->write = wpce775x_write;
+	serio->open = wpce775x_open;
+	serio->close = wpce775x_close;
+	serio->port_data = ps2if;
+	serio->dev.parent = &client->dev;
+
+	strlcpy(serio->name, "WPCE775x PS/2 Interface", sizeof(serio->name));
+
+	ps2if->client = client;
+	ps2if->gpio = client->irq;
+	ps2if->serio = serio;
+
+	INIT_WORK(&ps2if->send_work, wpce775x_send);
+	INIT_WORK(&ps2if->recv_work, wpce775x_recv);
+	spin_lock_init(&ps2if->send_lock);
+	mutex_init(&ps2if->pm_mutex);
+
+	error = gpio_request(ps2if->gpio, "wpce775x-serio");
+	if (error) {
+		dev_err(&client->dev,
+			"Failed to request GPIO %d\n", ps2if->gpio);
+		goto err_free_mem;
+	}
+
+	error = gpio_direction_input(ps2if->gpio);
+	if (error) {
+		dev_err(&client->dev,
+			"Failed to configure GPIO %d as input\n", ps2if->gpio);
+		goto err_free_gpio;
+	}
+
+	irq = gpio_to_irq(ps2if->gpio);
+	if (irq < 0) {
+		error = irq;
+		dev_err(&client->dev,
+			"Unable to get irq number for GPIO %d\n", ps2if->gpio);
+		goto err_free_gpio;
+	}
+
+	ps2if->irq = irq;
+
+	error = request_irq(ps2if->irq, wpce775x_interrupt, 0,
+				client->name, ps2if);
+	if (error) {
+		dev_err(&client->dev, "Unable to claim IRQ %d\n", ps2if->irq);
+		goto err_free_gpio;
+	}
+
+	disable_irq(client->irq);
+
+	dev_info(&client->dev, "WPCE775x PS/2 interface, irq %d\n", ps2if->irq);
+
+	serio_register_port(ps2if->serio);
+	i2c_set_clientdata(client, ps2if);
+
+	return 0;
+
+err_free_gpio:
+	gpio_free(ps2if->gpio);
+err_free_mem:
+	kfree(serio);
+	kfree(ps2if);
+	return error;
+}
+
+static int __devexit wpce775x_remove(struct i2c_client *client)
+{
+	struct wpce775x_ps2if *ps2if = i2c_get_clientdata(client);
+
+	serio_unregister_port(ps2if->serio);
+	free_irq(ps2if->irq, ps2if);
+	gpio_free(ps2if->gpio);
+	kfree(ps2if);
+
+	return 0;
+}
+
+static const struct i2c_device_id wpce775x_idtable[] = {
+	{ "wpce775x-ps2" , 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(i2c, wpce775x_idtable);
+
+static struct i2c_driver i2ctp_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name  = "wpce775x-ps2",
+#ifdef CONFIG_PM
+		.pm = &wpce775x_pm_ops,
+#endif
+	},
+	.probe	  = wpce775x_probe,
+	.remove	  = __devexit_p(wpce775x_remove),
+	.id_table = wpce775x_idtable,
+};
+
+static int __init wpce775x_init(void)
+{
+	return i2c_add_driver(&i2ctp_driver);
+}
+module_init(wpce775x_init);
+
+static void __exit wpce775x_exit(void)
+{
+	i2c_del_driver(&i2ctp_driver);
+}
+module_exit(wpce775x_exit);
+
+MODULE_AUTHOR("Dmitry Torokhov <dtor@mail.ru>");
+MODULE_DESCRIPTION("Nuvoton WPCE775x Embedded Controller driver (PS/2 interface part)");
+MODULE_LICENSE("GPL v2");

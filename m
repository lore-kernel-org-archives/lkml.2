Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab0DAWnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 18:43:22 -0400
Received: from web94907.mail.in2.yahoo.com ([203.104.17.160]:38186 "HELO
	web94907.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754302Ab0DAWnT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 18:43:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=GTzDhn6gmmaYJSSaVDCOIHcn7pQk51DW4k7M4fOYZ+5as6C+XWWTVsD1CM/X7b84kOGU4YReqEVt9Fy5cD8VjwXauEvAM9L5l0riJ1sNKk0h8HYHBldJOlYRv1/lzY+uKFu7w2fnhews+xmblVOnSUfZo0WPGbTqt8PLBWW4Hfs=;
Message-ID: <215529.2509.qm@web94907.mail.in2.yahoo.com>
X-YMail-OSG: sx5teccVM1kIKWudKfxsf0HOPW0dzBY73cMfsMafWC3QFu0
 sWLSFHCYpZKNp3HBkxSeSThXwlAm3gSksXI4XzTSJrg_6hWILwoAqt8PxJrK
 3PnOXjuOC8quKmXsiI2F1.2J8UMgm3uSj3JpnxDCnGUfp5EuvxoJLmcaFLKl
 dlAU17j2ISG1yuUCbxXI5Mq7cPjyjvSaPAPOK9kRgRgtL23iCcskQ6ew19ld
 9bZILzq6zFJPizx1X3aDcdX5qe98qdogmDublyUzkQsXSRSuz5ccMivmaJ8c
 eW4Iu6eyHO5RWaOePQqNnaGE-
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Fri, 2 Apr 2010 04:13:16 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH] drivers:staging: sources for ST core
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>, Marcel Holtmann <marcel@holtmann.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <488000.27888.qm@web94909.mail.in2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Thu, 1/4/10, Pavan Savoy <pavan_savoy@ti.com> wrote:

> From: Pavan Savoy <pavan_savoy@ti.com>
> Subject: Re: [PATCH] drivers:staging: sources for ST core
> To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
> Cc: "Greg KH" <gregkh@suse.de>, "Marcel Holtmann" <marcel@holtmann.org>, linux-kernel@vger.kernel.org
> Date: Thursday, 1 April, 2010, 10:50 PM
> --- On Thu, 1/4/10, Alan Cox <alan@lxorguk.ukuu.org.uk>
> wrote:
> 
> > From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Subject: Re: [PATCH] drivers:staging: sources for ST
> core
> > To: pavan_savoy@ti.com
> > Cc: "Greg KH" <gregkh@suse.de>,
> "Marcel Holtmann" <marcel@holtmann.org>,
> linux-kernel@vger.kernel.org
> > Date: Thursday, 1 April, 2010, 2:50 PM
> > > +/*
> > > + * function to return whether the firmware
> response
> > was proper
> > > + * in case of error don't complete so that
> waiting
> > for proper
> > > + * response times out
> > > + */
> > > +void validate_firmware_response(struct sk_buff
> *skb)
> > > +{
> > > +    if (unlikely(skb->data[5] !=
> > 0)) {
> > > +        pr_err("no
> > proper response during fw download");
> > > +        pr_err("data6
> > %x", skb->data[5]);
> > 
> > In this driver you do know the device so you need to
> be
> > using dev_ and
> > passing around dev (or something that gives you dev).
> > 
> > > +static int kim_probe(struct platform_device
> *pdev)
> > > +{
> > > +    long status;
> > > +    long proto;
> > > +    long *gpios =
> > pdev->dev.platform_data;
> > > +
> > > +    status =
> > st_core_init(&kim_gdata->core_data);
> > 
> > I would expect any truely global data to be configured
> in
> > the module init
> > and then device specific data you want to do something
> like
> > this
> > 
> >     kim_data = kzalloc(sizeof(something),
> > GFP_KERNEL);
> > 
> >     ..
> > 
> >     kim_data_init(&pdev->dev,
> > kim_data);
> >     dev_set_drvdata(&pdev->dev,
> > kim_data);
> > 
> > Elsewhere you can now do
> > 
> >     kim_data =
> > dev_get_drvdata(&pdev->dev);
> > 
> > to get it back
> 
> There are 2 sets of data structures here (after removing
> the un-necessary 3rd one),
> 1. st_gdata - which I would want to tie to tty
> 2. kim_gdata - which I "would" like to tie to the pdev.
> 
> Now the problem being, I have reference of st_gdata in
> kim_gdata, and there are about 4 functions in the st_core
> where I would need the st_gdata, as in,
> 
> EXPORTED symbol st_register - because I need to add in
> entries as to who registered,
> +long st_register(struct st_proto_s *new_proto)
> +{
> +    struct st_data_s    *st_gdata;
> +    long err = ST_SUCCESS;
> +    unsigned long flags = 0;
> +
> +    st_kim_ref(&st_gdata);
> +    pr_info("%s(%d) ", __func__, new_proto->type);
> +    if (st_gdata == NULL || new_proto == NULL ||
> new_proto->recv == NULL
> +        || new_proto->reg_complete_cb == NULL) {
> +        pr_err("gdata/new_proto/recv or
> reg_complete_cb not ready");
> +        return ST_ERR_FAILURE;
> +    }
> Also in st_unregister and st_write for similar purposes,
> But I also need it in tty_open, to link it to the
> disc_data,
> 
> +static int st_tty_open(struct tty_struct *tty)
> +{
> +    int err = ST_SUCCESS;
> +    struct st_data_s *st_gdata;
> +    pr_info("%s ", __func__);
> +
> +    st_kim_ref(&st_gdata);
> +    st_gdata->tty = tty;
> +    tty->disc_data = st_gdata;
> 
> So, shouldn't some function like st_kim_ref be enough ?
> 
> +void st_kim_ref(struct st_data_s **core_data)
> +{
> +    *core_data = kim_gdata->core_data;
> +}
> 
> So Now st_gdata is tied to tty, and kim_gdata being purely
> global, as in only 1 platform device of such kind can
> exist.
> 
> Suppose 2 platform devices want to exist - then who's
> EXPORT of st_register is considered ? 
> And If bluetooth or FM wants to use this transport then,
> how would it tell onto which platform device it wants to
> attach to ?
> 
> Why should I tie kim_gdata to a pdev ?

Well, because of the comments on the architecture of this driver, I tried out the bus_ driver method, where I register a new bus type as ST (which also registers the N_TI_WL line discipline) and the different protocols on it, are registered to as devices with the N_TI_WL as bus type.

However, I ended up in some similar mess there on too, where during an st_register when I need to register devices to the bus, status-es like how many devices currently registered, and allowing other devices to register during firmware download all would then on require a data which isn't bound to any device ...

So any ideas ? What should be done ? Find below the test patch...

---
 drivers/staging/ti-st/bus_drv/bt_test_bus.c |   55 +++++++++++
 drivers/staging/ti-st/bus_drv/fm_test_bus.c |   55 +++++++++++
 drivers/staging/ti-st/bus_drv/test_bus.c    |  134 +++++++++++++++++++++++++++
 3 files changed, 244 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/ti-st/bus_drv/bt_test_bus.c
 create mode 100644 drivers/staging/ti-st/bus_drv/fm_test_bus.c
 create mode 100644 drivers/staging/ti-st/bus_drv/test_bus.c

diff --git a/drivers/staging/ti-st/bus_drv/bt_test_bus.c b/drivers/staging/ti-st/bus_drv/bt_test_bus.c
new file mode 100644
index 0000000..02ae812
--- /dev/null
+++ b/drivers/staging/ti-st/bus_drv/bt_test_bus.c
@@ -0,0 +1,55 @@
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+
+#include "st_bus.h"
+
+static int __init st_user_probe(struct device *dev, int cur_bus, int cur_slot)
+{
+	pr_info("%s\n", __func__);
+	return 0;
+}
+static int __exit st_user_remove(struct device *dev, int cur_bus, int cur_slot)
+{
+	pr_info("%s\n", __func__);
+	return 0;
+}
+
+void bt_release(struct device *dev)
+{
+	pr_info("%s\n", __func__);
+}
+
+static struct st_driver st_user_driver = {
+	.dev = {
+		.release = bt_release,
+	},
+	.id = ST_BT,
+	.name = "bluetooth",
+};
+
+static int __init st_user_init(void)
+{
+	int retval;
+	retval = st_register(&st_user_driver);
+	if (retval != 0)
+		pr_err("%s: error registering driver\n", __func__);
+
+	return retval;
+
+}
+
+static void __exit st_user_exit(void)
+{
+	pr_info("%s\n", __func__);
+	st_unregister(&st_user_driver);
+}
+
+
+
+MODULE_LICENSE("GPL");
+
+module_init(st_user_init);
+module_exit(st_user_exit);
+
diff --git a/drivers/staging/ti-st/bus_drv/fm_test_bus.c b/drivers/staging/ti-st/bus_drv/fm_test_bus.c
new file mode 100644
index 0000000..75d9980
--- /dev/null
+++ b/drivers/staging/ti-st/bus_drv/fm_test_bus.c
@@ -0,0 +1,55 @@
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+
+#include "st_bus.h"
+
+static int __init st_user_probe(struct device *dev, int cur_bus, int cur_slot)
+{
+	pr_info("%s\n", __func__);
+	return 0;
+}
+static int __exit st_user_remove(struct device *dev, int cur_bus, int cur_slot)
+{
+	pr_info("%s\n", __func__);
+	return 0;
+}
+
+void fm_release(struct device *dev)
+{
+	pr_info("%s\n", __func__);
+}
+
+static struct st_driver st_user_driver = {
+	.dev = {
+		.release = fm_release,
+	},
+	.id = ST_FM,
+	.name = "fm",
+};
+
+static int __init st_user_init(void)
+{
+	int retval;
+	retval = st_register(&st_user_driver);
+	if (retval != 0)
+		pr_err("%s: error registering driver\n", __func__);
+
+	return retval;
+
+}
+
+static void __exit st_user_exit(void)
+{
+	pr_info("%s\n", __func__);
+	st_unregister(&st_user_driver);
+}
+
+
+
+MODULE_LICENSE("GPL");
+
+module_init(st_user_init);
+module_exit(st_user_exit);
+
diff --git a/drivers/staging/ti-st/bus_drv/test_bus.c b/drivers/staging/ti-st/bus_drv/test_bus.c
new file mode 100644
index 0000000..87aaa94
--- /dev/null
+++ b/drivers/staging/ti-st/bus_drv/test_bus.c
@@ -0,0 +1,134 @@
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+
+#include "st_bus.h"
+#include "st_core.h"
+
+struct bus_type st_bus_type;
+
+static int check_if_registered(struct device *dev, void *data)
+{
+	struct st_driver *drv;
+
+	drv = dev_get_drvdata(dev);
+	pr_info("device is %s, type %d\n", drv->name, drv->id);
+	return 1;
+}
+
+int st_register(struct st_driver *drv)
+{
+	int retval;
+	struct device *dev = &drv->dev;
+
+	if (bus_find_device_by_name(&st_bus_type, NULL,
+				drv->name) != NULL) {
+		pr_err("already registered\n");
+	}
+
+	retval = bus_for_each_dev(&st_bus_type, NULL, NULL,
+		check_if_registered);
+	if (retval != 1) { /* as returned by check_if_registered */
+		/* download_firmware here */
+		pr_info("downloading firmware..\n");
+		/* HOWTO carry on with device_register ? */
+	}

This is 1 place, I would be totally lost because, I should return the flow back to the driver which called the st_register, and allow other driver to do an st_register and return them as pending - and when firmware download completes (takes around 10secs - worst case), I then have to notify all the drivers(devices) registered about the completion of firmware download.


+	dev->bus = &(st_bus_type);
+	dev_set_name(dev, drv->name);
+	dev_set_drvdata(dev, drv);
+
+	/* add device here */
+	retval = device_register(dev);
+	if (retval) {
+		pr_err("device register failed\n");
+		return -1;
+	}
+
+	pr_info("%s: %s\n", __func__, drv->name);
+	return 0;
+}
+EXPORT_SYMBOL(st_register);
+
+void st_unregister(struct st_driver *drv)
+{
+	pr_info("%s\n", __func__);
+	device_unregister(&drv->dev);
+}
+EXPORT_SYMBOL(st_unregister);
+
+
+static int st_bus_probe(struct platform_device *pdev)
+{
+	struct st_data_s *core_data;
+	pr_info("%s\n", __func__);
+	bus_register(&st_bus_type);
+
+	st_core_init(&core_data);
+	dev_set_drvdata(&pdev->dev, core_data);
+	return 0;
+}
+
+static int st_bus_remove(struct platform_device *pdev)
+{
+	struct st_data_s *core_data;
+	pr_info("%s\n", __func__);
+
+	core_data = dev_get_drvdata(&pdev->dev);
+	st_core_exit(core_data);
+	bus_unregister(&st_bus_type);
+	return 0;
+}
+
+#if 0
+static int st_bus_match(struct device *dev, struct device_driver *drv)
+{
+	return 1;
+}
+
+int st_notify(struct notifier_block *notify, unsigned long a, void *b)
+{
+	pr_info("%s \n", __func__);
+	return 0;
+}
+#endif
+
+struct bus_type st_bus_type = {
+	.name = "ti-st",
+};
+EXPORT_SYMBOL(st_bus_type);
+
+struct platform_driver st_bus_driver = {
+	.driver = {
+		.name = "kim",
+		.owner = THIS_MODULE,
+	},
+	.probe = st_bus_probe,
+	.remove = st_bus_remove,
+};
+
+#if 0
+struct notifier_block st_bus_notify = {
+	.notifier_call = st_notify,
+};
+#endif
+
+static int __init test_bus_init(void)
+{
+	platform_driver_register(&st_bus_driver);
+	return 0;
+}
+
+static void __exit test_bus_exit(void)
+{
+	pr_info("%s\n", __func__);
+	platform_driver_unregister(&st_bus_driver);
+}
+
+module_init(test_bus_init);
+module_exit(test_bus_exit);
+MODULE_AUTHOR("Pavan Savoy <pavan_savoy@ti.com>");
+MODULE_DESCRIPTION("Shared Transport Driver for TI BT/FM/GPS combo chips ");
+MODULE_LICENSE("GPL");
-- 
1.5.4.3


> > --
> > To unsubscribe from this list: send the line
> "unsubscribe
> > linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> 
>       The INTERNET now has a personality.
> YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


      Your Mail works best with the New Yahoo Optimized IE8. Get it NOW! http://downloads.yahoo.com/in/internetexplorer/

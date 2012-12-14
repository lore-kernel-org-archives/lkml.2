Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab2LNFvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 00:51:49 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15873 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab2LNFvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 00:51:19 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ec-50cabe565ad5
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: w.sang@pengutronix.de, khali@linux-fr.org, ben-linux@fluff.org,
        grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        sjg@chromium.org, grundler@chromium.org, naveen@chromium.org,
        broonie@opensource.wolfsonmicro.com
Subject: [PATCH 1/2] i2c-core: Add gpio based bus arbitration implementation
Date: Fri, 14 Dec 2012 11:20:53 +0530
Message-id: <1355464254-12768-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1355464254-12768-1-git-send-email-ch.naveen@samsung.com>
References: <1355464254-12768-1-git-send-email-ch.naveen@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWyRsSkTjds36kAg77lHBYdf78wWlzeNYfN
	Ysb5fUwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZXy62shS8MO14tmzfYwNjL8tuhg5OSQETCQW
	PZ/KCGGLSVy4t56ti5GLQ0hgKaPE/Flr2GGKvr1ZwgiRWMQose35NFYIp4dJ4vyUCWDtbAJm
	EgcXrQbrEBFIkOicdIoJxGYWeM0osXAvK4gtLOAj0da+ngXEZhFQlfj65TsziM0r4CpxfP5k
	oDkcQNsUJOZMsgEJcwq4Sey91s0MEhYCKvnaHA3RKSDxbfIhFohqWYlNB5hBrpEQeMwmse8W
	xEQJAUmJgytusExgFF7AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzAoT/97Jr2DcVWD
	xSFGAQ5GJR7eD0KnAoRYE8uKK3MPMUpwMCuJ8G7bBRTiTUmsrEotyo8vKs1JLT7E6AN0yURm
	KdHkfGDE5JXEGxqbmJsam1oaGZmZmuIQVhLnbfZICRASSE8sSc1OTS1ILYIZx8TBKdXAWLYv
	OGzFue0P/nU8LBYJyLV/Yrgs5fUjR74789iMTgu9rr95TT8s2a/zK0+8skRKX8mVk92vj7/P
	n/JeuVjsmL7z428urDkN2Sx1FTcTvr6b72OWU+Qkw3RlzgoWf1O1YvbdbL8nZ/7Wit8Y+I/B
	JGbxrBWOXK7WpYyMy1zVJuyI7V0QvGqhEktxRqKhFnNRcSIA6GKo7HcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jAd3QfacCDO7ftbTo+PuF0eLyrjls
	FjPO72NyYPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj09VG
	loIfrhXPnu1jbGD8bdHFyMkhIWAi8e3NEkYIW0ziwr31bF2MXBxCAosYJbY9n8YK4fQwSZyf
	MgGsik3ATOLgotXsILaIQIJE56RTTCA2s8BrRomFe1lBbGEBH4m29vUsIDaLgKrE1y/fmUFs
	XgFXiePzJwPN4QDapiAxZ5INSJhTwE1i77VuZpCwEFDJ1+boCYy8CxgZVjGKphYkFxQnpeca
	6RUn5haX5qXrJefnbmIEh/wz6R2MqxosDjEKcDAq8fB+EDoVIMSaWFZcmXuIUYKDWUmEd9su
	oBBvSmJlVWpRfnxRaU5q8SFGH6CbJjJLiSbnA+MxryTe0NjE3NTY1NLEwsTMEoewkjhvs0dK
	gJBAemJJanZqakFqEcw4Jg5OqQbGnsma91n+9TiYPpsg8mry1qNVNk+XW9zX8oipOldk9Z1p
	ZfYs9rmK9ZHrDR2rfP4ts1/K8uel7YI6hQtz2gV2GrVx/jZdHj5JWueIb6CniB+HlJ7Yxdj9
	X5fono/3WLs06IHDomWy8ulG9458DGdpmtRgz5GeOz1bZvG/isgLL3evURWc8/2NEktxRqKh
	FnNRcSIAerWnx6YCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arbitrator is a general purpose function which uses two GPIOs to
communicate with another device to claim/release a bus.

i2c_transfer()
	if adapter->gpio_arbit
		i2c_bus_claim();
			__i2c_transfer();
		i2c_bus_release();

Signed-off-by: Simon Glass <sjg@chromium.org>
Cc: Grant Grundler <grundler@chromium.org>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 .../devicetree/bindings/i2c/arbitrator-i2c.txt     |   56 ++++++++++++++++
 drivers/i2c/i2c-core.c                             |   67 ++++++++++++++++++++
 drivers/of/of_i2c.c                                |   27 ++++++++
 include/linux/i2c.h                                |   17 +++++
 include/linux/of_i2c.h                             |    2 +
 5 files changed, 169 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/arbitrator-i2c.txt

diff --git a/Documentation/devicetree/bindings/i2c/arbitrator-i2c.txt b/Documentation/devicetree/bindings/i2c/arbitrator-i2c.txt
new file mode 100644
index 0000000..cb91ea8
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/arbitrator-i2c.txt
@@ -0,0 +1,56 @@
+Device-Tree bindings for i2c gpio based bus arbitrator
+
+bus-arbitration-gpios :
+	Two GPIOs to use with the GPIO-based bus arbitration protocol
+(see below).
+The first should be an output, and is used to claim the I2C bus,
+the second should be an input, and signals that the other side (Client)
+wants to claim the bus. This allows two masters to share the same I2C bus.
+
+Required properties:
+	- bus-needs-gpio-arbitration;
+	- bus-arbitration-gpios: AP_CLAIM and Client_CLAIM gpios
+	- bus-arbitration-slew-delay-us:
+	- bus-arbitration-wait-retry-us:
+	- bus-arbitration-wait-free-us:
+
+Example nodes:
+
+i2c@0 {
+	/* If you want GPIO-based bus arbitration */
+	bus-needs-gpio-arbitration;
+	bus-arbitration-gpios = <&gpf0 3 1 0 0>, /* AP_CLAIM */
+		<&gpe0 4 0 3 0>; /* EC_CLAIM */
+
+	bus-arbitration-slew-delay-us = <10>;
+	bus-arbitration-wait-retry-us = <2000>;
+	bus-arbitration-wait-free-us = <50000>;
+};
+
+GPIO-based Arbitration
+======================
+This uses GPIO lines between the AP (SoC) and an attached EC (embedded
+controller) which both want to talk on the same I2C bus as master.
+
+The AP and EC each have a 'bus claim' line, which is an output that the
+other can see. These are both active low, with pull-ups enabled.
+
+- AP_CLAIM: output from AP, signalling to the EC that the AP wants the bus
+- EC_CLAIM: output from EC, signalling to the AP that the EC wants the bus
+
+
+Algorithm
+---------
+The basic algorithm is to assert your line when you want the bus, then make
+sure that the other side doesn't want it also. A detailed explanation is best
+done with an example.
+
+Let's say the AP wants to claim the bus. It:
+1. Asserts AP_CLAIM
+2. Waits a little bit for the other side to notice (slew time, say 10
+microseconds)
+3. Checks EC_CLAIM. If this is not asserted, then the AP has the bus, and
+we are done
+4. Otherwise, wait for a few milliseconds and see if EC_CLAIM is released
+5. If not, back off, release the claim and wait for a few more milliseconds
+6. Go back to 1 (until retry time has expired)
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index a7edf98..222a6da 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -32,6 +32,7 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/idr.h>
+#include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/of_device.h>
 #include <linux/completion.h>
@@ -39,6 +40,7 @@
 #include <linux/irqflags.h>
 #include <linux/rwsem.h>
 #include <linux/pm_runtime.h>
+#include <linux/gpio.h>
 #include <asm/uaccess.h>
 
 #include "i2c-core.h"
@@ -1256,6 +1258,59 @@ void i2c_release_client(struct i2c_client *client)
 }
 EXPORT_SYMBOL(i2c_release_client);
 
+/**
+ * If we have enabled arbitration on this bus, claim the i2c bus, using
+ * the GPIO-based signalling protocol.
+ */
+static int i2c_bus_claim(struct i2c_gpio_arbit *i2c_arbit)
+{
+	unsigned long stop_retry, stop_time;
+	unsigned int gpio;
+
+	/* Start a round of trying to claim the bus */
+	stop_time = jiffies + usecs_to_jiffies(i2c_arbit->wait_free_us) + 1;
+	do {
+		/* Indicate that we want to claim the bus */
+		gpio_set_value(i2c_arbit->arb_gpios[I2C_ARB_GPIO_AP], 0);
+		udelay(i2c_arbit->slew_delay_us);
+
+		/* Wait for the EC to release it */
+		stop_retry = jiffies +
+			usecs_to_jiffies(i2c_arbit->wait_retry_us) + 1;
+		while (time_before(jiffies, stop_retry)) {
+			gpio = i2c_arbit->arb_gpios[I2C_ARB_GPIO_EC];
+			if (gpio_get_value(gpio)) {
+				/* We got it, so return */
+				return 0;
+			}
+
+			usleep_range(50, 200);
+		}
+
+		/* It didn't release, so give up, wait, and try again */
+		gpio_set_value(i2c_arbit->arb_gpios[I2C_ARB_GPIO_AP], 1);
+
+		usleep_range(i2c_arbit->wait_retry_us,
+					i2c_arbit->wait_retry_us * 2);
+	} while (time_before(jiffies, stop_time));
+
+	/* Give up, release our claim */
+	gpio_set_value(i2c_arbit->arb_gpios[I2C_ARB_GPIO_AP], 1);
+	udelay(i2c_arbit->slew_delay_us);
+
+	return -EBUSY;
+}
+
+/**
+ * If we have enabled arbitration on this bus, release the i2c bus.
+ */
+static void i2c_bus_release(struct i2c_gpio_arbit *i2c_arbit)
+{
+	/* Release the bus and wait for the EC to notice */
+	gpio_set_value(i2c_arbit->arb_gpios[I2C_ARB_GPIO_AP], 1);
+	udelay(i2c_arbit->slew_delay_us);
+}
+
 struct i2c_cmd_arg {
 	unsigned	cmd;
 	void		*arg;
@@ -1412,7 +1467,19 @@ int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 			i2c_lock_adapter(adap);
 		}
 
+		if (adap->gpio_arbit) {
+			if (i2c_bus_claim(adap->gpio_arbit)) {
+				dev_err(&adap->dev, "I2C: Could not claim bus, timeout\n");
+				return -EBUSY;
+			}
+		}
+
 		ret = __i2c_transfer(adap, msgs, num);
+
+		/* Release the bus if needed */
+		if (adap->gpio_arbit)
+			i2c_bus_release(adap->gpio_arbit);
+
 		i2c_unlock_adapter(adap);
 
 		return ret;
diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
index 3550f3b..4ec3f44 100644
--- a/drivers/of/of_i2c.c
+++ b/drivers/of/of_i2c.c
@@ -111,4 +111,31 @@ struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
 }
 EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
 
+/*
+ * Property "bus-needs-gpio-arbitration" in DT node enables
+ * GPIO based bus arbitration.
+ * Populates the default timing values if not specified.
+ *
+ * Returns NULL, if "bus-needs-gpio-arbitration" is not specified.
+ */
+struct i2c_gpio_arbit *of_get_arbitrator_info(struct device_node *np,
+				struct i2c_gpio_arbit *i2c_arbit)
+{
+	if (of_get_property(np, "bus-needs-gpio-arbitration", NULL)) {
+		if (of_property_read_u32(np, "bus-arbitration-slew-delay-us",
+				&i2c_arbit->slew_delay_us))
+			i2c_arbit->slew_delay_us = 10;
+		if (of_property_read_u32(np, "bus-arbitration-wait-retry-us",
+				&i2c_arbit->wait_retry_us))
+			i2c_arbit->wait_retry_us = 2000;
+		if (of_property_read_u32(np, "bus-arbitration-wait-free-us",
+				&i2c_arbit->wait_free_us))
+			i2c_arbit->wait_free_us = 50000;
+	} else
+		i2c_arbit = NULL;
+
+	return i2c_arbit;
+}
+EXPORT_SYMBOL_GPL(of_get_arbitrator_info);
+
 MODULE_LICENSE("GPL");
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 800de22..d1ae491 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -295,6 +295,22 @@ struct i2c_board_info {
 #define I2C_BOARD_INFO(dev_type, dev_addr) \
 	.type = dev_type, .addr = (dev_addr)
 
+enum {
+	I2C_ARB_GPIO_AP,		/* AP claims i2c bus */
+	I2C_ARB_GPIO_EC,		/* EC claims i2c bus */
+
+	I2C_ARB_GPIO_COUNT,
+};
+
+/* I2C bus GPIO based arbitration information */
+struct i2c_gpio_arbit {
+	int			arb_gpios[I2C_ARB_GPIO_COUNT];
+
+	/* Arbitration parameters */
+	unsigned int		slew_delay_us;
+	unsigned int		wait_retry_us;
+	unsigned int		wait_free_us;
+};
 
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
 /* Add-on boards should register/unregister their devices; e.g. a board
@@ -388,6 +404,7 @@ struct i2c_adapter {
 	int nr;
 	char name[48];
 	struct completion dev_released;
+	struct i2c_gpio_arbit *gpio_arbit;
 
 	struct mutex userspace_clients_lock;
 	struct list_head userspace_clients;
diff --git a/include/linux/of_i2c.h b/include/linux/of_i2c.h
index 1cb775f..c57ffba 100644
--- a/include/linux/of_i2c.h
+++ b/include/linux/of_i2c.h
@@ -24,6 +24,8 @@ extern struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
 extern struct i2c_adapter *of_find_i2c_adapter_by_node(
 						struct device_node *node);
 
+extern struct i2c_gpio_arbit *of_get_arbitrator_info(struct device_node *node,
+					struct i2c_gpio_arbit *i2c_arbit);
 #else
 static inline void of_i2c_register_devices(struct i2c_adapter *adap)
 {
-- 
1.7.9.5


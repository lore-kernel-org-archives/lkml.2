Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab2JCDcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 23:32:42 -0400
Received: from tw-mx2.synaptics.com.tw ([203.163.83.68]:20384 "EHLO
	tw-mx2.synaptics.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2JCDcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 23:32:39 -0400
From: Alexandra Chin <alexandra.chin@tw.synaptics.com>
To: Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: RE: [PATCH] Input: Add new driver into Input Subsystem for
 Synaptics DS4 touchscreen I2C devices
Thread-Topic: [PATCH] Input: Add new driver into Input Subsystem for
 Synaptics DS4 touchscreen I2C devices
Thread-Index: AQHNk/HhVA088HpSAk6VMBpKXya6/ZelpTiwgAFjI8A=
Date: Wed, 3 Oct 2012 03:30:51 +0000
Message-ID: <CC51EC7B5B7F984AA566DC102237848896F590C0@hkdcw-mail1.synaptics-inc.local>
Accept-Language: zh-TW, en-US
Content-Language: zh-HK
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.51.94]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q933Wq0s003045

Add Chris in mail loop.

Best Regards,
Alexandra Chin


„ÄÄSynaptics Hong Kong Limited, Taiwan Branch
„ÄÄ5F., No. 501, Sec. 2 Tiding Blvd., Neihu District, 
„ÄÄTaipei City 114, Taiwan
Office: 886.2.8752.5700¬† ext:652
Email:Alexandra.chin@synaptics.com.tw


-----Original Message-----
From: Alexandra Chin 
Sent: Tuesday, October 02, 2012 3:58 PM
To: Dmitry Torokhov; 'Henrik Rydberg'
Cc: Linux Kernel; Linux Input; Linus Walleij; Naveen Kumar Gaddipati; Mahesh Srinivasan; Alex Chang; Scott Lin
Subject: [PATCH] Input: Add new driver into Input Subsystem for Synaptics DS4 touchscreen I2C devices

Hi Henrik/Dmitry,

We are working on a product specific driver for Synaptics DS4 I2C touchscreen
devices. It was submitted on Sept. 16, 2012, but has not been reviewed.
(http://lkml.org/lkml/2012/9/16/24). 
We found several warnings after running script/checkpatch.pl, therefore 
an updated patch is attached.

As Chris says in https://lkml.org/lkml/2012/9/19/505, this driver will enable
us to support all our customers effectively and provide our customers with 
the best flexibility possible.
Please help review attached patch, and we really appreciate your feedback :-)



Synaptics DS4 touchscreen driver implements a generic driver supporting I2C
protocol for Synaptics Design Studio 4 (DS4) family of Touchscreen Controllers
which include the following:

- S32xX series
- S730X series
- S22xx series

The driver supports multifinger pointing functionality and power management.
The driver is based on the original work submitted by
Linus Walleij <linus.walleij@stericsson.com> and
Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>.

This patch is against the v3.1-rc9 tag of Dmitry Torokhov's kernel tree,
commit bd68dfe0071b50bc69416a92ee22b63d1cc33a3b.

Changes in this patch:
 - modified:   drivers/input/touchscreen/Kconfig
 - modified:   drivers/input/touchscreen/Makefile
 - new file:   drivers/input/touchscreen/synaptics_ds4_rmi4_i2c.c
 - new file:   drivers/input/touchscreen/synaptics_ds4_rmi4_i2c.h
 - new file:   include/linux/input/synaptics_dsx.h

This patch is functionally tested on omap beagleboard-xm.

We will continue to maintain and support this driver officially, including
making updates, as well as supporting future Touch Controller revisions
from Synaptics.

Any comments are much appreciated.

Alexandra Chin

Signed-off-by: Alexandra Chin <alexandra.chin@tw.synaptics.com>
---
 drivers/input/touchscreen/Kconfig                  |   12 +
 drivers/input/touchscreen/Makefile                 |    1 +
 drivers/input/touchscreen/synaptics_ds4_rmi4_i2c.c | 1083 ++++++++++++++++++++
 drivers/input/touchscreen/synaptics_ds4_rmi4_i2c.h |   94 ++
 include/linux/input/synaptics_dsx.h                |   49 +
 5 files changed, 1239 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/synaptics_ds4_rmi4_i2c.c
 create mode 100644 drivers/input/touchscreen/synaptics_ds4_rmi4_i2c.h
 create mode 100644 include/linux/input/synaptics_dsx.h

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 1ba232c..431c72b 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -900,4 +900,16 @@ config TOUCHSCREEN_TPS6507X
 	  To compile this driver as a module, choose M here: the
 	  module will be called tps6507x_ts.
 
+config TOUCHSCREEN_SYNAPTICS_DS4_RMI4_I2C
+	tristate "Synaptics ds4 i2c touchscreen"
+	depends on I2C
+	help
+	  Say Y here if you have a Synaptics DS4 I2C touchscreen
+	  connected to your system.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called synaptics_ds4_rmi4_i2c.
+
 endif
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 178eb12..61f5f22 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -73,3 +73,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+= zylonite-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_W90X900)	+= w90p910_ts.o
 obj-$(CONFIG_TOUCHSCREEN_TPS6507X)	+= tps6507x-ts.o
+obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_DS4_RMI4_I2C)	+= synaptics_ds4_rmi4_i2c.o
diff --git a/drivers/input/touchscreen/synaptics_ds4_rmi4_i2c.c b/drivers/input/touchscreen/synaptics_ds4_rmi4_i2c.c
new file mode 100644
index 0000000..6e85d97
--- /dev/null
+++ b/drivers/input/touchscreen/synaptics_ds4_rmi4_i2c.c
@@ -0,0 +1,1083 @@
+/*
+ * Synaptics DS4 touchscreen driver
+ *
+ * Copyright (C) 2012 Synaptics Incorporated
+ *
+ * Copyright (C) 2012 Alexandra Chin <alexandra.chin@tw.synaptics.com>
+ * Copyright (C) 2012 Scott Lin <scott.lin@tw.synaptics.com>
+ * Copyright (C) 2010 Js HA <js.ha@stericsson.com>
+ * Copyright (C) 2010 Naveen Kumar G <naveen.gaddipati@stericsson.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/regulator/consumer.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/input/synaptics_dsx.h>
+#include "synaptics_ds4_rmi4_i2c.h"
+
+#define DRIVER_NAME "synaptics_ds4_i2c"
+#define INPUT_PHYS_NAME "synaptics_ds4_i2c/input0"
+
+#define PAGES_TO_SERVICE	0xFF
+#define MAX_INTR_REGISTERS	4
+#define MAX_TOUCH_MAJOR		15
+#define BUF_LEN			37
+#define PAGE_LEN		2
+#define DATA_LEN		12
+#define QUERY_LEN		9
+#define DATA_BUF_LEN		10
+#define STD_QUERY_LEN		21
+
+#define MASK_16BIT		0xFFFF
+#define MASK_8BIT		0xFF
+#define MASK_7BIT		0x7F
+#define MASK_5BIT		0x1F
+#define MASK_4BIT		0x0F
+#define MASK_3BIT		0x07
+#define MASK_2BIT		0x03
+#define TOUCH_CTRL_INTR	0x8
+
+#define NO_SLEEP_ON		(1 << 3)
+#define NO_SLEEP_OFF		(0 << 3)
+#define NORMAL_OPERATION	(0 << 0)
+#define SENSOR_SLEEP		(1 << 0)
+#define RMI4_NUMBER_OF_MAX_FINGERS	(10)
+
+#ifdef CONFIG_PM
+static int synaptics_rmi4_suspend(struct device *dev);
+static int synaptics_rmi4_resume(struct device *dev);
+#endif
+
+/*
+ * Called by synaptics_rmi4_i2c_read() and synaptics_rmi4_i2c_write().
+ *
+ * This function writes to the page select register to switch to the
+ * assigned page.
+ */
+static int synaptics_rmi4_set_page(struct synaptics_ds4_rmi4_data *pdata,
+					unsigned int address)
+{
+	unsigned char	txbuf[PAGE_LEN];
+	int retval = 0;
+	unsigned int page;
+	struct i2c_client *i2c = pdata->i2c_client;
+
+	page = ((address >> 8) & MASK_8BIT);
+	if (page != pdata->current_page) {
+		txbuf[0] = MASK_8BIT;
+		txbuf[1] = page;
+		retval = i2c_master_send(i2c, txbuf, PAGE_LEN);
+		if (retval != PAGE_LEN)
+			retval = -EIO;
+		else
+			pdata->current_page = page;
+	} else
+		retval = PAGE_LEN;
+
+	return retval;
+}
+
+/*
+ * Called by various functions in this driver
+ *
+ * This function reads data of an arbitrary length from the sensor, starting
+ * from an assigned register address of the sensor, via I2C with a retry
+ * mechanism.
+ */
+static int synaptics_rmi4_i2c_read(struct synaptics_ds4_rmi4_data *pdata,
+			unsigned short addr, unsigned char *data,
+			unsigned short length)
+{
+	int retval = 0;
+	unsigned char buf;
+	struct i2c_msg msg[] = {
+		{
+			.addr = pdata->i2c_client->addr,
+			.flags = 0,
+			.len = 1,
+			.buf = &buf,
+		},
+		{
+			.addr = pdata->i2c_client->addr,
+			.flags = I2C_M_RD,
+			.len = length,
+			.buf = data,
+		}
+	};
+	buf = addr & MASK_8BIT;
+
+	mutex_lock(&(pdata->io_ctrl_mutex));
+	retval = synaptics_rmi4_set_page(pdata, addr);
+	if (retval != PAGE_LEN)
+		goto exit;
+	retval = i2c_transfer(pdata->i2c_client->adapter, msg, ARRAY_SIZE(msg));
+	if (retval != ARRAY_SIZE(msg))
+		retval = -EIO;
+exit:
+	mutex_unlock(&(pdata->io_ctrl_mutex));
+	return retval;
+}
+
+/*
+ * Called by various functions in this driver
+ *
+ * This function writes data of an arbitrary length to the sensor, starting
+ * from an assigned register address of the sensor, via I2C with a retry
+ * mechanism.
+ */
+static int synaptics_rmi4_i2c_write(struct synaptics_ds4_rmi4_data *pdata,
+			unsigned short addr, unsigned char *data,
+			unsigned short length)
+{
+	int retval = 0;
+	unsigned char buf[length + 1];
+
+	struct i2c_msg msg[] = {
+		{
+			.addr = pdata->i2c_client->addr,
+			.flags = 0,
+			.len = length + 1,
+			.buf = buf,
+		}
+	};
+
+	mutex_lock(&(pdata->io_ctrl_mutex));
+	retval = synaptics_rmi4_set_page(pdata, addr);
+	if (retval != PAGE_LEN)
+		goto exit;
+
+	buf[0] = addr & MASK_8BIT;
+	memcpy(&buf[1], &data[0], length);
+
+	retval = i2c_transfer(pdata->i2c_client->adapter, msg, ARRAY_SIZE(msg));
+	if (retval != ARRAY_SIZE(msg))
+		retval = -EIO;
+exit:
+	mutex_unlock(&(pdata->io_ctrl_mutex));
+	return 0;
+}
+
+/*
+ * Called by synaptics_rmi4_report_device() when valid Function $11
+ * finger data has been detected.
+ *
+ * This function reads the Function $11 data registers, determines the
+ * status of each finger supported by the Function, processes any
+ * necessary coordinate manipulation, reports the finger data to
+ * the input subsystem
+ */
+static int synaptics_rmi4_abs_report(struct synaptics_ds4_rmi4_data *pdata,
+			struct synaptics_ds4_rmi4_fn *function_handler)
+{
+	int touch_count = 0;	/* number of touch points */
+	int finger;
+	int fingers_supported;
+	int finger_registers;
+	int reg;
+	int finger_shift;
+	int finger_status;
+	int retval;
+	unsigned short data_base_addr;
+	unsigned short data_offset;
+	unsigned char data_reg_blk_size;
+	unsigned char values[2];
+	unsigned char data[DATA_LEN];
+	int x[RMI4_NUMBER_OF_MAX_FINGERS];
+	int y[RMI4_NUMBER_OF_MAX_FINGERS];
+	int wx[RMI4_NUMBER_OF_MAX_FINGERS];
+	int wy[RMI4_NUMBER_OF_MAX_FINGERS];
+
+	/* get 2D sensor finger data */
+	/*
+	 * First get the finger status field - the size of the finger status
+	 * field is determined by the number of finger supporte - 2 bits per
+	 * finger, so the number of registers to read is:
+	 * registerCount = ceil(numberOfFingers/4).
+	 * Read the required number of registers and check each 2 bit field to
+	 * determine if a finger is down:
+	 *	00 = finger not present,
+	 *	01 = finger present and data accurate,
+	 *	10 = finger present but data may not be accurate,
+	 *	11 = reserved for product use.
+	 */
+	fingers_supported = function_handler->num_of_data_points;
+	finger_registers = (fingers_supported + 3) / 4;
+	data_base_addr = function_handler->fn_full_addr.data_base_addr;
+
+	retval = synaptics_rmi4_i2c_read(pdata, data_base_addr, values,
+							finger_registers);
+	if (retval < 0)
+		return retval;
+	/*
+	 * For each finger present, read the proper number of registers
+	 * to get absolute data.
+	 */
+	data_reg_blk_size = function_handler->size_of_data_register_block;
+	for (finger = 0; finger < fingers_supported; finger++) {
+		/* Determine which data byte the finger status is in */
+		reg = finger / 4;
+		/* Bit shift to get finger's status */
+		finger_shift = (finger % 4) * 2;
+		 finger_status	= (values[reg] >> finger_shift) & 3;
+		/*
+		 * If finger status indicates a finger is present then
+		 * read the finger data and report it
+		 */
+		if (finger_status == 1 || finger_status == 2) {
+			/* Read the finger data */
+			data_offset = data_base_addr +
+					((finger * data_reg_blk_size) +
+					finger_registers);
+			retval = synaptics_rmi4_i2c_read(pdata,
+						data_offset, data,
+						data_reg_blk_size);
+			if (retval < 0)
+				return retval;
+			else {
+				x[touch_count] =
+					(data[0] << 4) | (data[2] & MASK_4BIT);
+				y[touch_count] =
+					(data[1] << 4) |
+					((data[2] >> 4) & MASK_4BIT);
+				wy[touch_count] = (data[3] >> 4) & MASK_4BIT;
+				wx[touch_count] = (data[3] & MASK_4BIT);
+
+				if (pdata->board->x_flip)
+					x[touch_count] =
+						pdata->sensor_max_x -
+								x[touch_count];
+				if (pdata->board->y_flip)
+					y[touch_count] =
+						pdata->sensor_max_y -
+								y[touch_count];
+			}
+			/* Number of active touch points */
+			touch_count++;
+		}
+	}
+
+	/* Report to input subsystem */
+	if (touch_count) {
+		for (finger = 0; finger < touch_count; finger++) {
+			input_report_abs(pdata->input_dev, ABS_MT_TOUCH_MAJOR,
+						max(wx[finger] , wy[finger]));
+			input_report_abs(pdata->input_dev, ABS_MT_POSITION_X,
+								x[finger]);
+			input_report_abs(pdata->input_dev, ABS_MT_POSITION_Y,
+								y[finger]);
+			input_mt_sync(pdata->input_dev);
+		}
+	} else
+		input_mt_sync(pdata->input_dev);
+
+	/* sync after groups of events */
+	input_sync(pdata->input_dev);
+	return touch_count;
+}
+
+/*
+ * Called by synaptics_rmi4_sensor_report().
+ *
+ * This function calls the appropriate finger data reporting function
+ * based on the function handler it receives
+ */
+static int synaptics_rmi4_report_device(struct synaptics_ds4_rmi4_data *pdata,
+				struct synaptics_ds4_rmi4_fn *function_handler)
+{
+	int touch_count = 0;
+	struct i2c_client *client = pdata->i2c_client;
+
+	dev_dbg(&pdata->i2c_client->dev, "%s: function number 0x%X\n",
+				__func__, function_handler->fn_number);
+
+	switch (function_handler->fn_number) {
+	case SYNAPTICS_DS4_RMI4_2D_SENSOR_FUNC:
+		touch_count = synaptics_rmi4_abs_report(
+						pdata, function_handler);
+		break;
+	default:
+		dev_info(&client->dev, "%s: F%02X not supported\n",
+					__func__, function_handler->fn_number);
+		break;
+	}
+	return touch_count;
+}
+
+/*
+ * Called by synaptics_rmi4_irq().
+ *
+ * This function determines the interrupt source(s) from the sensor and
+ * calls synaptics_rmi4_report_device() with the appropriate function
+ * handler for each function with valid data inputs.
+ */
+static int synaptics_rmi4_sensor_report(struct synaptics_ds4_rmi4_data *pdata)
+{
+	unsigned char	intr_status[MAX_INTR_REGISTERS];
+	int retval;
+	int touch_count = 0;
+	struct synaptics_ds4_rmi4_fn *function_handler;
+	struct synaptics_ds4_rmi4_device_info *rmi;
+
+	/*
+	 * Get the interrupt status from the function $01
+	 * control register+1 to find which source(s) were interrupting
+	 * so we can read the data from the source(s) (2D sensor, buttons..)
+	 */
+	retval = synaptics_rmi4_i2c_read(pdata,
+					pdata->fn01_data_base_addr + 1,
+					intr_status,
+					pdata->number_of_interrupt_register);
+	if (retval < 0)
+		return 0;
+
+	if (pdata->touch_stopped) {
+		dev_warn(&pdata->i2c_client->dev,
+			 "Not ready to handle interrupts yet!\n");
+		return 0;
+	}
+	/*
+	 * Check each function that has data sources and if the interrupt for
+	 * that triggered then call that RMI4 functions report() function to
+	 * gather data and report it to the input subsystem
+	 */
+	rmi = &(pdata->rmi4_mod_info);
+	list_for_each_entry(function_handler, &rmi->support_fn_list, link) {
+		if (function_handler->num_of_data_sources) {
+			if (intr_status[function_handler->index_to_intr_reg] &
+						function_handler->intr_mask)
+				touch_count = synaptics_rmi4_report_device(
+						pdata, function_handler);
+		}
+	}
+	return touch_count;
+}
+
+/*
+ * Called by the kernel when an interrupt occurs (when the sensor asserts
+ * the attention irq.
+ *
+ * This function is the ISR thread and handles the acquisition and
+ * the reporting of finger data when the presence of fingers is detected.
+ */
+static irqreturn_t synaptics_rmi4_irq(int irq, void *data)
+{
+	struct synaptics_ds4_rmi4_data *pdata = data;
+	int touch_count;
+	do {
+		touch_count = synaptics_rmi4_sensor_report(pdata);
+		if (touch_count)
+			wait_event_timeout(pdata->wait, pdata->touch_stopped,
+							msecs_to_jiffies(1));
+		else
+			break;
+	} while (!pdata->touch_stopped);
+	return IRQ_HANDLED;
+}
+
+/*
+ * Called by synaptics_rmi4_probe() and the power management functions in
+ * this driver
+ *
+ * This function handles the enabling of the attention irq
+ * including the setting up of the ISR thread.
+ */
+static int synaptics_rmi4_irq_enable(struct synaptics_ds4_rmi4_data *pdata,
+					bool request)
+{
+	int retval = 0;
+	char intr_status;
+	const struct synaptics_dsx_platform_data *platformdata =
+				pdata->i2c_client->dev.platform_data;
+
+	mutex_lock(&pdata->irq_request_mutex);
+	if (pdata->irq_enabled)
+		goto exit;
+
+	/* Clear interrupts */
+	retval = synaptics_rmi4_i2c_read(pdata,
+					pdata->fn01_data_base_addr + 1,
+					&intr_status,
+					pdata->number_of_interrupt_register);
+	if (retval < 0)
+		return retval;
+	if (request) {
+		retval = request_threaded_irq(pdata->irq, NULL,
+					  synaptics_rmi4_irq,
+					  platformdata->irq_type,
+					  DRIVER_NAME, pdata);
+		if (retval) {
+			dev_err(&pdata->i2c_client->dev,
+				"%s:Unable to get attn irq %d, type %d\n",
+				__func__,
+				pdata->irq,
+				platformdata->irq_type);
+			goto exit;
+		}
+	} else
+		enable_irq(pdata->irq);
+	pdata->irq_enabled  = true;
+
+exit:
+	mutex_unlock(&pdata->irq_request_mutex);
+	return retval;
+}
+
+/*
+ * Called by synaptics_rmi4_probe() and the power management functions in
+ * this driver
+ *
+ * This function handles the disabling of the attention irq
+ * including the setting up of the ISR thread.
+ */
+static int synaptics_rmi4_irq_disable(struct synaptics_ds4_rmi4_data *pdata,
+					bool release)
+{
+	int retval = 0;
+	mutex_lock(&pdata->irq_request_mutex);
+
+	if (pdata->irq_enabled) {
+		disable_irq(pdata->irq);
+		if (release)
+			free_irq(pdata->irq, pdata);
+		pdata->irq_enabled = false;
+	} else
+		dev_warn(&pdata->i2c_client->dev,
+			 "%s:irq has not been reqested\n", __func__);
+	mutex_unlock(&pdata->irq_request_mutex);
+	return retval;
+}
+
+/*
+ * Called by synaptics_rmi4_query_device().
+ *
+ * This funtion parses information from the Function 11 registers and
+ * determines the number of fingers supported, x and y data ranges,
+ * offset to the associated interrupt status register, interrupt bit mask,
+ * and gathers finger data acquisition capabilities from the query registers.
+ */
+static int synaptics_rmi4_2d_touch_detect(
+				struct synaptics_ds4_rmi4_data *pdata,
+				struct synaptics_ds4_rmi4_fn *function_handler,
+				struct synaptics_ds4_rmi4_fn_desc *fd,
+				unsigned int interruptcount)
+{
+	unsigned char	queries[QUERY_LEN];
+	unsigned char data[BUF_LEN];
+	unsigned char	abs_data_size;
+	unsigned char	abs_data_blk_size;
+	unsigned short intr_offset;
+	int i;
+	int retval;
+
+	function_handler->fn_number = fd->fn_number;
+	function_handler->num_of_data_sources = fd->intr_src_count;
+
+	/*
+	 * need to get number of fingers supported, data size, etc.
+	 * to be used when getting data since the number of registers to
+	 * read depends on the number of fingers supported and data size.
+	 */
+	retval = synaptics_rmi4_i2c_read(pdata,
+				function_handler->fn_full_addr.query_base_addr,
+				queries, sizeof(queries));
+	if (retval < 0)
+		return retval;
+
+	/* Number of fingers */
+	if ((queries[1] & MASK_3BIT) <= 4)	/* add 1 since zero based */
+		function_handler->num_of_data_points =
+					(queries[1] & MASK_3BIT) + 1;
+	else
+		if ((queries[1] & MASK_3BIT) == 5)
+			function_handler->num_of_data_points = 10;
+
+	/* Max x/y */
+	retval = synaptics_rmi4_i2c_read(pdata,
+				function_handler->fn_full_addr.ctrl_base_addr,
+				data, DATA_BUF_LEN);
+	if (retval < 0)
+		return retval;
+
+	/* Store these for use later*/
+	pdata->sensor_max_x = ((data[6] & MASK_8BIT) << 0) |
+						((data[7] & MASK_4BIT) << 8);
+	pdata->sensor_max_y = ((data[8] & MASK_8BIT) << 0) |
+						((data[9] & MASK_4BIT) << 8);
+
+
+	/* Interrupt info for handling interrupts */
+	function_handler->index_to_intr_reg = (interruptcount + 7) / 8;
+	if (function_handler->index_to_intr_reg != 0)
+		function_handler->index_to_intr_reg -= 1;
+	/*
+	 * Loop through interrupts for each source in fn $11
+	 * and or in a bit to the interrupt mask for each.
+	 */
+	intr_offset = interruptcount % 8;
+	function_handler->intr_mask = 0;
+	for (i = intr_offset;
+		i < ((fd->intr_src_count & MASK_3BIT) + intr_offset); i++)
+		function_handler->intr_mask |= 1 << i;
+
+	/* Size of just the absolute data for one finger */
+	abs_data_size	= queries[5] & MASK_2BIT;
+
+	/* One each for X and Y, one for LSB for X & Y, one for W, one for Z */
+	abs_data_blk_size = 3 + (2 * (abs_data_size == 0 ? 1 : 0));
+	function_handler->size_of_data_register_block = abs_data_blk_size;
+
+	return retval;
+}
+
+static int synaptics_rmi4_alloc_func_handler(
+			struct synaptics_ds4_rmi4_fn **function_handler,
+			struct synaptics_ds4_rmi4_fn_desc *rmi_fd,
+			int page_number)
+{
+	*function_handler =
+		kmalloc(sizeof(struct synaptics_ds4_rmi4_fn), GFP_KERNEL);
+	if (!(*function_handler))
+		return -ENOMEM;
+
+	(*function_handler)->fn_full_addr.data_base_addr =
+		(rmi_fd->data_base_addr | (page_number << 8));
+	(*function_handler)->fn_full_addr.ctrl_base_addr =
+		(rmi_fd->ctrl_base_addr | (page_number << 8));
+	(*function_handler)->fn_full_addr.cmd_base_addr =
+		(rmi_fd->cmd_base_addr | (page_number << 8));
+	(*function_handler)->fn_full_addr.query_base_addr =
+		(rmi_fd->query_base_addr | (page_number << 8));
+	return 0;
+}
+
+/*
+ * Called by synaptics_rmi4_probe().
+ *
+ * This funtion scans the page description table, records the offsets to the
+ * register types of Function $01, sets up the function handlers for Function
+ * $11, determines the number of interrupt sources from the
+ * sensor, adds valid Functions with data inputs to the Function linked list,
+ * parses information from the query registers of Function $01, and enables
+ * the interrupt sources from the valid Functions with data inputs.
+ */
+static int synaptics_rmi4_query_device(struct synaptics_ds4_rmi4_data *pdata)
+{
+	int i, page_number;
+	int retval;
+	int data_sources = 0;
+	unsigned char std_queries[STD_QUERY_LEN];
+	unsigned char interrupt_mask[MAX_INTR_REGISTERS];
+	unsigned char intr_count = 0;
+	unsigned char intr_index = 0;
+	unsigned short ctrl_offset;
+	struct synaptics_ds4_rmi4_fn *function_handler;
+	struct synaptics_ds4_rmi4_fn_desc rmi_fd;
+	struct synaptics_ds4_rmi4_device_info *rmi;
+	struct i2c_client *client = pdata->i2c_client;
+
+	/* Init the physical drivers RMI module info list of functions */
+	INIT_LIST_HEAD(&pdata->rmi4_mod_info.support_fn_list);
+
+	/* Scan the Page Descriptor Table */
+	for (page_number = 0; page_number < PAGES_TO_SERVICE; page_number++) {
+		for (i = SYNAPTICS_DS4_RMI4_PDT_START;
+			i > SYNAPTICS_DS4_RMI4_PDT_END;
+			i -= SYNAPTICS_DS4_RMI4_PDT_ENTRY_SIZE) {
+			function_handler = NULL;
+			i |= (page_number << 8);
+
+			retval = synaptics_rmi4_i2c_read(pdata, i,
+						(unsigned char *)&rmi_fd,
+						sizeof(rmi_fd));
+			if (retval < 0)
+				return retval;
+
+			if (rmi_fd.fn_number == 0)	/* end of the PDT */
+				break;
+			dev_dbg(&pdata->i2c_client->dev,
+					"%s: function F%02X is present\n",
+					__func__, rmi_fd.fn_number);
+			switch (rmi_fd.fn_number & MASK_8BIT) {
+			case SYNAPTICS_DS4_RMI4_DEVICE_CONTROL_FUNC:
+				pdata->fn01_query_base_addr =
+						rmi_fd.query_base_addr;
+				pdata->fn01_ctrl_base_addr =
+						rmi_fd.ctrl_base_addr;
+				pdata->fn01_data_base_addr =
+						rmi_fd.data_base_addr;
+				break;
+			case SYNAPTICS_DS4_RMI4_2D_SENSOR_FUNC:
+				if (rmi_fd.intr_src_count) {
+					retval =
+					synaptics_rmi4_alloc_func_handler(
+							&function_handler,
+							&rmi_fd,
+							page_number);
+					if (retval < 0)
+						return retval;
+					retval =
+					synaptics_rmi4_2d_touch_detect(
+							pdata,
+							function_handler,
+							&rmi_fd,
+							intr_count);
+					if (retval < 0)
+						return retval;
+				}
+				break;
+			}
+			/* interrupt count for next iteration */
+			intr_count += (rmi_fd.intr_src_count & MASK_3BIT);
+			/*
+			 * add functions to the list that have data associated
+			 */
+			if (function_handler && rmi_fd.intr_src_count) {
+				/* link this function info to RMI module */
+				mutex_lock(&(pdata->fn_list_mutex));
+				dev_dbg(&pdata->i2c_client->dev,
+				    "%s: add fiunction handler 0x%X to list\n",
+				    __func__, function_handler->fn_number);
+				list_add_tail(&function_handler->link,
+					&pdata->rmi4_mod_info.support_fn_list);
+				mutex_unlock(&(pdata->fn_list_mutex));
+			}
+		}
+	}
+	/*
+	 * calculate the interrupt register count - used in the
+	 * ISR to read the correct number of interrupt registers
+	 */
+	pdata->number_of_interrupt_register = (intr_count + 7) / 8;
+	dev_dbg(&client->dev, "%s: interrupt register count :%d\n",
+					__func__,
+					pdata->number_of_interrupt_register);
+
+	/* Load up the standard queries and get the RMI4 module info */
+	retval = synaptics_rmi4_i2c_read(pdata, pdata->fn01_query_base_addr,
+					std_queries, sizeof(std_queries));
+	if (retval < 0)
+		return retval;
+
+	/*
+	 * get manufacturer id, product_props, product info,
+	 * date code, tester id, serial num and product id (name)
+	 */
+	pdata->rmi4_mod_info.manufacturer_id = std_queries[0];
+	pdata->rmi4_mod_info.product_props = std_queries[1];
+	pdata->rmi4_mod_info.product_info[0] = std_queries[2];
+	pdata->rmi4_mod_info.product_info[1] = std_queries[3];
+	/* year - 2001-2032 */
+	pdata->rmi4_mod_info.date_code[0] = std_queries[4] & MASK_5BIT;
+	/* month - 1-12 */
+	pdata->rmi4_mod_info.date_code[1] = std_queries[5] & MASK_4BIT;
+	/* day - 1-31 */
+	pdata->rmi4_mod_info.date_code[2] = std_queries[6] & MASK_5BIT;
+	pdata->rmi4_mod_info.tester_id = ((std_queries[7] & MASK_7BIT) << 8) |
+						(std_queries[8] & MASK_7BIT);
+	pdata->rmi4_mod_info.serial_number =
+				((std_queries[9] & MASK_7BIT) << 8) |
+				(std_queries[10] & MASK_7BIT);
+	memcpy(pdata->rmi4_mod_info.product_id_string, &std_queries[11], 10);
+
+	/* Check if this is a Synaptics device - report if not. */
+	if (pdata->rmi4_mod_info.manufacturer_id != 1)
+			dev_err(&client->dev, "%s: non-Synaptics mfg id:%d\n",
+					__func__,
+					pdata->rmi4_mod_info.manufacturer_id);
+
+	memset(interrupt_mask, 0x00, sizeof(interrupt_mask));
+	list_for_each_entry(function_handler,
+			&pdata->rmi4_mod_info.support_fn_list, link)
+			data_sources += function_handler->num_of_data_sources;
+	if (data_sources) {
+		rmi = &(pdata->rmi4_mod_info);
+		list_for_each_entry(function_handler,
+					&rmi->support_fn_list, link) {
+			if (function_handler->num_of_data_sources)
+				intr_index =
+					function_handler->index_to_intr_reg;
+				interrupt_mask[intr_index] |=
+				function_handler->intr_mask;
+		}
+	}
+
+	for (i = 0; i < MAX_INTR_REGISTERS; i++) {
+		if (interrupt_mask[i] != 0x00) {
+			dev_dbg(&client->dev,
+					"%s: interrupt %d enable mask :0x%X\n",
+					__func__, i, interrupt_mask[i]);
+			ctrl_offset = pdata->fn01_ctrl_base_addr + 1 + i;
+			retval = synaptics_rmi4_i2c_write(pdata,
+						ctrl_offset,
+						&(interrupt_mask[i]),
+						sizeof(interrupt_mask[i]));
+			if (retval < 0)
+				return retval;
+		}
+	}
+	return 0;
+}
+
+static int __devinit synaptics_rmi4_probe(
+		struct i2c_client *client, const struct i2c_device_id *dev_id)
+{
+	int retval;
+	struct synaptics_ds4_rmi4_data *pdata;
+	struct synaptics_ds4_rmi4_fn *function_handler;
+	const struct synaptics_dsx_platform_data *platformdata =
+						client->dev.platform_data;
+
+	if (!i2c_check_functionality(client->adapter,
+					I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_err(&client->dev, "i2c smbus byte data not supported\n");
+		return -EIO;
+	}
+
+	if (!platformdata) {
+		dev_err(&client->dev, "%s: no platform data\n", __func__);
+		return -EINVAL;
+	}
+
+	/* Allocate and initialize the instance data for this client */
+	pdata = kzalloc(sizeof(struct synaptics_ds4_rmi4_data) * 2,
+							GFP_KERNEL);
+	if (!pdata) {
+		dev_err(&client->dev, "%s: no memory allocated\n", __func__);
+		return -ENOMEM;
+	}
+
+	pdata->input_dev = input_allocate_device();
+	if (pdata->input_dev == NULL) {
+		dev_err(&client->dev, "%s:input device alloc failed\n",
+						__func__);
+		retval = -ENOMEM;
+		goto err_input;
+	}
+
+	if (platformdata->regulator_en) {
+		pdata->regulator = regulator_get(&client->dev, "vdd");
+		if (IS_ERR(pdata->regulator)) {
+			dev_err(&client->dev, "%s:get regulator failed\n",
+								__func__);
+			retval = PTR_ERR(pdata->regulator);
+			goto err_regulator;
+		}
+		regulator_enable(pdata->regulator);
+	}
+	init_waitqueue_head(&pdata->wait);
+	pdata->i2c_client		= client;
+	pdata->current_page	= MASK_16BIT;
+	pdata->board		= platformdata;
+	pdata->sensor_sleep	= false;
+	pdata->irq_enabled	= false;
+	pdata->touch_stopped	= false;
+
+	/* Init the mutexes for maintain the lists */
+	mutex_init(&(pdata->fn_list_mutex));
+	mutex_init(&(pdata->io_ctrl_mutex));
+
+	/*
+	 * Register physical driver - this will call the detect function that
+	 * will then scan the device and determine the supported
+	 * rmi4 functions.
+	 */
+	retval = synaptics_rmi4_query_device(pdata);
+	if (retval) {
+		dev_err(&client->dev, "%s: rmi4 query device failed\n",
+							__func__);
+		goto err_query_dev;
+	}
+
+	/* Store the instance data in the i2c_client */
+	i2c_set_clientdata(client, pdata);
+
+	/* Initialize the input device parameters */
+	pdata->input_dev->name = DRIVER_NAME;
+	pdata->input_dev->phys = INPUT_PHYS_NAME;
+	pdata->input_dev->id.bustype = BUS_I2C;
+	pdata->input_dev->dev.parent = &client->dev;
+	input_set_drvdata(pdata->input_dev, pdata);
+
+	/* Initialize the function handlers for rmi4 */
+	set_bit(EV_SYN, pdata->input_dev->evbit);
+	set_bit(EV_KEY, pdata->input_dev->evbit);
+	set_bit(EV_ABS, pdata->input_dev->evbit);
+#ifdef INPUT_PROP_DIRECT
+	set_bit(INPUT_PROP_DIRECT, pdata->input_dev->propbit);
+#endif
+
+	input_set_abs_params(pdata->input_dev, ABS_MT_POSITION_X, 0,
+						pdata->sensor_max_x, 0, 0);
+	input_set_abs_params(pdata->input_dev, ABS_MT_POSITION_Y, 0,
+						pdata->sensor_max_y, 0, 0);
+	input_set_abs_params(pdata->input_dev, ABS_MT_TOUCH_MAJOR, 0,
+						MAX_TOUCH_MAJOR, 0, 0);
+
+	retval = input_register_device(pdata->input_dev);
+	if (retval) {
+		dev_err(&client->dev, "%s:input register failed\n", __func__);
+		goto err_query_dev;
+	}
+
+	/* Gpio configuration */
+	if (platformdata->gpio_config) {
+		retval = platformdata->gpio_config(platformdata->gpio, true);
+		if (retval < 0) {
+			dev_err(&client->dev,
+				"Failed to configure GPIOs, code: %d.\n",
+				retval);
+			return retval;
+		}
+		dev_info(&client->dev, "Done with GPIO configuration.\n");
+	}
+	pdata->irq = gpio_to_irq(platformdata->gpio);
+	mutex_init(&(pdata->irq_request_mutex));
+	pdata->touch_stopped = false;
+	retval = synaptics_rmi4_irq_enable(pdata, true);
+	if (retval) {
+		dev_err(&client->dev,
+			"%s:Unable to get attn irq %d, type %d\n, name: %s",
+			__func__, pdata->irq, platformdata->irq_type,
+			DRIVER_NAME);
+		goto err_request_irq;
+	}
+
+	return retval;
+
+err_request_irq:
+	input_unregister_device(pdata->input_dev);
+err_query_dev:
+	if (platformdata->regulator_en) {
+		regulator_disable(pdata->regulator);
+		regulator_put(pdata->regulator);
+	}
+
+	if (!list_empty(&pdata->rmi4_mod_info.support_fn_list)) {
+		list_for_each_entry(function_handler,
+			&pdata->rmi4_mod_info.support_fn_list, link) {
+			if (function_handler) {
+				kfree(function_handler->data);
+				kfree(function_handler);
+			}
+		}
+	}
+
+err_regulator:
+	input_free_device(pdata->input_dev);
+	pdata->input_dev = NULL;
+err_input:
+	kfree(pdata);
+
+	return retval;
+}
+
+static int __devexit synaptics_rmi4_remove(struct i2c_client *client)
+{
+	struct synaptics_ds4_rmi4_data *pdata = i2c_get_clientdata(client);
+	const struct synaptics_dsx_platform_data *platformdata = pdata->board;
+
+	pdata->touch_stopped = true;
+	synaptics_rmi4_irq_disable(pdata, true);
+
+	input_unregister_device(pdata->input_dev);
+	if (platformdata->regulator_en) {
+		regulator_disable(pdata->regulator);
+		regulator_put(pdata->regulator);
+	}
+	kfree(pdata);
+	return 0;
+}
+
+/*
+ * Called by synaptics_rmi4_suspend().
+ *
+ * This function stops finger data acquisition and puts the sensor to sleep.
+ */
+static void synaptics_rmi4_sensor_sleep(struct synaptics_ds4_rmi4_data *pdata)
+{
+	int retval;
+	unsigned char device_ctrl;
+
+	if (pdata->sensor_sleep == true)
+		return;
+
+	pdata->touch_stopped = true;
+	wake_up(&pdata->wait);
+
+	retval = synaptics_rmi4_i2c_read(pdata,
+				pdata->fn01_ctrl_base_addr,
+				&device_ctrl,
+				1);
+
+	if (retval < 0) {
+		dev_err(&(pdata->input_dev->dev),
+			"Failed to enter sleep mode. Code: %d.\n", retval);
+		pdata->sensor_sleep = false;
+		return;
+	}
+
+	device_ctrl = (device_ctrl & ~MASK_3BIT);
+	device_ctrl = (device_ctrl | NO_SLEEP_OFF | SENSOR_SLEEP);
+
+	retval = synaptics_rmi4_i2c_write(pdata, pdata->fn01_ctrl_base_addr,
+						&device_ctrl, 1);
+
+	if (retval < 0) {
+		dev_err(&(pdata->input_dev->dev),
+			"Failed to enter sleep mode. Code: %d.\n", retval);
+		pdata->sensor_sleep = false;
+		return;
+	} else
+		pdata->sensor_sleep = true;
+
+	return;
+}
+
+/*
+ * Called by synaptics_rmi4_resume().
+ *
+ * This function wakes the sensor from sleep.
+ */
+static void synaptics_rmi4_sensor_wake(struct synaptics_ds4_rmi4_data *pdata)
+{
+	int retval;
+	unsigned char device_ctrl;
+
+	if (pdata->sensor_sleep == false)
+		return;
+	retval = synaptics_rmi4_i2c_read(pdata,
+				pdata->fn01_ctrl_base_addr,
+				&device_ctrl,
+				1);
+
+	if (retval < 0) {
+		dev_err(&(pdata->input_dev->dev),
+			"Failed to wake from sleep mode. Code: %d.\n",
+			retval);
+		pdata->sensor_sleep = true;
+		return;
+	}
+
+	device_ctrl = (device_ctrl & ~MASK_3BIT);
+	device_ctrl = (device_ctrl | NO_SLEEP_OFF | NORMAL_OPERATION);
+
+	retval = synaptics_rmi4_i2c_write(pdata, pdata->fn01_ctrl_base_addr,
+						&device_ctrl, 1);
+
+	if (retval < 0) {
+		dev_err(&(pdata->input_dev->dev),
+			"Failed to wake from sleep mode. Code: %d.\n",
+			retval);
+		pdata->sensor_sleep = true;
+		return;
+	} else
+		pdata->sensor_sleep = false;
+
+	return;
+}
+
+#ifdef CONFIG_PM
+/*
+ * Called by the kernel during the suspend phase when the system
+ * enters suspend.
+ *
+ * This function stops finger data acquisition and puts the sensor to
+ * sleep, disables the interrupt, and turns off the power to the sensor.
+ */
+static int synaptics_rmi4_suspend(struct device *dev)
+{
+	struct synaptics_ds4_rmi4_data *pdata = dev_get_drvdata(dev);
+	const struct synaptics_dsx_platform_data *platformdata = pdata->board;
+
+	synaptics_rmi4_irq_disable(pdata, false);
+	synaptics_rmi4_sensor_sleep(pdata);
+
+	if (platformdata->regulator_en)
+		regulator_disable(pdata->regulator);
+	return 0;
+}
+
+/*
+ * Called by the kernel during the resume phase when the system
+ * wakes up from suspend.
+ *
+ * This function turns on the power to the sensor, wakes the sensor
+ * from sleep, enables the interrupt, and starts finger data
+ * acquisition.
+ */
+static int synaptics_rmi4_resume(struct device *dev)
+{
+	struct synaptics_ds4_rmi4_data *pdata = dev_get_drvdata(dev);
+	const struct synaptics_dsx_platform_data *platformdata = pdata->board;
+
+	if (platformdata->regulator_en)
+		regulator_enable(pdata->regulator);
+
+	synaptics_rmi4_sensor_wake(pdata);
+	synaptics_rmi4_irq_enable(pdata, false);
+	pdata->touch_stopped = false;
+
+	return 0;
+}
+
+static const struct dev_pm_ops synaptics_rmi4_dev_pm_ops = {
+	.suspend = synaptics_rmi4_suspend,
+	.resume  = synaptics_rmi4_resume,
+};
+#endif
+
+static const struct i2c_device_id synaptics_rmi4_id_table[] = {
+	{ DRIVER_NAME, 0 },
+	{ },
+};
+
+MODULE_DEVICE_TABLE(i2c, synaptics_rmi4_id_table);
+
+static struct i2c_driver synaptics_rmi4_driver = {
+	.driver = {
+		.name	=	DRIVER_NAME,
+		.owner	=	THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	=	&synaptics_rmi4_dev_pm_ops,
+#endif
+	},
+	.probe		=	synaptics_rmi4_probe,
+	.remove		=	__devexit_p(synaptics_rmi4_remove),
+	.id_table	=	synaptics_rmi4_id_table,
+};
+
+static int __init synaptics_rmi4_init(void)
+{
+	return i2c_add_driver(&synaptics_rmi4_driver);
+}
+
+static void __exit synaptics_rmi4_exit(void)
+{
+	i2c_del_driver(&synaptics_rmi4_driver);
+}
+
+module_init(synaptics_rmi4_init);
+module_exit(synaptics_rmi4_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Synaptics, Inc.");
+MODULE_DESCRIPTION("synaptics ds4 i2c touch driver");
diff --git a/drivers/input/touchscreen/synaptics_ds4_rmi4_i2c.h b/drivers/input/touchscreen/synaptics_ds4_rmi4_i2c.h
new file mode 100644
index 0000000..58329d9
--- /dev/null
+++ b/drivers/input/touchscreen/synaptics_ds4_rmi4_i2c.h
@@ -0,0 +1,94 @@
+/*
+ * Synaptics DS4 touchscreen driver
+ *
+ * Copyright (C) 2012 Synaptics Incorporated
+ *
+ * Copyright (C) 2012 Alexandra Chin <alexandra.chin@tw.synaptics.com>
+ * Copyright (C) 2012 Scott Lin <scott.lin@tw.synaptics.com>
+ * Copyright (C) 2010 Js HA <js.ha@stericsson.com>
+ * Copyright (C) 2010 Naveen Kumar G <naveen.gaddipati@stericsson.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _SYNAPTICS_DS4_RMI4_H_
+#define _SYNAPTICS_DS4_RMI4_H_
+
+#define SYNAPTICS_DS4_RMI4_PDT_START				(0x00E9)
+#define SYNAPTICS_DS4_RMI4_PDT_END				(0x000A)
+#define SYNAPTICS_DS4_RMI4_PDT_ENTRY_SIZE		(0x0006)
+#define SYNAPTICS_DS4_RMI4_DEVICE_CONTROL_FUNC	(0x01)
+#define SYNAPTICS_DS4_RMI4_2D_SENSOR_FUNC		(0x11)
+
+/* funtion descriptor information */
+struct synaptics_ds4_rmi4_fn_desc {
+	unsigned char	query_base_addr;
+	unsigned char	cmd_base_addr;
+	unsigned char	ctrl_base_addr;
+	unsigned char	data_base_addr;
+	unsigned char	intr_src_count;
+	unsigned char	fn_number;
+};
+
+/*  funtion information */
+struct synaptics_ds4_rmi4_fn {
+	unsigned char fn_number;
+	unsigned char num_of_data_sources;
+	unsigned char num_of_data_points;
+	unsigned char size_of_data_register_block;
+	unsigned char index_to_intr_reg;
+	unsigned char intr_mask;
+	struct synaptics_ds4_rmi4_fn_desc fn_full_addr;
+	struct list_head link;
+	void *data;
+};
+
+/* device information */
+struct synaptics_ds4_rmi4_device_info {
+	unsigned char manufacturer_id;
+	unsigned char product_props;
+	unsigned char product_info[2];
+	unsigned char date_code[3];
+	unsigned short tester_id;
+	unsigned short serial_number;
+	unsigned char product_id_string[11];
+	struct list_head support_fn_list;
+};
+
+/* ds4 rmi4 touch screen data */
+struct synaptics_ds4_rmi4_data {
+	const struct synaptics_dsx_platform_data *board;
+	struct input_dev *input_dev;
+	struct i2c_client *i2c_client;
+	struct mutex fn_list_mutex;
+	struct mutex io_ctrl_mutex;
+	struct mutex irq_request_mutex;
+	struct synaptics_ds4_rmi4_device_info rmi4_mod_info;
+	struct regulator *regulator;
+	unsigned int number_of_interrupt_register;
+	unsigned short current_page;
+	unsigned short fn01_ctrl_base_addr;
+	unsigned short fn01_query_base_addr;
+	unsigned short fn01_data_base_addr;
+	unsigned short sensor_max_x;
+	unsigned short sensor_max_y;
+	wait_queue_head_t	 wait;
+	bool touch_stopped;
+	bool irq_enabled;
+	bool sensor_sleep;
+	int irq;
+};
+
+#endif
diff --git a/include/linux/input/synaptics_dsx.h b/include/linux/input/synaptics_dsx.h
new file mode 100644
index 0000000..4f0d0d6
--- /dev/null
+++ b/include/linux/input/synaptics_dsx.h
@@ -0,0 +1,49 @@
+/*
+ * Synaptics DS4 touchscreen driver
+ *
+ * Copyright (C) 2012 Synaptics Incorporated
+ *
+ * Copyright (C) 2012 Alexandra Chin <alexandra.chin@tw.synaptics.com>
+ * Copyright (C) 2012 Scott Lin <scott.lin@tw.synaptics.com>
+ * Copyright (C) 2010 Js HA <js.ha@stericsson.com>
+ * Copyright (C) 2010 Naveen Kumar G <naveen.gaddipati@stericsson.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _SYNAPTICS_DSX_H_
+#define _SYNAPTICS_DSX_H_
+
+/*
+ * struct synaptics_dsx_platform_data - contains the dsx platform data
+ * @x_flip: x flip flag
+ * @y_flip: y flip flag
+ * @regulator_en: regulator enable flag
+ * @irq_type: irq type
+ * @gpio: gpio pin assignment
+ * @gpio_config: callback for gpio set up
+ *
+ * This structure gives platform data for dsx.
+ */
+struct synaptics_dsx_platform_data {
+	bool x_flip;
+	bool y_flip;
+	bool regulator_en;
+	int irq_type;
+	unsigned gpio;
+	int (*gpio_config)(unsigned interrupt_gpio, bool configure);
+};
+
+#endif
-- 
1.7.5.4

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

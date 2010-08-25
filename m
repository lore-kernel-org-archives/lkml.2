Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab0HYJjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:39:03 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:37610 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663Ab0HYJi6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:38:58 -0400
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Aug 2010 05:38:54 EDT
From: Naveen Kumar GADDIPATI <naveen.gaddipati@stericsson.com>
To: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "dtor@mail.ru" <dtor@mail.ru>,
        "cheiny@synaptics.com" <cheiny@synaptics.com>,
        "axiong@synaptics.com" <axiong@synaptics.com>,
        "wmanson@synaptics.com" <wmanson@synaptics.com>,
        "j.de.gram@gmail.com" <j.de.gram@gmail.com>
Cc: "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Pradeepkumar Kumar SUJUAR <pradeep.kumar.sujuar@stericsson.com>,
        Sundar R IYER <sundar.iyer@stericsson.com>
Date: Wed, 25 Aug 2010 11:37:49 +0200
Subject: [RFC Patch 1/1] input:synaptics rmi4 touchpad driver support
Thread-Topic: [RFC Patch 1/1] input:synaptics rmi4 touchpad driver support
Thread-Index: ActEOJQ68A2zqX15TaWLTwbV2PN2xwAAC54g
Message-ID: <81C3A93C17462B4BBD7E272753C1057916DE5281BA@EXDCVYMBSTM005.EQ1STM.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: Dwct UPlT X+vY aF/o afBC glIl nqAR 6u5r 9Ot0 ABZ4LQ==
 AEKtqw== AEPXrQ== AETDGg== AGM3jg== AHLL/w==
 AIESZA==;9;YQB4AGkAbwBuAGcAQABzAHkAbgBhAHAAdABpAGMAcwAuAGMAbwBtADsAYwBoAGUAaQBuAHkAQABzAHkAbgBhAHAAdABpAGMAcwAuAGMAbwBtADsAZABtAGkAdAByAHkALgB0AG8AcgBvAGsAaABvAHYAQABnAG0AYQBpAGwALgBjAG8AbQA7AGQAdABvAHIAQABtAGEAaQBsAC4AcgB1ADsAagAuAGQAZQAuAGcAcgBhAG0AQABnAG0AYQBpAGwALgBjAG8AbQA7AGsAaABhAGwAaQBAAGwAaQBuAHUAeAAtAGYAcgAuAG8AcgBnADsAbABpAG4AdQB4AC0AaQBuAHAAdQB0AEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAdwBtAGEAbgBzAG8AbgBAAHMAeQBuAGEAcAB0AGkAYwBzAC4AYwBvAG0A;Sosha1_v1;7;{B3F72F80-5F36-47E2-B609-F15CC7209E69};bgBhAHYAZQBlAG4ALgBnAGEAZABkAGkAcABhAHQAaQBAAHMAdABlAHIAaQBjAHMAcwBvAG4ALgBjAG8AbQA=;Wed,
 25 Aug 2010 09:37:49
 GMT;WwBSAEYAQwAgAFAAYQB0AGMAaAAgADEALwAxAF0AIABpAG4AcAB1AHQAOgBzAHkAbgBhAHAAdABpAGMAcwAgAHIAbQBpADQAIAB0AG8AdQBjAGgAcABhAGQAIABkAHIAaQB2AGUAcgAgAHMAdQBwAHAAbwByAHQA
x-cr-puzzleid: {B3F72F80-5F36-47E2-B609-F15CC7209E69}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has been stripped from the RMI patch set posted at
http://kerneltrap.org/mailarchive/linux-kernel/2010/7/28/4598856/thread#mid-4598856.
This driver is posted as an RFC and not the part of the original RMI framework
that was posted earlier.

This patch contains the changes neccessary to make this work on the U8500 platform.

Signed-off-by: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>

---
 drivers/input/touchscreen/Kconfig                  |   10 +
 drivers/input/touchscreen/Makefile                 |    2 +
 drivers/input/touchscreen/synaptics_i2c_rmi4.c     |  951 ++++++++++++++++++++
 .../input/touchscreen/synaptics_rmi4_touchpad.c    |  492 ++++++++++
 include/linux/input/synaptics_i2c_rmi4.h           |  269 ++++++
 5 files changed, 1724 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/synaptics_i2c_rmi4.c
 create mode 100644 drivers/input/touchscreen/synaptics_rmi4_touchpad.c
 create mode 100644 include/linux/input/synaptics_i2c_rmi4.h

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index db54cb0..0df119b 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -615,4 +615,14 @@ config BU21013_TSC_CNTL2
        bool "Touch panel2 with BU21013 controller2"
        depends on TOUCHSCREEN_BU21013

+config TOUCHSCREEN_SYNAPTICS_I2C_RMI4
+       tristate "Synaptics i2c rmi4 touchscreen"
+       depends on I2C_NOMADIK
+       help
+         Say Y here if you have a Synaptics RMI4 and
+         want to enable support for the built-in touchscreen.
+
+         To compile this driver as a module, choose M here: the
+         module will be called synaptics_rmi4.
+
 endif
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 75c0465..acf945d 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -48,3 +48,5 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)    += mainstone-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)      += zylonite-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_W90X900)      += w90p910_ts.o
 obj-$(CONFIG_TOUCHSCREEN_BU21013)      += bu21013_ts.o
+synaptics_rmi4_ts-y := synaptics_i2c_rmi4.o synaptics_rmi4_touchpad.o
+obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4) += synaptics_rmi4_ts.o
diff --git a/drivers/input/touchscreen/synaptics_i2c_rmi4.c b/drivers/input/touchscreen/synaptics_i2c_rmi4.c
new file mode 100644
index 0000000..15c5585
--- /dev/null
+++ b/drivers/input/touchscreen/synaptics_i2c_rmi4.c
@@ -0,0 +1,951 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) I2C Physical Layer Driver.
+ * Copyright (c) 2007-2010, Synaptics Incorporated
+ *
+ * Author: Js HA <js.ha@stericsson.com> for ST-Ericsson
+ * Author: Naveen Kumar G <naveen.gaddipati@stericsson.com> for ST-Ericsson
+ * Copyright 2010 (c) ST-Ericsson AB
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+#include <linux/hrtimer.h>
+#include <linux/input.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/input/synaptics_i2c_rmi4.h>
+
+/* TODO: for multiple device support will need a per-device mutex */
+#define DRIVER_NAME "synaptics_rmi4_i2c"
+
+#define PDT_START_SCAN_LOCATION (0x00E9)
+#define PDT_END_SCAN_LOCATION  (0x000A)
+#define PDT_ENTRY_SIZE         (0x0006)
+#define MAX_ERROR_REPORT       6
+#define MAX_RETRY_COUNT                5
+#define READ_DELAY             10
+#define STD_QUERY_LEN          21
+#define PAGE_LEN               2
+#define TX_BUF_LEN             17
+
+static struct synaptics_rmi4_function_handler
+       fn_handler_table[RMI4_FUNCTION_HANDLER_TABLE_SIZE] = {
+       /* Fn $11 */
+       {
+               SYNAPTICS_RMI4_TOUCHPAD_FUNC_NUM,
+               synpatics_rmi4_touchpad_report,
+               synpatics_rmi4_touchpad_config,
+               synpatics_rmi4_touchpad_init,
+               synpatics_rmi4_touchpad_detect
+       },
+};
+
+/**
+ * synaptics_rmi4_find_fn_handler() - find the function handler for rmi4 device
+ * @fn_number: function number
+ *
+ * This function is here to provide a way for external modules to access the
+ * functions list.  It will try to find a matching function base on the passed
+ * in RMI4 function number and return  the pointer to the struct rmi4 function
+ * handler if a match is found or NULL if not found.
+ */
+static struct synaptics_rmi4_function_handler *synaptics_rmi4_find_fn_handler
+                                                               (int fn_number)
+{
+       int index;
+       bool found = false;
+
+       for (index = 0; index < RMI4_FUNCTION_HANDLER_TABLE_SIZE; index++) {
+               if (fn_number ==
+                   fn_handler_table[index].fn_number) {
+                       found = true;
+                       break;
+               }
+       }
+       if (!found)
+               return NULL;
+       return &(fn_handler_table[index]);
+}
+
+/**
+ * synaptics_rmi4_set_page() - sets the page
+ * @pdata: pointer to synaptics_rmi4_data structure
+ * @address:set the address of the page
+ *
+ * This function is used to set the page and returns integer.
+ */
+static int synaptics_rmi4_set_page(struct synaptics_rmi4_data *pdata,
+                                       unsigned int address)
+{
+       unsigned char   txbuf[PAGE_LEN];
+       int             retval;
+       unsigned int    page;
+       struct i2c_client *i2c = pdata->i2c_client;
+
+       page    = ((address >> 8) & MASK_8BIT);
+       if (page != pdata->current_page) {
+               txbuf[0]        = MASK_8BIT;
+               txbuf[1]        = page;
+               retval  = i2c_master_send(i2c, txbuf, PAGE_LEN);
+               if (retval != PAGE_LEN)
+                       dev_err(&i2c->dev, "%s:failed:%d\n", __func__, retval);
+               else
+                       pdata->current_page = page;
+       } else
+               retval = PAGE_LEN;
+       return retval;
+}
+/**
+ * synaptics_rmi4_i2c_byte_read() - read the single byte of data
+ * @pdata: pointer to synaptics_rmi4_data structure
+ * @address:read the data from this offset
+ * @data: pointer to hold the read data
+ *
+ * This function is to read the single byte of data and returns integer.
+ */
+static int synaptics_rmi4_i2c_byte_read(struct synaptics_rmi4_data *pdata,
+                                               unsigned short address,
+                                               unsigned char *valp)
+{
+       int     retval = 0;
+       int     retry_count = 0;
+       int     index;
+       struct i2c_client *i2c = pdata->i2c_client;
+
+       mutex_lock(&(pdata->rmi4_page_mutex));
+       retval = synaptics_rmi4_set_page(pdata, address);
+       if (retval != PAGE_LEN)
+               goto exit;
+       index = address & MASK_8BIT;
+retry:
+       retval = i2c_smbus_read_i2c_block_data(i2c, index, 1, valp);
+       if (retval != 1) {
+               if (++retry_count == MAX_RETRY_COUNT) {
+                       dev_err(&i2c->dev, "%s:offset 0x%04x failed:%d\n",
+                                               __func__, address, retval);
+                       goto exit;
+                } else {
+                       synaptics_rmi4_set_page(pdata, address);
+                       goto retry;
+               }
+       }
+exit:
+       mutex_unlock(&(pdata->rmi4_page_mutex));
+       return retval;
+}
+/**
+ * synaptics_rmi4_i2c_block_read() - read the block of data
+ * @pdata: pointer to synaptics_rmi4_data structure
+ * @address:read the block of data from this offset
+ * @valp: pointer to a buffer containing the data to be read
+ * @size: number of bytes to read
+ *
+ * This function is to read the block of data and returns integer.
+ */
+static int synaptics_rmi4_i2c_block_read(struct synaptics_rmi4_data *pdata,
+                                               unsigned short address,
+                                               unsigned char *valp, int size)
+{
+       int retval = 0;
+       int retry_count = 0;
+       int index;
+       struct i2c_client *i2c = pdata->i2c_client;
+
+       mutex_lock(&(pdata->rmi4_page_mutex));
+       retval = synaptics_rmi4_set_page(pdata, address);
+       if (retval != PAGE_LEN)
+               goto exit;
+       index = address & MASK_8BIT;
+retry:
+       retval = i2c_smbus_read_i2c_block_data(i2c, index, size, valp);
+       if (retval != size) {
+               if (++retry_count == MAX_RETRY_COUNT)
+                       dev_err(&i2c->dev,
+                               "%s:address 0x%04x size %d failed:%d\n",
+                                       __func__, address, size, retval);
+               else {
+                       synaptics_rmi4_set_page(pdata, address);
+                       goto retry;
+               }
+       }
+exit:
+       mutex_unlock(&(pdata->rmi4_page_mutex));
+       return retval;
+}
+
+/**
+ * synaptics_rmi4_i2c_byte_write() - write the single byte data
+ * @pdata: pointer to synaptics_rmi4_data structure
+ * @address:write the block of data from this offset
+ * @data: data to be write
+ *
+ * This function is to write the single byte data and returns integer.
+ */
+static int synaptics_rmi4_i2c_byte_write(struct synaptics_rmi4_data *pdata,
+                                               unsigned short address,
+                                               unsigned char data)
+{
+       unsigned char txbuf[2];
+       int retval = 0;
+       struct i2c_client *i2c = pdata->i2c_client;
+
+       /* Can't have anyone else changing the page behind our backs */
+       mutex_lock(&(pdata->rmi4_page_mutex));
+
+       retval = synaptics_rmi4_set_page(pdata, address);
+       if (retval != PAGE_LEN)
+               goto exit;
+       txbuf[0]        = address & MASK_8BIT;
+       txbuf[1]        = data;
+       retval          = i2c_master_send(pdata->i2c_client, txbuf, 2);
+       /* Add in retry on writes only in certian error return values */
+       if (retval != 2) {
+               dev_err(&i2c->dev, "%s:failed:%d\n", __func__, retval);
+               retval = -EIO;
+       } else
+               retval = 1;
+exit:
+       mutex_unlock(&(pdata->rmi4_page_mutex));
+       return retval;
+}
+/**
+ * synaptics_rmi4_i2c_block_write() - write the block of data
+ * @pdata: pointer to synaptics_rmi4_data structure
+ * @address:write the block of data from this offset
+ * @valp: pointer to a buffer containing the data to be written
+ * @size: number of bytes to write
+ *
+ * This function is to write the block of data and returns integer.
+ */
+static int synaptics_rmi4_i2c_block_write(struct synaptics_rmi4_data *pdata,
+                                               unsigned short address,
+                                               unsigned char *valp, int size)
+{
+       unsigned char *txbuf;
+       int retval = 0;
+       int i;
+       /*
+        * Use this buffer for fast writes of 16
+        * bytes or less.  The first byte will
+        * contain the address at which to start
+        * the write.
+        */
+       unsigned char txbuf_most[TX_BUF_LEN];
+       struct i2c_client *i2c = pdata->i2c_client;
+
+       if (size < sizeof(txbuf_most))
+               /* Avoid an allocation if we can help it */
+               txbuf = txbuf_most;
+       else {
+               /* over 16 bytes write we'll need to allocate a temp buffer */
+               txbuf = kmalloc(size + 1, GFP_KERNEL);
+               if (!txbuf) {
+                       dev_err(&i2c->dev, "no memory for tx buffer\n");
+                       return -ENOMEM;
+               }
+       }
+       /*
+        * It stinks here that we have to copy the buffer.
+        * We copy from valp to txbuf leaving
+        * the first location open for the address
+        */
+       for (i = 0; i < size; i++)
+               txbuf[i + 1] = valp[i];
+       /* Can't have anyone else changing the page behind our backs */
+       mutex_lock(&(pdata->rmi4_page_mutex));
+
+       retval = synaptics_rmi4_set_page(pdata, address);
+       if (retval != PAGE_LEN)
+               goto exit;
+       /* put the address in the first byte */
+       txbuf[0] = address & MASK_8BIT;
+       retval  = i2c_master_send(i2c, txbuf, size + 1);
+       /* add in retyr on writes only in certain error return values */
+       if (retval != (size + 1)) {
+               retval = -EIO;
+               dev_err(&i2c->dev, "%s:failed: %d\n", __func__, retval);
+               goto exit;
+       } else
+               retval = size;
+exit:
+       mutex_unlock(&(pdata->rmi4_page_mutex));
+       if (txbuf != txbuf_most)
+               kfree(txbuf);
+       return retval;
+}
+/**
+ * synaptics_rmi4_report_device() - reports the rmi4 device
+ * @pdata: pointer to synaptics_rmi4_data structure
+ * @rfi: pointer to synaptics_rmi4_fn
+ *
+ * This function is used to call the report function of the rmi4 device.
+ */
+static int synaptics_rmi4_report_device(struct synaptics_rmi4_data *pdata,
+                                       struct synaptics_rmi4_fn *rfi)
+{
+       bool found = false;
+       int touch = 0;
+       struct  i2c_client *client = pdata->i2c_client;
+       struct synaptics_rmi4_function_handler *hfn;
+       static int num_error_reports;
+       hfn = synaptics_rmi4_find_fn_handler(rfi->fn_number);
+       if (hfn) {
+               found = true;
+               if (hfn->pfunc_report)
+                       touch = hfn->pfunc_report(pdata, rfi);
+               else
+                       num_error_reports++;
+       }
+       if (!found) {
+               num_error_reports++;
+               if (num_error_reports < MAX_ERROR_REPORT)
+                       dev_err(&client->dev, "%s:report not supported\n",
+                                                               __func__);
+       }
+       return touch;
+}
+/**
+ * synaptics_rmi4_sensor_report() - reports to input subsystem
+ * @pdata: pointer to synaptics_rmi4_data structure
+ *
+ * This function is used to reads in all data sources and reports
+ * them to the input subsystem.
+ */
+static int synaptics_rmi4_sensor_report(struct synaptics_rmi4_data *pdata)
+{
+       unsigned char   intr_status[4];
+       /* number of touch points - fingers or buttons */
+       int touch = 0;
+       unsigned int retval;
+       struct synaptics_rmi4_fn                *rfi;
+       struct synaptics_rmi4_device_info       *rmi;
+       struct  i2c_client *client = pdata->i2c_client;
+
+       /*
+        * Get the interrupt status from the function $01
+        * control register+1 to find which source(s) were interrupting
+        * so we can read the data from the source(s) (2D sensor, buttons..)
+        */
+       retval = pdata->block_read(pdata, pdata->fn01_data_base_addr + 1,
+                                       intr_status,
+                                       pdata->number_of_interrupt_register);
+       if (retval != pdata->number_of_interrupt_register) {
+               dev_err(&client->dev,
+                               "could not read interrupt status registers\n");
+               return 0;
+       }
+       /*
+        * check each function that has data sources and if the interrupt for
+        * that triggered then call that RMI4 functions report() function to
+        * gather data and report it to the input subsystem
+        */
+       rmi = &(pdata->rmi4_mod_info);
+       list_for_each_entry(rfi, &rmi->support_fn_list, link) {
+               if (rfi->num_of_data_sources) {
+                       if (intr_status[rfi->index_to_intr_reg] &
+                                                       rfi->intr_mask)
+                               touch = synaptics_rmi4_report_device(pdata,
+                                                                       rfi);
+               }
+       }
+       /* return the number of touch points */
+       return touch;
+}
+
+/**
+ * synaptics_rmi4_work() - to schedule work and restart the timer
+ * @rmi4_work: pointer to work_struct structure
+ *
+ * This is the scheduled work for every restart of the timer
+ * during polling.
+ */
+static void synaptics_rmi4_work(struct work_struct *rmi4_work)
+{
+       struct synaptics_rmi4_data *pdata =
+               container_of(rmi4_work, struct synaptics_rmi4_data, work);
+       if (!(pdata->polling_required)) {
+               if (!pdata->touch_pressed)
+                       disable_irq(pdata->irq_number);
+               synaptics_rmi4_sensor_report(pdata);
+               if (pdata->touch_pressed)
+                       hrtimer_start(&pdata->timer,
+                       ktime_set(0, RMI4_TOUCH_POLLING_TIME_IN_PRESSED),
+                       HRTIMER_MODE_REL);
+               else
+                       enable_irq(pdata->irq_number);
+       } else {
+               synaptics_rmi4_sensor_report(pdata);
+               if (pdata->touch_pressed)
+                       hrtimer_start(&pdata->timer,
+                       ktime_set(0, RMI4_TOUCH_POLLING_TIME_IN_PRESSED),
+                       HRTIMER_MODE_REL);
+               else
+                       hrtimer_start(&pdata->timer,
+                       ktime_set(0, RMI4_TOUCH_POLLING_TIME_IN_IDLE),
+                       HRTIMER_MODE_REL);
+       }
+}
+
+/**
+ * synaptics_rmi4_poll_timer() - to schedule work and restart the timer
+ * @htimer: pointer to hrtimer structure
+ *
+ * This is the timer function for polling. It has to schedule work
+ * and restart the timer.
+ */
+static enum hrtimer_restart synaptics_rmi4_poll_timer(struct hrtimer *htimer)
+{
+       struct synaptics_rmi4_data *pdata =
+               container_of(htimer, struct synaptics_rmi4_data, timer);
+       schedule_work(&pdata->work);
+       return HRTIMER_NORESTART;
+}
+
+/**
+ * synaptics_rmi4_init_fn_handler() - initialize the rmi4 device
+ * @pdata: pointer to synaptics_rmi4_data structure
+ *
+ * This function calls init for all of the functions on the functions list and
+ * passes in the input_dev ptr so that each fn can store it for later use.
+ */
+static int synaptics_rmi4_init_fn_handler(struct synaptics_rmi4_data *pdata)
+{
+       int     index;
+       int     retval = 0;
+
+       for (index = 0; index < RMI4_FUNCTION_HANDLER_TABLE_SIZE; index++) {
+               if (fn_handler_table[index].pfunc_init)
+                       retval = fn_handler_table[index].pfunc_init(pdata);
+       }
+       return retval;
+}
+
+/**
+ * synaptics_rmi4_detect_device() - detect the rmi4 device
+ * @pdata: pointer to synaptics_rmi4_data structure
+ * @rfi: pointer to synaptics_rmi4_fn
+ * @rmi_fd: variable to synaptics_rmi4_fn_desc
+ * @count: count the number of interrupts
+ *
+ * This function is used to call the detect function of rmi4 device.
+ */
+static inline
+int synaptics_rmi4_detect_device(struct synaptics_rmi4_data *pdata,
+                                       struct synaptics_rmi4_fn *rfi,
+                                       struct synaptics_rmi4_fn_desc rmi_fd,
+                                       unsigned char count)
+{
+       int index;
+       /*
+        * Get the ptr to the detect function
+        * based on the function number
+        */
+       for (index = 0; index < RMI4_FUNCTION_HANDLER_TABLE_SIZE; index++) {
+               if (rmi_fd.fn_number == fn_handler_table[index].fn_number)
+                       fn_handler_table[index].pfunc_detect(pdata, rfi,
+                                                               &rmi_fd,
+                                                               count);
+       }
+       return 0;
+}
+
+/**
+ * synaptics_rmi4_i2c_query_device() - query the rmi4 device
+ * @pdata: pointer to synaptics_rmi4_data structure
+ *
+ * This function is used to query the rmi4 device.
+ */
+static int synaptics_rmi4_i2c_query_device(struct synaptics_rmi4_data *pdata)
+{
+       int i;
+       bool found = false;
+       int retval;
+       unsigned char std_queries[STD_QUERY_LEN];
+       unsigned char intr_count = 0;
+       int data_sources = 0;
+       unsigned int ctrl_offset;
+       struct synaptics_rmi4_fn *rfi;
+       struct synaptics_rmi4_fn_desc   rmi_fd;
+       struct synaptics_rmi4_function_handler *hfn;
+       struct synaptics_rmi4_device_info *rmi;
+       struct  i2c_client *client = pdata->i2c_client;
+
+       /*
+        * init the physical drivers RMI module
+        * info list of functions
+        */
+       INIT_LIST_HEAD(&pdata->rmi4_mod_info.support_fn_list);
+
+       /*
+        * Read the Page Descriptor Table to determine what functions
+        * are present
+        */
+       for (i = PDT_START_SCAN_LOCATION; i > PDT_END_SCAN_LOCATION;
+                                               i -= PDT_ENTRY_SIZE) {
+               retval = pdata->block_read(pdata, i,
+                               (unsigned char *)&rmi_fd, sizeof(rmi_fd));
+               if (retval == sizeof(rmi_fd)) {
+                       rfi = NULL;
+                       if (rmi_fd.fn_number) {
+                               switch (rmi_fd.fn_number & MASK_8BIT) {
+                               case SYNAPTICS_RMI4_DEVICE_CONTROL_FUNC_NUM:
+                                       pdata->fn01_query_base_addr =
+                                                       rmi_fd.query_base_addr;
+                                       pdata->fn01_ctrl_base_addr =
+                                                       rmi_fd.ctrl_base_addr;
+                                       pdata->fn01_data_base_addr =
+                                                       rmi_fd.data_base_addr;
+                                       break;
+
+                               default:
+                                       if (rmi_fd.intr_src_count) {
+                                               rfi = kmalloc(sizeof(*rfi),
+                                                               GFP_KERNEL);
+                                               if (!rfi) {
+                                                       dev_err(&client->dev,
+                                                       "%s:kmalloc failed\n",
+                                                               __func__);
+                                                       return -ENOMEM;
+                                               }
+                                               retval =
+                                               synaptics_rmi4_detect_device
+                                                               (pdata,
+                                                               rfi,
+                                                               rmi_fd,
+                                                               intr_count);
+                                               if (retval < 0)
+                                                       return retval;
+                                       }
+                                       break;
+                               }
+                               /* interrupt count for next iteration */
+                               intr_count += (rmi_fd.intr_src_count &
+                                                               MASK_3BIT);
+                               /*
+                                * We only want to add functions to the list
+                                * that have data associated with them.
+                                */
+                               if (rfi && rmi_fd.intr_src_count) {
+                                       /*
+                                        * link this function info to
+                                        * the RMI module infos
+                                        * list of functions
+                                        */
+                                       mutex_lock(&(pdata->fn_list_mutex));
+                                       list_add_tail(&rfi->link,
+                                       &pdata->rmi4_mod_info.support_fn_list);
+                                       mutex_unlock(&(pdata->fn_list_mutex));
+                               }
+                       } else {
+                               /*
+                                * A zero in the function number
+                                * signals the end of the PDT
+                                */
+                               dev_dbg(&client->dev,
+                                       "%s:Found End of PDT\n", __func__);
+                               break;
+                       }
+               } else {
+                       /* failed to read next PDT entry - end PDT
+                       scan - this may result in an incomplete set
+                       of recognized functions - should probably
+                       return an error but the driver may still be
+                       viable for diagnostics and debugging so let's
+                       let it continue. */
+                       dev_err(&client->dev, "%s: Read Error 0x%x\n",
+                                               __func__, retval);
+                       break;
+               }
+       }
+       /*
+        * calculate the interrupt register count - used in the
+        * ISR to read the correct number of interrupt registers
+        */
+       pdata->number_of_interrupt_register = (intr_count + 7) / 8;
+       /*
+        * Function $01 will be used to query the product properties,
+        * and product ID  so we had to read the PDT above first to get
+        * the Fn $01 query address and prior to filling in the product
+        * info. NOTE: Even an unflashed device will still have FN $01.
+        */
+
+       /* Load up the standard queries and get the RMI4 module info */
+       retval = pdata->block_read(pdata,
+                                       pdata->fn01_query_base_addr,
+                                       std_queries,
+                                       sizeof(std_queries));
+       if (retval != sizeof(std_queries)) {
+               dev_err(&client->dev, "%s:Failed reading queries\n",
+                                                       __func__);
+                return -EIO;
+       }
+
+       /* Currently supported RMI version is 4.0 */
+       pdata->rmi4_mod_info.version_major      = 4;
+       pdata->rmi4_mod_info.version_minor      = 0;
+       /*
+        * get manufacturer id, product_props, product info,
+        * date code, tester id, serial num and product id (name)
+        */
+       pdata->rmi4_mod_info.manufacturer_id    = std_queries[0];
+       pdata->rmi4_mod_info.product_props      = std_queries[1];
+       pdata->rmi4_mod_info.product_info[0]    = std_queries[2];
+       pdata->rmi4_mod_info.product_info[1]    = std_queries[3];
+       /* year - 2001-2032 */
+       pdata->rmi4_mod_info.date_code[0]       = std_queries[4] & MASK_5BIT;
+       /* month - 1-12 */
+       pdata->rmi4_mod_info.date_code[1]       = std_queries[5] & MASK_4BIT;
+       /* day - 1-31 */
+       pdata->rmi4_mod_info.date_code[2]       = std_queries[6] & MASK_5BIT;
+       pdata->rmi4_mod_info.tester_id = ((std_queries[7] & MASK_7BIT) << 8) |
+                                               (std_queries[8] & MASK_7BIT);
+       pdata->rmi4_mod_info.serial_number =
+               ((std_queries[9] & MASK_7BIT) << 8) |
+                               (std_queries[10] & MASK_7BIT);
+       memcpy(pdata->rmi4_mod_info.product_id_string, &std_queries[11], 10);
+
+       /* Check if this is a Synaptics device - report if not. */
+       if (pdata->rmi4_mod_info.manufacturer_id != 1)
+               dev_err(&client->dev, "%s: non-Synaptics mfg id:%d\n",
+                       __func__, pdata->rmi4_mod_info.manufacturer_id);
+       list_for_each_entry(rfi, &pdata->rmi4_mod_info.support_fn_list, link)
+               data_sources += rfi->num_of_data_sources;
+       if (data_sources) {
+               rmi = &(pdata->rmi4_mod_info);
+               list_for_each_entry(rfi, &rmi->support_fn_list, link) {
+                       if (rfi->num_of_data_sources) {
+                               /*
+                                * check if function number matches
+                                * if so call that config function
+                                */
+                               hfn =
+                               synaptics_rmi4_find_fn_handler(rfi->fn_number);
+                               if (hfn) {
+                                       found = true;
+                                       if (hfn->pfunc_config)
+                                               hfn->pfunc_config(pdata, rfi);
+                                       else
+                                               break;
+                               }
+                               if (!found)
+                                       dev_err(&client->dev,
+                                               "%s:fn_number not supported\n",
+                                                               __func__);
+                               /*
+                                * Turn on interrupts for this
+                                * function's data sources.
+                                */
+                               ctrl_offset = pdata->fn01_ctrl_base_addr + 1 +
+                                                       rfi->index_to_intr_reg;
+                               retval = pdata->byte_write(pdata, ctrl_offset,
+                                                       rfi->intr_mask);
+                               if (retval < 0)
+                                       return retval;
+                       }
+               }
+       } else
+               pdata->polling_required = false;
+       return 0;
+}
+
+/**
+ * synaptics_rmi4_irq_callback() - callback handler for attention line
+ * @irq: irq value
+ * @info:void pointer
+ *
+ * This function is interrupt callback handler. It just notifies the
+ * application layer that attention is required.
+ */
+static irqreturn_t synaptics_rmi4_irq_callback(int irq, void *info)
+{
+       struct synaptics_rmi4_data *pdata =
+                       (struct synaptics_rmi4_data *)info;
+       schedule_work(&(pdata->work));
+       return IRQ_HANDLED;
+}
+/**
+ * synaptics_rmi4_probe() - Initialze the i2c-client touchscreen driver
+ * @i2c: i2c client structure pointer
+ * @id:i2c device id pointer
+ *
+ * This function will allocate and initialize the instance
+ * data and request the irq and set the instance data as the clients
+ * platform data then register the physical driver which will do a scan of
+ * the rmi4 Physical Device Table and enumerate any rmi4 functions that
+ * have data sources associated with them.
+ */
+static int synaptics_rmi4_probe
+       (struct i2c_client *client, const struct i2c_device_id *dev_id)
+{
+       struct synaptics_rmi4_data *prmi4_data;
+       struct synaptics_rmi4_i2c_data *rmii2cdata;
+       struct synaptics_rmi4_platform_data *platformdata = NULL;
+       int retval;
+       int i;
+       bool found = false;
+
+       /* Allocate and initialize the instance data for this client */
+       prmi4_data = kzalloc(sizeof(struct synaptics_rmi4_data) * 2,
+                                                       GFP_KERNEL);
+       if (!prmi4_data) {
+               dev_err(&client->dev, "%s: no memory allocated\n", __func__);
+               return -ENOMEM;
+       }
+       prmi4_data->input_dev = input_allocate_device();
+       if (prmi4_data->input_dev == NULL) {
+               dev_err(&client->dev, "%s:input device alloc failed\n",
+                                               __func__);
+               retval = -ENOMEM;
+               goto err_input;
+       }
+       mutex_init(&(prmi4_data->fn_list_mutex));
+       mutex_init(&(prmi4_data->rmi4_page_mutex));
+       /* Initialize the platform i2c data */
+       rmii2cdata = ((struct synaptics_rmi4_i2c_data *)
+                                       (client->dev.platform_data));
+       /*
+        * Loop through the platform data and locate the one that matches
+        * the i2c_client I2C address
+        */
+       for (i = 0; i < rmii2cdata->num_clients; i++) {
+               platformdata = &(rmii2cdata->platformdata[i]);
+               prmi4_data->instance_number = i;
+               found = true;
+               /*
+                * set the device name using the instance_no appended
+                * to DRIVER_NAME to make a unique name
+                */
+               dev_set_name(&client->dev, "synaptics_rmi4_i2c%d\n",
+                               prmi4_data->instance_number);
+               /*
+                * Determine if we need to poll (inefficient) or
+                * use interrupts.
+                */
+               prmi4_data->irq_number = platformdata->irq_number;
+               if (platformdata->irq_number)
+                       prmi4_data->polling_required = false;
+               else
+                       prmi4_data->polling_required = true;
+       }
+       /*
+        * if went through all the platform data list and didn't find a match
+        * then notify that we are defaulting to polling
+        */
+       if (!found)
+               dev_err(&client->dev, "%s: No platform data match found\n",
+                                                               __func__);
+       /* Store the instance data in the i2c_client - we need to do this prior
+        * to calling register_physical_driver since it may use the read, write
+        * functions. If nothing was found then the id fields will be set to 0
+        * for the irq and the default  will be set to polling required so we
+        * will still work but in polling mode.
+        */
+       i2c_set_clientdata(client, prmi4_data);
+       /*
+        * Copy i2c_client pointer into RTID's i2c_client pointer for
+        * later use in rmi4_read, rmi4_write, etc.
+       */
+       prmi4_data->i2c_client = client;
+       /* So we set the page correctly the first time */
+       prmi4_data->current_page        = MASK_16BIT;
+       prmi4_data->touch_pressed       = 0;
+       prmi4_data->x_max_res           = platformdata->x_max_res;
+       prmi4_data->y_max_res           = platformdata->y_max_res;
+       prmi4_data->portrait_mode       = platformdata->portrait_mode;
+       prmi4_data->x_flip              = platformdata->x_flip;
+       prmi4_data->y_flip              = platformdata->y_flip;
+       prmi4_data->byte_read           = synaptics_rmi4_i2c_byte_read;
+       prmi4_data->byte_write          = synaptics_rmi4_i2c_byte_write;
+       prmi4_data->block_read          = synaptics_rmi4_i2c_block_read;
+       prmi4_data->block_write         = synaptics_rmi4_i2c_block_write;
+       /* Initialize the function handlers for rmi4*/
+       retval = synaptics_rmi4_init_fn_handler(prmi4_data);
+       if (retval) {
+               dev_err(&client->dev, "%s:rmi4 init Failed\n", __func__);
+               goto err_init;
+       }
+       /*initialize the input device parameters */
+       prmi4_data->input_dev->name = DRIVER_NAME;
+       prmi4_data->input_dev->phys = "Synaptics_Clearpad";
+       retval = input_register_device(prmi4_data->input_dev);
+       if (retval) {
+               dev_err(&client->dev, "%s:input register failed\n", __func__);
+               goto err_init;
+       }
+       /*
+        * Register physical driver - this will call the detect function that
+        * will then scan the device and determine the supported
+        * rmi4 functions.
+        */
+       retval = synaptics_rmi4_i2c_query_device(prmi4_data);
+       if (retval) {
+               dev_err(&client->dev, "%s: rmi4 query device failed\n",
+                                                       __func__);
+               goto err_query_dev;
+       }
+       INIT_WORK(&(prmi4_data->work), synaptics_rmi4_work);
+       hrtimer_init(&(prmi4_data->timer), CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+       prmi4_data->timer.function = synaptics_rmi4_poll_timer;
+       if (prmi4_data->irq_number) {
+               retval = request_irq(prmi4_data->irq_number,
+                                       synaptics_rmi4_irq_callback,
+                                       prmi4_data->irq_type,
+                                       DRIVER_NAME, prmi4_data);
+               if (retval) {
+                       dev_err(&client->dev, "%s:Unable to get attn irq %d\n",
+                                       __func__, prmi4_data->irq_number);
+                       free_irq(prmi4_data->irq_number, prmi4_data);
+                       prmi4_data->polling_required = true;
+               }
+       }
+       /*
+        * if we need to set up the polling callback and
+        * worker thread.
+        */
+       if (prmi4_data->polling_required) {
+               /* So set up the polling timer and timer function.*/
+               dev_dbg(&client->dev, "%s: start pollling\n", __func__);
+               hrtimer_start(&(prmi4_data->timer), ktime_set(1, 0),
+                                                       HRTIMER_MODE_REL);
+       }
+       dev_dbg(&client->dev, "%s: done\n", __func__);
+       return retval;
+err_query_dev:
+       i2c_set_clientdata(client, NULL);
+       input_unregister_device(prmi4_data->input_dev);
+err_init:
+       input_free_device(prmi4_data->input_dev);
+       prmi4_data->input_dev = NULL;
+err_input:
+       kfree(prmi4_data);
+       return retval;
+}
+/**
+ * synaptics_rmi4_remove() - Removes the i2c-client touchscreen driver
+ * @client: i2c client structure pointer
+ *
+ * This funtion uses to remove the i2c-client
+ * touchscreen driver and returns integer.
+ */
+static int synaptics_rmi4_remove(struct i2c_client *client)
+{
+       struct synaptics_rmi4_data *pdata = i2c_get_clientdata(client);
+       /* Stop the polling timer */
+       hrtimer_cancel(&(pdata->timer));
+       if (pdata->irq_number)
+               free_irq(pdata->irq_number, pdata);
+       /* Make sure all scheduled work is stopped */
+       flush_scheduled_work();
+       /* Unregister everything */
+       input_unregister_device(pdata->input_dev);
+       kfree(pdata);
+       return 0;
+}
+
+#ifdef CONFIG_PM
+/**
+ * synaptics_rmi4_suspend() - suspend the touch screen controller
+ * @client: pointer to i2c client structure
+ * @mesg: message from power manager
+ *
+ * This funtion is used to suspend the
+ * touch panel controller and returns integer
+ */
+static int synaptics_rmi4_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+       /* Touch sleep mode */
+       struct synaptics_rmi4_data *pdata = i2c_get_clientdata(client);
+       if (!pdata->polling_required)
+               disable_irq(pdata->irq_number);
+       else
+               hrtimer_cancel(&pdata->timer);
+       synaptics_rmi4_i2c_byte_write(pdata,
+                               pdata->fn01_ctrl_base_addr + 1, 0x0);
+       return 0;
+}
+/**
+ * synaptics_rmi4_resume() - resume the touch screen controller
+ * @client: pointer to i2c client structure
+ *
+ * This funtion is used to resume the touch panel
+ * controller and returns integer.
+ */
+static int synaptics_rmi4_resume(struct i2c_client *client)
+{
+       struct synaptics_rmi4_data *pdata = i2c_get_clientdata(client);
+       if (!pdata->polling_required) {
+               enable_irq(pdata->irq_number);
+               synaptics_rmi4_i2c_byte_write(pdata,
+                       pdata->fn01_ctrl_base_addr + 1, 0x8);
+       } else
+               hrtimer_start(&pdata->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
+       return 0;
+}
+#endif
+
+static const struct i2c_device_id synaptics_rmi4_id_table[] = {
+       { DRIVER_NAME, 0 },
+       { },
+};
+MODULE_DEVICE_TABLE(i2c, synaptics_rmi4_id_table);
+
+static struct i2c_driver synaptics_rmi4_driver = {
+       .driver = {
+               .name  = DRIVER_NAME,
+               .owner = THIS_MODULE,
+       },
+       .probe          = synaptics_rmi4_probe,
+       .remove         = synaptics_rmi4_remove,
+#ifdef CONFIG_PM
+       .suspend        = synaptics_rmi4_suspend,
+       .resume         = synaptics_rmi4_resume,
+#endif
+       .id_table       = synaptics_rmi4_id_table,
+};
+/**
+ * synaptics_rmi4_init() - Initialize the touchscreen driver
+ *
+ * This funtion uses to initializes the synaptics
+ * touchscreen driver and returns integer.
+ */
+static int __init synaptics_rmi4_init(void)
+{
+       return i2c_add_driver(&synaptics_rmi4_driver);
+}
+/**
+ * synaptics_rmi4_exit() - De-initialize the touchscreen driver
+ *
+ * This funtion uses to de-initialize the synaptics
+ * touchscreen driver and returns none.
+ */
+static void __exit synaptics_rmi4_exit(void)
+{
+       i2c_del_driver(&synaptics_rmi4_driver);
+}
+
+
+module_init(synaptics_rmi4_init);
+module_exit(synaptics_rmi4_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("naveen.gaddipati@stericsson.com, js.ha@stericsson.com");
+MODULE_DESCRIPTION("synaptics rmi4 i2c touch Driver");
+MODULE_ALIAS("i2c:synaptics_rmi4_ts");
diff --git a/drivers/input/touchscreen/synaptics_rmi4_touchpad.c b/drivers/input/touchscreen/synaptics_rmi4_touchpad.c
new file mode 100644
index 0000000..074dc4b
--- /dev/null
+++ b/drivers/input/touchscreen/synaptics_rmi4_touchpad.c
@@ -0,0 +1,492 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) I2C Physical Layer Driver.
+ * Copyright (c) 2007-2010, Synaptics Incorporated
+ *
+ * Author: Js HA <js.ha@stericsson.com> for ST-Ericsson
+ * Author: Naveen Kumar G <naveen.gaddipati@stericsson.com> for ST-Ericsson
+ * Copyright 2010 (c) ST-Ericsson AB
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/input.h>
+#include <linux/input/synaptics_i2c_rmi4.h>
+
+#define SCALE_FACTOR   1000
+#define DATA_BUF_LEN   32
+#define BUF_LEN                37
+#define QUERY_LEN      9
+#define DATA_LEN       12
+#define HAS_TAP                0x01
+#define HAS_PALMDETECT 0x01
+#define HAS_ROTATE     0x02
+#define HAS_TAPANDHOLD 0x02
+#define HAS_DOUBLETAP  0x04
+#define HAS_EARLYTAP   0x08
+#define HAS_RELEASE    0x08
+#define HAS_FLICK      0x10
+#define HAS_PRESS      0x20
+#define HAS_PINCH      0x40
+
+/**
+ * synpatics_rmi4_touchpad_report_up() - reports the finger up state
+ * @pdata: pointer to synaptics_rmi4_data structure
+ *
+ * This function calls to reports the finger up for the input subsystem
+ */
+static void synpatics_rmi4_touchpad_report_up(struct synaptics_rmi4_data *pdata)
+{
+       if (pdata->touch_pressed) {
+               input_report_abs(pdata->input_dev, ABS_PRESSURE, 0);
+               input_report_abs(pdata->input_dev, ABS_TOOL_WIDTH, 0);
+               input_report_key(pdata->input_dev, BTN_TOUCH, 0);
+               input_report_key(pdata->input_dev, BTN_2, 0);
+               input_report_abs(pdata->input_dev, ABS_MT_TOUCH_MAJOR, 0);
+               input_report_key(pdata->input_dev, ABS_MT_WIDTH_MAJOR, 0);
+               input_mt_sync(pdata->input_dev);
+               pdata->touch_pressed = 0;
+       }
+}
+/**
+ * synpatics_rmi4_touchpad_report_down() - reports the finger down state
+ * @pdata: pointer to synaptics_rmi4_data structure
+ * @count: finger down count
+ *
+ * This function calls to reports the finger down for the input subsystem
+ */
+static
+void synpatics_rmi4_touchpad_report_down(struct synaptics_rmi4_data *pdata,
+                                               int count)
+{
+       int x[2];
+       int y[2];
+       int finger;
+       for (finger = 0; finger < 2; finger++) {
+               if (pdata->portrait_mode) {
+                       x[finger] =  pdata->x[finger];
+                       y[finger] =  pdata->y[finger];
+               } else {
+                       x[finger] =  pdata->y[finger];
+                       y[finger] =  pdata->x[finger];
+               }
+       }
+       input_report_abs(pdata->input_dev, ABS_X, x[0]);
+       input_report_abs(pdata->input_dev, ABS_Y, y[0]);
+       input_report_abs(pdata->input_dev, ABS_PRESSURE, 1);
+       input_report_abs(pdata->input_dev, ABS_TOOL_WIDTH, 1);
+       input_report_key(pdata->input_dev, BTN_TOUCH, 1);
+       if (count > 1) {
+               input_report_key(pdata->input_dev, BTN_2, 1);
+               input_report_abs(pdata->input_dev, ABS_HAT0X, x[1]);
+               input_report_abs(pdata->input_dev, ABS_HAT0Y, y[1]);
+       }
+       input_report_abs(pdata->input_dev, ABS_MT_TOUCH_MAJOR, 1);
+       input_report_abs(pdata->input_dev, ABS_MT_TOUCH_MINOR, 1);
+       input_report_abs(pdata->input_dev, ABS_MT_POSITION_X, x[0]);
+       input_report_abs(pdata->input_dev, ABS_MT_POSITION_Y, y[0]);
+       input_mt_sync(pdata->input_dev);
+       if (count > 1) {
+               input_report_abs(pdata->input_dev, ABS_MT_TOUCH_MAJOR, 1);
+               input_report_abs(pdata->input_dev, ABS_MT_TOUCH_MINOR, 1);
+               input_report_abs(pdata->input_dev, ABS_MT_POSITION_X, x[1]);
+               input_report_abs(pdata->input_dev, ABS_MT_POSITION_Y, y[1]);
+               input_mt_sync(pdata->input_dev);
+       }
+       pdata->touch_pressed = count;
+}
+/**
+ * synpatics_rmi4_touchpad_calc() - calculates the co-ordinates
+ * @pdata: pointer to synaptics_rmi4_data structure
+ * @count: finger down count
+ *
+ * This function calls to calculates the co-ordinates
+ */
+static
+void synpatics_rmi4_touchpad_calc(struct synaptics_rmi4_data *pdata, int count)
+{
+       pdata->x[count] =
+               pdata->x[count] * pdata->factor_x / SCALE_FACTOR;
+       pdata->y[count] =
+               pdata->y[count] * pdata->factor_y / SCALE_FACTOR;
+       pdata->wx[count] =
+               pdata->wx[count] * pdata->factor_x / SCALE_FACTOR + 1;
+       pdata->wy[count] =
+               pdata->wy[count] * pdata->factor_y / SCALE_FACTOR + 1;
+       if (pdata->x[count] < 0)
+               pdata->x[count] = 0;
+       else if (pdata->x[count] >= pdata->x_max_res)
+               pdata->x[count] = pdata->x_max_res - 1;
+       if (pdata->y[count] < 0)
+               pdata->y[count] = 0;
+       else if (pdata->y[count] >= pdata->y_max_res)
+               pdata->y[count] = pdata->y_max_res - 1;
+       if (pdata->portrait_mode && pdata->x_flip)
+               pdata->x[count] = pdata->x_max_res - pdata->x[count];
+       if (pdata->portrait_mode && pdata->y_flip)
+               pdata->y[count] = pdata->y_max_res - pdata->y[count];
+}
+/**
+ * synpatics_rmi4_touchpad_report() - reports for the rmi4 touchpad device
+ * @pdata: pointer to synaptics_rmi4_data structure
+ * @rfi: pointer to synaptics_rmi4_fn structure
+ *
+ * This function calls to reports for the rmi4 touchpad device
+ */
+int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
+                                               struct synaptics_rmi4_fn *rfi)
+{
+       /* number of touch points - fingers down in this case */
+       int     touch_count = 0;
+       int     finger;
+       int     fingers_supported;
+       int     finger_registers;
+       int     reg;
+       int     finger_shift;
+       int     finger_status;
+       unsigned short  data_base_addr;
+       unsigned short  data_offset;
+       unsigned char   data_reg_blk_size;
+       unsigned char   values[2];
+       unsigned char   data[DATA_LEN];
+       int retval;
+
+       /* get 2D sensor finger data */
+       /*
+        * First get the finger status field - the size of the finger status
+        * field is determined by the number of finger supporte - 2 bits per
+        * finger, so the number of registers to read is:
+        * registerCount = ceil(numberOfFingers/4).
+        * Read the required number of registers and check each 2 bit field to
+        * determine if a finger is down:
+        *      00 = finger not present,
+        *      01 = finger present and data accurate,
+        *      10 = finger present but data may not be accurate,
+        *      11 = reserved for product use.
+        */
+       fingers_supported       = rfi->num_of_data_points;
+       finger_registers        = (fingers_supported + 3)/4;
+       data_base_addr          = rfi->fn_desc.data_base_addr;
+       retval = pdata->block_read(pdata, data_base_addr, values,
+                                                       finger_registers);
+       if (retval != finger_registers) {
+               printk(KERN_ERR "%s:read status registers failed\n", __func__);
+               return 0;
+       }
+       /*
+        * For each finger present, read the proper number of registers
+        * to get absolute data.
+        */
+       data_reg_blk_size = rfi->size_of_data_register_block;
+       for (finger = 0; finger < fingers_supported; finger++) {
+               /* determine which data byte the finger status is in */
+               reg = finger/4;
+               /* bit shift to get finger's status */
+               finger_shift    = (finger % 4) * 2;
+               finger_status   = (values[reg] >> finger_shift) & 3;
+               /*
+                * if finger status indicates a finger is present then
+                * read the finger data and report it
+                */
+               if (finger_status == 1 || finger_status == 2) {
+                       /* Read the finger data */
+                       data_offset = data_base_addr +
+                                       ((finger * data_reg_blk_size) +
+                                       finger_registers);
+                       retval = pdata->block_read(pdata, data_offset, data,
+                                               data_reg_blk_size);
+                       if (retval != data_reg_blk_size) {
+                               printk(KERN_ERR "%s:read data failed\n",
+                                                               __func__);
+                               return 0;
+                       } else {
+                               pdata->x[touch_count]   =
+                                       (data[0] << 4) | (data[2] & MASK_4BIT);
+                               pdata->y[touch_count]   =
+                                       (data[1] << 4) |
+                                       ((data[2] >> 4) & MASK_4BIT);
+                               pdata->z[touch_count]   = (data[4]);
+                               pdata->wy[touch_count]  =
+                                               (data[3] >> 4) & MASK_4BIT;
+                               pdata->wx[touch_count]  =
+                                               (data[3] & MASK_4BIT);
+                               synpatics_rmi4_touchpad_calc(pdata,
+                                                               touch_count);
+                       }
+                       /* number of active touch points */
+                       touch_count++;
+               }
+       }
+       if (touch_count > 0)
+               synpatics_rmi4_touchpad_report_down(pdata, touch_count);
+       else
+               synpatics_rmi4_touchpad_report_up(pdata);
+       /* sync after groups of events */
+       input_sync(pdata->input_dev);
+       /* return the number of touch points */
+       return touch_count;
+}
+EXPORT_SYMBOL_GPL(synpatics_rmi4_touchpad_report);
+
+/**
+ * synpatics_rmi4_touchpad_config() - confiures the rmi4 touchpad device
+ * @pdata: pointer to synaptics_rmi4_data structure
+ * @rfi: pointer to synaptics_rmi4_fn structure
+ *
+ * This function calls to confiures the rmi4 touchpad device
+ */
+int synpatics_rmi4_touchpad_config(struct synaptics_rmi4_data *pdata,
+                                               struct synaptics_rmi4_fn *rfi)
+{
+       /*
+        * For the data source - print info and do any
+        * source specific configuration.
+        */
+       unsigned char data[BUF_LEN];
+       int retval = 0;
+       /* Get and print some info about the data source... */
+       /* To Query 2D devices we need to read from the address obtained
+        * from the function descriptor stored in the RMI function info.
+        */
+       retval = pdata->block_read(pdata, rfi->fn_desc.query_base_addr,
+                                                       data, QUERY_LEN);
+       if (retval != QUERY_LEN)
+               printk(KERN_ERR "%s:read query registers failed\n", __func__);
+       else {
+               retval = pdata->block_read(pdata,
+                                       rfi->fn_desc.ctrl_base_addr,
+                                       data, DATA_BUF_LEN);
+               if (retval != DATA_BUF_LEN) {
+                       printk(KERN_ERR "%s:read control registers failed\n",
+                                                               __func__);
+                       return retval;
+               }
+               /* Store these for use later*/
+               pdata->sensor_max_x = ((data[6] & MASK_8BIT) << 0) |
+                                               ((data[7] & MASK_4BIT) << 8);
+               pdata->sensor_max_y = ((data[8] & MASK_5BIT) << 0) |
+                                               ((data[9] & MASK_4BIT) << 8);
+               pdata->factor_x = (pdata->x_max_res * SCALE_FACTOR /
+                                               pdata->sensor_max_x);
+               pdata->factor_y = (pdata->y_max_res * SCALE_FACTOR /
+                                               pdata->sensor_max_y);
+       }
+       return retval;
+}
+EXPORT_SYMBOL_GPL(synpatics_rmi4_touchpad_config);
+
+/**
+ * synpatics_rmi4_touchpad_init() - initialize the rmi4 touchpad device
+ * @pdata: pointer to synaptics_rmi4_data structure
+ *
+ * This function initialize any function $11 specific params and settings
+ * to input subsysten.
+ */
+int synpatics_rmi4_touchpad_init(struct synaptics_rmi4_data *pdata)
+{
+       int x_max;
+       int y_max;
+
+       if (pdata->portrait_mode) {
+               x_max = pdata->x_max_res;
+               y_max = pdata->y_max_res;
+       } else {
+               x_max = pdata->y_max_res;
+               y_max = pdata->x_max_res;
+       }
+       set_bit(EV_SYN, pdata->input_dev->evbit);
+       set_bit(EV_KEY, pdata->input_dev->evbit);
+       set_bit(EV_ABS, pdata->input_dev->evbit);
+       set_bit(BTN_TOUCH, pdata->input_dev->keybit);
+
+       input_set_abs_params(pdata->input_dev, ABS_X, 0, x_max, 0, 0);
+       input_set_abs_params(pdata->input_dev, ABS_Y, 0, y_max, 0, 0);
+       input_set_abs_params(pdata->input_dev, ABS_PRESSURE, 0,
+                                       RMI4_TOUCH_MAX_PRESSURE, 0, 0);
+       input_set_abs_params(pdata->input_dev, ABS_TOOL_WIDTH, 0,
+                                       RMI4_TOUCH_MAX_TOOL_WIDTH, 0, 0);
+       set_bit(BTN_2, pdata->input_dev->keybit);
+       input_set_abs_params(pdata->input_dev, ABS_HAT0X, 0, x_max, 0, 0);
+       input_set_abs_params(pdata->input_dev, ABS_HAT0Y, 0, y_max, 0, 0);
+       input_set_abs_params(pdata->input_dev, ABS_MT_POSITION_X, 0, x_max,
+                                                               0, 0);
+       input_set_abs_params(pdata->input_dev, ABS_MT_POSITION_Y, 0, y_max,
+                                                               0, 0);
+       input_set_abs_params(pdata->input_dev, ABS_MT_TOUCH_MAJOR, 0,
+                                               RMI4_TOUCH_MAX_TOOL_WIDTH,
+                                               0, 0);
+       input_set_abs_params(pdata->input_dev, ABS_MT_TOUCH_MINOR, 0,
+                                               RMI4_TOUCH_MAX_TOOL_WIDTH,
+                                               0, 0);
+       input_set_abs_params(pdata->input_dev, ABS_MT_ORIENTATION, 0, 1, 0, 0);
+       input_set_abs_params(pdata->input_dev, ABS_MT_WIDTH_MAJOR, 0,
+                                               RMI4_TOUCH_MAX_TOOL_WIDTH,
+                                               0, 0);
+       return 0;
+}
+EXPORT_SYMBOL_GPL(synpatics_rmi4_touchpad_init);
+
+/**
+ * synpatics_rmi4_touchpad_detect() - detects the rmi4 touchpad device
+ * @pdata: pointer to synaptics_rmi4_data structure
+ * @rfi: pointer to synaptics_rmi4_fn structure
+ * @fd: pointer to synaptics_rmi4_fn_desc structure
+ * @interruptcount: count the number of interrupts
+ *
+ * This function calls to detects the rmi4 touchpad device
+ */
+int synpatics_rmi4_touchpad_detect(struct synaptics_rmi4_data *pdata,
+                                       struct synaptics_rmi4_fn *rfi,
+                                       struct synaptics_rmi4_fn_desc *fd,
+                                       unsigned int interruptcount)
+{
+       unsigned char   queries[QUERY_LEN];
+       unsigned short  intr_offset;
+       unsigned char   abs_data_size;
+       unsigned char   abs_data_blk_size;
+       unsigned char   egr_0, egr_1;
+       unsigned int    all_data_blk_size;
+       int     has_pinch, has_flick, has_tap;
+       int     has_tapandhold, has_doubletap;
+       int     has_earlytap, has_press;
+       int     has_palmdetect, has_rotate;
+       int     has_rel;
+       int     i;
+       int     retval;
+
+       rfi->fn_desc.query_base_addr    = fd->query_base_addr;
+       rfi->fn_desc.data_base_addr     = fd->data_base_addr;
+       rfi->fn_desc.intr_src_count     = fd->intr_src_count;
+       rfi->fn_desc.fn_number          = fd->fn_number;
+       rfi->fn_number                  = fd->fn_number;
+       rfi->num_of_data_sources        = fd->intr_src_count;
+       rfi->fn_desc.ctrl_base_addr     = fd->ctrl_base_addr;
+       rfi->fn_desc.cmd_base_addr      = fd->cmd_base_addr;
+       /*
+        * need to get number of fingers supported, data size, etc.
+        * to be used when getting data since the number of registers to
+        * read depends on the number of fingers supported and data size.
+        */
+       retval = pdata->block_read(pdata, fd->query_base_addr, queries,
+                                                       sizeof(queries));
+       if (retval != sizeof(queries)) {
+               printk(KERN_ERR "%s:read function query registers\n",
+                                                       __func__);
+               return retval;
+       }
+       /*
+        * 2D data sources have only 3 bits for the number of fingers
+        * supported - so the encoding is a bit wierd.
+        */
+       /* default number of fingers supported */
+       rfi->num_of_data_points = 2;
+       if ((queries[1] & MASK_3BIT) <= 4)
+               /* add 1 since zero based */
+               rfi->num_of_data_points = (queries[1] & MASK_3BIT) + 1;
+       else {
+               /*
+                * a value of 5 is up to 10 fingers - 6 and 7 are reserved
+                * (shouldn't get these i int retval;n a normal 2D source).
+                */
+               if ((queries[1] & MASK_3BIT) == 5)
+                       rfi->num_of_data_points = 10;
+       }
+       /* Need to get interrupt info for handling interrupts */
+       rfi->index_to_intr_reg = (interruptcount + 7)/8;
+       if (rfi->index_to_intr_reg != 0)
+               rfi->index_to_intr_reg -= 1;
+       /*
+        * loop through interrupts for each source in fn $11
+        * and or in a bit to the interrupt mask for each.
+        */
+       intr_offset = interruptcount % 8;
+       rfi->intr_mask = 0;
+       for (i = intr_offset;
+               i < ((fd->intr_src_count & MASK_3BIT) + intr_offset); i++)
+               rfi->intr_mask |= 1 << i;
+
+       /* Size of just the absolute data for one finger */
+       abs_data_size   = queries[5] & MASK_2BIT;
+       /* One each for X and Y, one for LSB for X & Y, one for W, one for Z */
+       abs_data_blk_size = 3 + (2 * (abs_data_size == 0 ? 1 : 0));
+       rfi->size_of_data_register_block = abs_data_blk_size;
+
+       /*
+        * need to determine the size of data to read - this depends on
+        * conditions such as whether Relative data is reported and if Gesture
+        * data is reported.
+        */
+       egr_0 = queries[7];
+       egr_1 = queries[8];
+
+       /*
+        * Get info about what EGR data is supported, whether it has
+        * Relative data supported, etc.
+        */
+       has_pinch       = egr_0 & HAS_PINCH;
+       has_flick       = egr_0 & HAS_FLICK;
+       has_tap         = egr_0 & HAS_TAP;
+       has_earlytap    = egr_0 & HAS_EARLYTAP;
+       has_press       = egr_0 & HAS_PRESS;
+       has_rotate      = egr_1 & HAS_ROTATE;
+       has_rel         = queries[1] & HAS_RELEASE;
+       has_tapandhold  = egr_0 & HAS_TAPANDHOLD;
+       has_doubletap   = egr_0 & HAS_DOUBLETAP;
+       has_palmdetect  = egr_1 & HAS_PALMDETECT;
+
+       /*
+        * Size of all data including finger status, absolute data for each
+        * finger, relative data and EGR data
+        */
+       all_data_blk_size =
+               /* finger status, four fingers per register */
+               ((rfi->num_of_data_points + 3) / 4) +
+               /* absolute data, per finger times number of fingers */
+               (abs_data_blk_size * rfi->num_of_data_points) +
+               /*
+                * two relative registers (if relative is being reported)
+                */
+               2 * has_rel +
+               /*
+                * F11_2D_data8 is only present if the egr_0
+                * register is non-zero.
+                */
+               !!(egr_0) +
+               /*
+                * F11_2D_data9 is only present if either egr_0 or
+                * egr_1 registers are non-zero.
+                */
+               (egr_0 || egr_1) +
+               /*
+                * F11_2D_data10 is only present if EGR_PINCH or EGR_FLICK of
+                * egr_0 reports as 1.
+                */
+               !!(has_pinch | has_flick) +
+               /*
+                * F11_2D_data11 and F11_2D_data12 are only present if
+                * EGR_FLICK of egr_0 reports as 1.
+                */
+               2 * !!(has_flick);
+       return retval;
+}
+EXPORT_SYMBOL_GPL(synpatics_rmi4_touchpad_detect);
diff --git a/include/linux/input/synaptics_i2c_rmi4.h b/include/linux/input/synaptics_i2c_rmi4.h
new file mode 100644
index 0000000..d299f76
--- /dev/null
+++ b/include/linux/input/synaptics_i2c_rmi4.h
@@ -0,0 +1,269 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) I2C Physical Layer Driver.
+ * Copyright (c) 2007-2010, Synaptics Incorporated
+ *
+ * Author: Js HA <js.ha@stericsson.com> for ST-Ericsson
+ * Author: Naveen Kumar G <naveen.gaddipati@stericsson.com> for ST-Ericsson
+ * Copyright 2010 (c) ST-Ericsson AB
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+#ifndef _SYNAPTICS_RMI4_H_INCLUDED_
+#define _SYNAPTICS_RMI4_H_INCLUDED_
+
+#include <linux/workqueue.h>
+
+#define RMI4_TOUCH_MAX_PRESSURE                (1)
+#define RMI4_TOUCH_MAX_TOOL_WIDTH      (15)
+#define RMI4_TOUCH_MAX_TOUCH_MAJOR     (255)
+#define RMI4_TOUCH_MAX_TOUCH_MINOR     (15)
+
+#define MASK_16BIT             0xFFFF
+#define MASK_8BIT              0xFF
+#define MASK_7BIT              0x7F
+#define MASK_5BIT              0x1F
+#define MASK_4BIT              0x0F
+#define MASK_3BIT              0x07
+#define MASK_2BIT              0x03
+#define RMI4_TOUCH_POLLING_TIME_IN_IDLE                (13000000)
+#define RMI4_TOUCH_POLLING_TIME_IN_PRESSED     (3000000)
+#define RMI4_TOUCH_REPORT_RATE_80              (0)
+#define RMI4_TOUCH_REPORT_RATE_40              (1 << 6)
+#define RMI4_FUNCTION_HANDLER_TABLE_SIZE       (1)
+#define RMI4_NUMBER_OF_MAX_FINGERS             (8)
+#define SYNAPTICS_RMI4_TOUCHPAD_FUNC_NUM       (0x11)
+#define SYNAPTICS_RMI4_DEVICE_CONTROL_FUNC_NUM (0x01)
+
+/**
+ * struct synaptics_rmi4_fn_desc - contains the funtion descriptor information
+ * @query_base_addr:   base address for query
+ * @cmd_base_addr: base address for command
+ * @ctrl_base_addr: base address for control
+ * @data_base_addr: base address for data
+ * @intr_src_count: count for the interrupt source
+ * @fn_number: function number
+ * This structure is used to gives the function descriptor information
+ * of the particular functionality.
+ */
+struct synaptics_rmi4_fn_desc {
+       unsigned char   query_base_addr;
+       unsigned char   cmd_base_addr;
+       unsigned char   ctrl_base_addr;
+       unsigned char   data_base_addr;
+       unsigned char   intr_src_count;
+       unsigned char   fn_number;
+};
+/**
+ * struct synaptics_rmi4_fn - contains the funtion information
+ * @fn_number: function number
+ * @num_of_data_sources: number of data sources
+ * @num_of_data_points: number of fingers touched
+ * @size_of_data_register_block: data register block size
+ * @index_to_intr_reg: index for interrupt register
+ * @intr_mask: interrupt mask value
+ * @fn_desc: variable for function descriptor structure
+ * @link: linked list for function descriptors
+ * This structure gives information about the number of data sources and
+ * the number of data registers associated with the function.
+ */
+struct synaptics_rmi4_fn {
+       unsigned char           fn_number;
+       unsigned char           num_of_data_sources;
+       unsigned char           num_of_data_points;
+       unsigned char           size_of_data_register_block;
+       unsigned char           index_to_intr_reg;
+       unsigned char           intr_mask;
+       struct synaptics_rmi4_fn_desc   fn_desc;
+       struct list_head        link;
+};
+/**
+ * struct synaptics_rmi4_device_info - contains the rmi4 device information
+ * @version_major: protocol major version number
+ * @version_minor: protocol minor version number
+ * @manufacturer_id: manufacturer identification byte
+ * @product_props: product properties information
+ * @product_info: product info array
+ * @date_code: device manufacture date
+ * @tester_id: tester id array
+ * @serial_number: serial number for that device
+ * @product_id_string: product id for the device
+ * @support_fn_list: linked list for device information
+ * This structure gives information about the number of data sources and
+ * the number of data registers associated with the function.
+ */
+struct synaptics_rmi4_device_info {
+       unsigned int            version_major;
+       unsigned int            version_minor;
+       unsigned char           manufacturer_id;
+       unsigned char           product_props;
+       unsigned char           product_info[2];
+       unsigned char           date_code[3];
+       unsigned short          tester_id;
+       unsigned short          serial_number;
+       unsigned char           product_id_string[11];
+       struct list_head        support_fn_list;
+};
+
+/**
+ * struct synaptics_rmi4_platform_data - contains the rmi4 platform data
+ * @irq_number: irq number
+ * @irq_type: irq type
+ * @x_max_res: maximum display x resolution
+ * @y_max_res: maximum display y resolution
+ * @portrait_mode: portrait mode flag
+ * @x flip: x flip flag
+ * @y flip: y flip flag
+ * This structure gives platform data for rmi4.
+ */
+struct synaptics_rmi4_platform_data {
+       int irq_number;
+       int irq_type;
+       int x_max_res;
+       int y_max_res;
+       bool portrait_mode;
+       bool x_flip;
+       bool y_flip;
+};
+
+/**
+ * struct synaptics_rmi4_i2c_data - contains the rmi4 i2c data
+ * @num_clients: i2c address
+ * @platformdata: pointer for platform data
+ * This structure gives i2c data for rmi4.
+ */
+struct synaptics_rmi4_i2c_data {
+       int num_clients;
+       struct synaptics_rmi4_platform_data *platformdata;
+};
+
+/**
+ * struct synaptics_rmi4_data - contains the rmi4 device data
+ * @rmi4_mod_info: structure variable for rmi4 device info
+ * @work: structure variable for work
+ * @timer: structure variable for hrtimer
+ * @input_dev: pointer for input device
+ * @i2c_client: pointer for i2c client
+ * @fn_list_mutex: mutex for funtion list
+ * @rmi4_page_mutex: mutex for rmi4 page
+ * @polling_required: polling mode flag
+ * @irq_number: interrupt number
+ * @irq_type: irq type
+ * @instance_number: instance number
+ * @current_page: variable for integer
+ * @number_of_interrupt_register: interrupt registers count
+ * @fn01_ctrl_base_addr: control base address for fn01
+ * @fn01_query_base_addr: query base address for fn01
+ * @fn01_data_base_addr: data base address for fn01
+ * @sensor_max_x: sensor maximum x value
+ * @sensor_max_y: sensor maximum y value
+ * @touch_pressed: touch pressed variable
+ * @factor_x: scale factor for x
+ * @factor_y: scale factor for y
+ * @x: array for number of x values
+ * @y: array for number of y values
+ * @wx: array for number of wx values
+ * @wy: array for number of wy values
+ * @x_max_res: maximum display x resolution
+ * @y_max_res: maximum display y resolution
+ * @portrait_mode: portrait mode flag
+ * @x flip: x flip flag
+ * @y flip: y flip flag
+ * @byte_read: function pointer to byte read
+ * @byte_write: function pointer to byte write
+ * @block_read: function pointer to block read
+ * @block_write: function pointer to block write
+ * This structure gives the device data information.
+ */
+struct synaptics_rmi4_data {
+       struct synaptics_rmi4_device_info rmi4_mod_info;
+       struct work_struct      work;
+       struct hrtimer          timer;
+       struct input_dev        *input_dev;
+       struct i2c_client       *i2c_client;
+       struct mutex            fn_list_mutex;
+       struct mutex            rmi4_page_mutex;
+       bool                    polling_required;
+       int                     irq_number;
+       int                     irq_type;
+       int                     instance_number;
+       int                     current_page;
+       unsigned int            number_of_interrupt_register;
+       unsigned short          fn01_ctrl_base_addr;
+       unsigned short          fn01_query_base_addr;
+       unsigned short          fn01_data_base_addr;
+       int                     sensor_max_x;
+       int                     sensor_max_y;
+       int                     touch_pressed;
+       int                     factor_x;
+       int                     factor_y;
+       int                     x[RMI4_NUMBER_OF_MAX_FINGERS];
+       int                     y[RMI4_NUMBER_OF_MAX_FINGERS];
+       int                     z[RMI4_NUMBER_OF_MAX_FINGERS];
+       int                     wx[RMI4_NUMBER_OF_MAX_FINGERS];
+       int                     wy[RMI4_NUMBER_OF_MAX_FINGERS];
+       int                     x_max_res;
+       int                     y_max_res;
+       bool                    portrait_mode;
+       bool                    x_flip;
+       bool                    y_flip;
+       int     (*byte_read)(struct synaptics_rmi4_data *pdata,
+                               unsigned short address,
+                               unsigned char *valp);
+       int     (*byte_write)(struct synaptics_rmi4_data *pdata,
+                               unsigned short address,
+                               unsigned char valp);
+       int     (*block_read)(struct synaptics_rmi4_data *pdata,
+                               unsigned short address,
+                               unsigned char *valp, int size);
+       int     (*block_write)(struct synaptics_rmi4_data *pdata,
+                               unsigned short address,
+                               unsigned char *valp, int size);
+};
+
+/**
+ * struct synaptics_rmi4_funtion_handler - contains rmi4 i2c function handlers
+ * @num_clients: i2c address
+ * @platformdata: pointer for platform data
+ * This structure is used to hold the rmi4 i2c function handlers for a
+ * particular funtionality.
+ */
+struct synaptics_rmi4_function_handler {
+       int     fn_number;
+       int     (*pfunc_report)(struct synaptics_rmi4_data *pdata,
+                                       struct synaptics_rmi4_fn *rfi);
+       int     (*pfunc_config)(struct synaptics_rmi4_data *pdata,
+                                       struct synaptics_rmi4_fn *rfi);
+       int     (*pfunc_init)(struct synaptics_rmi4_data *pdata);
+       int     (*pfunc_detect)(struct synaptics_rmi4_data *pdata,
+                               struct synaptics_rmi4_fn *rfi,
+                               struct synaptics_rmi4_fn_desc *fd,
+                               unsigned int interrupt_count);
+};
+
+int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
+                                               struct synaptics_rmi4_fn *rfi);
+int synpatics_rmi4_touchpad_config(struct synaptics_rmi4_data *pdata,
+                                               struct synaptics_rmi4_fn *rfi);
+int synpatics_rmi4_touchpad_init(struct synaptics_rmi4_data *pdata);
+int synpatics_rmi4_touchpad_detect(struct synaptics_rmi4_data *pdata,
+                                       struct synaptics_rmi4_fn *rfi,
+                                       struct synaptics_rmi4_fn_desc *fd,
+                                       unsigned int interruptcount);
+#endif
--
1.6.3.3


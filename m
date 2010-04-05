Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab0DETHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 15:07:20 -0400
Received: from mail.perches.com ([173.55.12.10]:1377 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756171Ab0DETFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 15:05:55 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] drivers/staging/iio: Rename dev_info to idi
Date: Mon,  5 Apr 2010 12:05:38 -0700
Message-Id: <4d8a62de2a8ce7e2037528060cc8875791405431.1270493677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <20100304232928.2e45bdd1.akpm@linux-foundation.org>
References: <20100304232928.2e45bdd1.akpm@linux-foundation.org>
In-Reply-To: <cover.1270493677.git.joe@perches.com>
References: <cover.1270493677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a macro called dev_info that prints struct device specific
information.  Having variables with the same name can be confusing and
prevents conversion of the macro to a function.

Rename the existing dev_info variables to something else in preparation
to converting the dev_info macro to a function.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/iio/accel/lis3l02dq_core.c |    4 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c |   20 ++--
 drivers/staging/iio/accel/sca3000_core.c   |   24 ++--
 drivers/staging/iio/adc/max1363_core.c     |   36 ++--
 drivers/staging/iio/adc/max1363_ring.c     |    6 +-
 drivers/staging/iio/chrdev.h               |    2 +-
 drivers/staging/iio/iio.h                  |   54 ++++----
 drivers/staging/iio/industrialio-core.c    |  232 ++++++++++++++--------------
 drivers/staging/iio/industrialio-ring.c    |   38 +++---
 drivers/staging/iio/industrialio-trigger.c |   34 ++--
 drivers/staging/iio/ring_generic.h         |    4 +-
 drivers/staging/iio/trigger_consumer.h     |   16 +-
 12 files changed, 235 insertions(+), 235 deletions(-)

diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
index f008837..90c99b7 100644
--- a/drivers/staging/iio/accel/lis3l02dq_core.c
+++ b/drivers/staging/iio/accel/lis3l02dq_core.c
@@ -596,12 +596,12 @@ error_mutex_unlock:
 }
 
 
-static int lis3l02dq_thresh_handler_th(struct iio_dev *dev_info,
+static int lis3l02dq_thresh_handler_th(struct iio_dev *idi,
 				       int index,
 				       s64 timestamp,
 				       int no_test)
 {
-	struct lis3l02dq_state *st = dev_info->dev_data;
+	struct lis3l02dq_state *st = idi->dev_data;
 
 	/* Stash the timestamp somewhere convenient for the bh */
 	st->last_timestamp = timestamp;
diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index a6b7c72..7dc5c6a 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -119,12 +119,12 @@ static void lis3l02dq_poll_func_th(struct iio_dev *indio_dev)
 /**
  * lis3l02dq_data_rdy_trig_poll() the event handler for the data rdy trig
  **/
-static int lis3l02dq_data_rdy_trig_poll(struct iio_dev *dev_info,
+static int lis3l02dq_data_rdy_trig_poll(struct iio_dev *idi,
 				       int index,
 				       s64 timestamp,
 				       int no_test)
 {
-	struct lis3l02dq_state *st = iio_dev_get_devdata(dev_info);
+	struct lis3l02dq_state *st = iio_dev_get_devdata(idi);
 	struct iio_trigger *trig = st->trig;
 
 	trig->timestamp = timestamp;
@@ -146,31 +146,31 @@ ssize_t lis3l02dq_read_accel_from_ring(struct device *dev,
 	struct iio_scan_el *el = NULL;
 	int ret, len = 0, i = 0;
 	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct iio_dev *idi = dev_get_drvdata(dev);
 	s16 *data;
 
-	while (dev_info->scan_el_attrs->attrs[i]) {
+	while (idi->scan_el_attrs->attrs[i]) {
 		el = to_iio_scan_el((struct device_attribute *)
-				    (dev_info->scan_el_attrs->attrs[i]));
+				    (idi->scan_el_attrs->attrs[i]));
 		/* label is in fact the address */
 		if (el->label == this_attr->address)
 			break;
 		i++;
 	}
-	if (!dev_info->scan_el_attrs->attrs[i]) {
+	if (!idi->scan_el_attrs->attrs[i]) {
 		ret = -EINVAL;
 		goto error_ret;
 	}
 	/* If this element is in the scan mask */
-	ret = iio_scan_mask_query(dev_info, el->number);
+	ret = iio_scan_mask_query(idi, el->number);
 	if (ret < 0)
 		goto error_ret;
 	if (ret) {
-		data = kmalloc(dev_info->ring->access.get_bpd(dev_info->ring),
+		data = kmalloc(idi->ring->access.get_bpd(idi->ring),
 			       GFP_KERNEL);
 		if (data == NULL)
 			return -ENOMEM;
-		ret = dev_info->ring->access.read_last(dev_info->ring,
+		ret = idi->ring->access.read_last(idi->ring,
 						      (u8 *)data);
 		if (ret)
 			goto error_free_data;
@@ -178,7 +178,7 @@ ssize_t lis3l02dq_read_accel_from_ring(struct device *dev,
 		ret = -EINVAL;
 		goto error_ret;
 	}
-	len = iio_scan_mask_count_to_right(dev_info, el->number);
+	len = iio_scan_mask_count_to_right(idi, el->number);
 	if (len < 0) {
 		ret = len;
 		goto error_free_data;
diff --git a/drivers/staging/iio/accel/sca3000_core.c b/drivers/staging/iio/accel/sca3000_core.c
index cedcaa2..6840d29 100644
--- a/drivers/staging/iio/accel/sca3000_core.c
+++ b/drivers/staging/iio/accel/sca3000_core.c
@@ -331,8 +331,8 @@ static ssize_t sca3000_show_name(struct device *dev,
 				 struct device_attribute *attr,
 				 char *buf)
 {
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct sca3000_state *st = dev_info->dev_data;
+	struct iio_dev *idi = dev_get_drvdata(dev);
+	struct sca3000_state *st = idi->dev_data;
 	return sprintf(buf, "%s\n", st->info->name);
 }
 /**
@@ -343,8 +343,8 @@ static ssize_t sca3000_show_rev(struct device *dev,
 				char *buf)
 {
 	int len = 0, ret;
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct sca3000_state *st = dev_info->dev_data;
+	struct iio_dev *idi = dev_get_drvdata(dev);
+	struct sca3000_state *st = idi->dev_data;
 
 	u8 *rx;
 
@@ -375,8 +375,8 @@ sca3000_show_available_measurement_modes(struct device *dev,
 					 struct device_attribute *attr,
 					 char *buf)
 {
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct sca3000_state *st = dev_info->dev_data;
+	struct iio_dev *idi = dev_get_drvdata(dev);
+	struct sca3000_state *st = idi->dev_data;
 	int len = 0;
 
 	len += sprintf(buf + len, "0 - normal mode");
@@ -407,8 +407,8 @@ sca3000_show_measurement_mode(struct device *dev,
 			      struct device_attribute *attr,
 			      char *buf)
 {
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct sca3000_state *st = dev_info->dev_data;
+	struct iio_dev *idi = dev_get_drvdata(dev);
+	struct sca3000_state *st = idi->dev_data;
 	int len = 0, ret;
 	u8 *rx;
 
@@ -459,8 +459,8 @@ sca3000_store_measurement_mode(struct device *dev,
 			       const char *buf,
 			       size_t len)
 {
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct sca3000_state *st = dev_info->dev_data;
+	struct iio_dev *idi = dev_get_drvdata(dev);
+	struct sca3000_state *st = idi->dev_data;
 	int ret;
 	u8 *rx;
 	int mask = 0x03;
@@ -886,12 +886,12 @@ done:
  * These devices deploy unified interrupt status registers meaning
  * all interrupts must be handled together
  **/
-static int sca3000_handler_th(struct iio_dev *dev_info,
+static int sca3000_handler_th(struct iio_dev *idi,
 			      int index,
 			      s64 timestamp,
 			      int no_test)
 {
-	struct sca3000_state *st = dev_info->dev_data;
+	struct sca3000_state *st = idi->dev_data;
 
 	st->last_timestamp = timestamp;
 	schedule_work(&st->interrupt_handler_ws);
diff --git a/drivers/staging/iio/adc/max1363_core.c b/drivers/staging/iio/adc/max1363_core.c
index 9703881..ed7330c 100644
--- a/drivers/staging/iio/adc/max1363_core.c
+++ b/drivers/staging/iio/adc/max1363_core.c
@@ -321,8 +321,8 @@ static ssize_t max1363_show_av_scan_modes(struct device *dev,
 					  struct device_attribute *attr,
 					  char *buf)
 {
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct max1363_state *st = dev_info->dev_data;
+	struct iio_dev *idi = dev_get_drvdata(dev);
+	struct max1363_state *st = idi->dev_data;
 	int i, len = 0;
 
 	for (i = 0; i < st->chip_info->num_modes; i++)
@@ -340,8 +340,8 @@ static ssize_t max1363_scan_direct(struct device *dev,
 				   struct device_attribute *attr,
 				   char *buf)
 {
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct max1363_state *st = dev_info->dev_data;
+	struct iio_dev *idi = dev_get_drvdata(dev);
+	struct max1363_state *st = idi->dev_data;
 	int len = 0, ret, i;
 	struct i2c_client *client = st->client;
 	char *rxbuf;
@@ -372,15 +372,15 @@ static ssize_t max1363_scan(struct device *dev,
 			    struct device_attribute *attr,
 			    char *buf)
 {
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct iio_dev *idi = dev_get_drvdata(dev);
 	int ret;
 
-	mutex_lock(&dev_info->mlock);
-	if (dev_info->currentmode == INDIO_RING_TRIGGERED)
+	mutex_lock(&idi->mlock);
+	if (idi->currentmode == INDIO_RING_TRIGGERED)
 		ret = max1363_scan_from_ring(dev, attr, buf);
 	else
 		ret = max1363_scan_direct(dev, attr, buf);
-	mutex_unlock(&dev_info->mlock);
+	mutex_unlock(&idi->mlock);
 
 	return ret;
 }
@@ -390,8 +390,8 @@ static ssize_t max1363_show_scan_mode(struct device *dev,
 				      struct device_attribute *attr,
 				      char *buf)
 {
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct max1363_state *st = dev_info->dev_data;
+	struct iio_dev *idi = dev_get_drvdata(dev);
+	struct max1363_state *st = idi->dev_data;
 
 	return sprintf(buf, "%s\n", st->current_mode->name);
 }
@@ -413,15 +413,15 @@ static ssize_t max1363_store_scan_mode(struct device *dev,
 				       const char *buf,
 				       size_t len)
 {
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct max1363_state *st = dev_info->dev_data;
+	struct iio_dev *idi = dev_get_drvdata(dev);
+	struct max1363_state *st = idi->dev_data;
 	const struct max1363_mode *new_mode;
 	int ret;
 
-	mutex_lock(&dev_info->mlock);
+	mutex_lock(&idi->mlock);
 	new_mode = NULL;
 	/* Avoid state changes if a ring buffer is enabled */
-	if (!iio_ring_enabled(dev_info)) {
+	if (!iio_ring_enabled(idi)) {
 		new_mode
 			= __max1363_find_mode_in_ci(st->chip_info, buf);
 		if (!new_mode) {
@@ -436,12 +436,12 @@ static ssize_t max1363_store_scan_mode(struct device *dev,
 		ret = -EBUSY;
 		goto error_ret;
 	}
-	mutex_unlock(&dev_info->mlock);
+	mutex_unlock(&idi->mlock);
 
 	return len;
 
 error_ret:
-	mutex_unlock(&dev_info->mlock);
+	mutex_unlock(&idi->mlock);
 
 	return ret;
 }
@@ -457,8 +457,8 @@ static ssize_t max1363_show_name(struct device *dev,
 				 struct device_attribute *attr,
 				 char *buf)
 {
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct max1363_state *st = dev_info->dev_data;
+	struct iio_dev *idi = dev_get_drvdata(dev);
+	struct max1363_state *st = idi->dev_data;
 	return sprintf(buf, "%s\n", st->chip_info->name);
 }
 
diff --git a/drivers/staging/iio/adc/max1363_ring.c b/drivers/staging/iio/adc/max1363_ring.c
index a953eac..1eae626 100644
--- a/drivers/staging/iio/adc/max1363_ring.c
+++ b/drivers/staging/iio/adc/max1363_ring.c
@@ -29,8 +29,8 @@ ssize_t max1363_scan_from_ring(struct device *dev,
 			       struct device_attribute *attr,
 			       char *buf)
 {
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct max1363_state *info = dev_info->dev_data;
+	struct iio_dev *idi = dev_get_drvdata(dev);
+	struct max1363_state *info = idi->dev_data;
 	int i, ret, len = 0;
 	char *ring_data;
 
@@ -39,7 +39,7 @@ ssize_t max1363_scan_from_ring(struct device *dev,
 		ret = -ENOMEM;
 		goto error_ret;
 	}
-	ret = dev_info->ring->access.read_last(dev_info->ring, ring_data);
+	ret = idi->ring->access.read_last(idi->ring, ring_data);
 	if (ret)
 		goto error_free_ring_data;
 	len += sprintf(buf+len, "ring ");
diff --git a/drivers/staging/iio/chrdev.h b/drivers/staging/iio/chrdev.h
index f42bafb..318a30b 100644
--- a/drivers/staging/iio/chrdev.h
+++ b/drivers/staging/iio/chrdev.h
@@ -113,7 +113,7 @@ struct iio_event_handler_list {
 	struct list_head	list;
 	int			refcount;
 	struct mutex		exist_lock;
-	int (*handler)(struct iio_dev *dev_info, int index, s64 timestamp,
+	int (*handler)(struct iio_dev *idi, int index, s64 timestamp,
 		       int no_test);
 };
 
diff --git a/drivers/staging/iio/iio.h b/drivers/staging/iio/iio.h
index 71dbfe1..f6c4f5a 100644
--- a/drivers/staging/iio/iio.h
+++ b/drivers/staging/iio/iio.h
@@ -134,38 +134,38 @@ struct iio_dev {
  */
 #define IIO_MAX_SCAN_LENGTH 15
 
-static inline int iio_scan_mask_query(struct iio_dev *dev_info, int bit)
+static inline int iio_scan_mask_query(struct iio_dev *idi, int bit)
 {
 	if (bit > IIO_MAX_SCAN_LENGTH)
 		return -EINVAL;
 	else
-		return !!(dev_info->scan_mask & (1 << bit));
+		return !!(idi->scan_mask & (1 << bit));
 };
 
-static inline int iio_scan_mask_set(struct iio_dev *dev_info, int bit)
+static inline int iio_scan_mask_set(struct iio_dev *idi, int bit)
 {
 	if (bit > IIO_MAX_SCAN_LENGTH)
 		return -EINVAL;
-	dev_info->scan_mask |= (1 << bit);
-	dev_info->scan_count++;
+	idi->scan_mask |= (1 << bit);
+	idi->scan_count++;
 	return 0;
 };
 
-static inline int iio_scan_mask_clear(struct iio_dev *dev_info, int bit)
+static inline int iio_scan_mask_clear(struct iio_dev *idi, int bit)
 {
 	if (bit > IIO_MAX_SCAN_LENGTH)
 		return -EINVAL;
-	dev_info->scan_mask &= ~(1 << bit);
-	dev_info->scan_count--;
+	idi->scan_mask &= ~(1 << bit);
+	idi->scan_count--;
 	return 0;
 };
 
 /**
  * iio_scan_mask_count_to_right() - how many scan elements occur before here
- * @dev_info: the iio_device whose scan mode we are querying
+ * @idi: the iio_device whose scan mode we are querying
  * @bit: which number scan element is this
  **/
-static inline int iio_scan_mask_count_to_right(struct iio_dev *dev_info,
+static inline int iio_scan_mask_count_to_right(struct iio_dev *idi,
 						int bit)
 {
 	int count = 0;
@@ -174,7 +174,7 @@ static inline int iio_scan_mask_count_to_right(struct iio_dev *dev_info,
 		return -EINVAL;
 	while (mask) {
 		mask >>= 1;
-		if (mask & dev_info->scan_mask)
+		if (mask & idi->scan_mask)
 			count++;
 	}
 
@@ -183,20 +183,20 @@ static inline int iio_scan_mask_count_to_right(struct iio_dev *dev_info,
 
 /**
  * iio_device_register() - register a device with the IIO subsystem
- * @dev_info:		Device structure filled by the device driver
+ * @idi:		Device structure filled by the device driver
  **/
-int iio_device_register(struct iio_dev *dev_info);
+int iio_device_register(struct iio_dev *idi);
 
 /**
  * iio_device_unregister() - unregister a device from the IIO subsystem
- * @dev_info:		Device structure representing the device.
+ * @idi:		Device structure representing the device.
  **/
-void iio_device_unregister(struct iio_dev *dev_info);
+void iio_device_unregister(struct iio_dev *idi);
 
 /**
  * struct iio_interrupt - wrapper used to allow easy handling of multiple
  *			physical interrupt lines
- * @dev_info:		the iio device for which the is an interrupt line
+ * @idi:		the iio device for which the is an interrupt line
  * @line_number:	associated line number
  * @id:			idr allocated unique id number
  * @irq:		associate interrupt number
@@ -204,7 +204,7 @@ void iio_device_unregister(struct iio_dev *dev_info);
  * @ev_list_lock:	ensure only one access to list at a time
  **/
 struct iio_interrupt {
-	struct iio_dev			*dev_info;
+	struct iio_dev			*idi;
 	int				line_number;
 	int				id;
 	int				irq;
@@ -218,30 +218,30 @@ struct iio_interrupt {
  * iio_register_interrupt_line() - Tell IIO about interrupt lines
  *
  * @irq:		Typically provided via platform data
- * @dev_info:		IIO device info structure for device
+ * @idi:		IIO device info structure for device
  * @line_number:	Which interrupt line of the device is this?
  * @type:		Interrupt type (e.g. edge triggered etc)
  * @name:		Identifying name.
  **/
 int iio_register_interrupt_line(unsigned int			irq,
-				struct iio_dev			*dev_info,
+				struct iio_dev			*idi,
 				int				line_number,
 				unsigned long			type,
 				const char			*name);
 
-void iio_unregister_interrupt_line(struct iio_dev *dev_info,
+void iio_unregister_interrupt_line(struct iio_dev *idi,
 				   int line_number);
 
 
 
 /**
  * iio_push_event() - try to add event to the list for userspace reading
- * @dev_info:		IIO device structure
+ * @idi:		IIO device structure
  * @ev_line:		Which event line (hardware interrupt)
  * @ev_code:		What event
  * @timestamp:		When the event occurred
  **/
-int iio_push_event(struct iio_dev *dev_info,
+int iio_push_event(struct iio_dev *idi,
 		  int ev_line,
 		  int ev_code,
 		  s64 timestamp);
@@ -328,9 +328,9 @@ void iio_free_ev_int(struct iio_event_interface *ev_int);
 /**
  * iio_allocate_chrdev() - Allocate a chrdev
  * @handler:	struct that contains relevant file handling for chrdev
- * @dev_info:	iio_dev for which chrdev is being created
+ * @idi:	iio_dev for which chrdev is being created
  **/
-int iio_allocate_chrdev(struct iio_handler *handler, struct iio_dev *dev_info);
+int iio_allocate_chrdev(struct iio_handler *handler, struct iio_dev *idi);
 void iio_deallocate_chrdev(struct iio_handler *handler);
 
 /* Used to distinguish between bipolar and unipolar scan elemenents.
@@ -397,11 +397,11 @@ void iio_device_free_chrdev_minor(int val);
 
 /**
  * iio_ring_enabled() - helper function to test if any form of ring is enabled
- * @dev_info:		IIO device info structure for device
+ * @idi:		IIO device info structure for device
  **/
-static inline bool iio_ring_enabled(struct iio_dev *dev_info)
+static inline bool iio_ring_enabled(struct iio_dev *idi)
 {
-	return dev_info->currentmode
+	return idi->currentmode
 		& (INDIO_RING_TRIGGERED
 		   | INDIO_RING_HARDWARE_BUFFER);
 };
diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index b456dfc..ae5882c 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -107,12 +107,12 @@ error_ret:
 }
 EXPORT_SYMBOL(__iio_push_event);
 
-int iio_push_event(struct iio_dev *dev_info,
+int iio_push_event(struct iio_dev *idi,
 		   int ev_line,
 		   int ev_code,
 		   s64 timestamp)
 {
-	return __iio_push_event(&dev_info->event_interfaces[ev_line],
+	return __iio_push_event(&idi->event_interfaces[ev_line],
 				ev_code, timestamp, NULL);
 }
 EXPORT_SYMBOL(iio_push_event);
@@ -121,7 +121,7 @@ EXPORT_SYMBOL(iio_push_event);
 static irqreturn_t iio_interrupt_handler(int irq, void *_int_info)
 {
 	struct iio_interrupt *int_info = _int_info;
-	struct iio_dev *dev_info = int_info->dev_info;
+	struct iio_dev *idi = int_info->idi;
 	struct iio_event_handler_list *p;
 	s64 time_ns;
 	unsigned long flags;
@@ -140,11 +140,11 @@ static irqreturn_t iio_interrupt_handler(int irq, void *_int_info)
 				     struct iio_event_handler_list,
 				     list);
 		/* single event handler - maybe shared */
-		p->handler(dev_info, 1, time_ns, !(p->refcount > 1));
+		p->handler(idi, 1, time_ns, !(p->refcount > 1));
 	} else
 		list_for_each_entry(p, &int_info->ev_list, list) {
 			disable_irq_nosync(irq);
-			p->handler(dev_info, 1, time_ns, 0);
+			p->handler(idi, 1, time_ns, 0);
 		}
 	spin_unlock_irqrestore(&int_info->ev_list_lock, flags);
 
@@ -163,21 +163,21 @@ static struct iio_interrupt *iio_allocate_interrupt(void)
 
 /* Confirming the validity of supplied irq is left to drivers.*/
 int iio_register_interrupt_line(unsigned int irq,
-				struct iio_dev *dev_info,
+				struct iio_dev *idi,
 				int line_number,
 				unsigned long type,
 				const char *name)
 {
 	int ret;
 
-	dev_info->interrupts[line_number] = iio_allocate_interrupt();
-	if (dev_info->interrupts[line_number] == NULL) {
+	idi->interrupts[line_number] = iio_allocate_interrupt();
+	if (idi->interrupts[line_number] == NULL) {
 		ret = -ENOMEM;
 		goto error_ret;
 	}
-	dev_info->interrupts[line_number]->line_number = line_number;
-	dev_info->interrupts[line_number]->irq = irq;
-	dev_info->interrupts[line_number]->dev_info = dev_info;
+	idi->interrupts[line_number]->line_number = line_number;
+	idi->interrupts[line_number]->irq = irq;
+	idi->interrupts[line_number]->idi = idi;
 
 	/* Possibly only request on demand?
 	 * Can see this may complicate the handling of interrupts.
@@ -187,7 +187,7 @@ int iio_register_interrupt_line(unsigned int irq,
 			  &iio_interrupt_handler,
 			  type,
 			  name,
-			  dev_info->interrupts[line_number]);
+			  idi->interrupts[line_number]);
 
 error_ret:
 	return ret;
@@ -204,13 +204,13 @@ ssize_t iio_read_const_attr(struct device *dev,
 EXPORT_SYMBOL(iio_read_const_attr);
 
 /* Before this runs the interrupt generator must have been disabled */
-void iio_unregister_interrupt_line(struct iio_dev *dev_info, int line_number)
+void iio_unregister_interrupt_line(struct iio_dev *idi, int line_number)
 {
 	/* make sure the interrupt handlers are all done */
 	flush_scheduled_work();
-	free_irq(dev_info->interrupts[line_number]->irq,
-		 dev_info->interrupts[line_number]);
-	kfree(dev_info->interrupts[line_number]);
+	free_irq(idi->interrupts[line_number]->irq,
+		 idi->interrupts[line_number]);
+	kfree(idi->interrupts[line_number]);
 }
 EXPORT_SYMBOL(iio_unregister_interrupt_line);
 
@@ -504,22 +504,22 @@ static void __exit iio_exit(void)
 	class_unregister(&iio_class);
 }
 
-static int iio_device_register_sysfs(struct iio_dev *dev_info)
+static int iio_device_register_sysfs(struct iio_dev *idi)
 {
 	int ret = 0;
 
-	ret = sysfs_create_group(&dev_info->dev.kobj, dev_info->attrs);
+	ret = sysfs_create_group(&idi->dev.kobj, idi->attrs);
 	if (ret) {
-		dev_err(dev_info->dev.parent,
+		dev_err(idi->dev.parent,
 			"Failed to register sysfs hooks\n");
 		goto error_ret;
 	}
 
-	if (dev_info->scan_el_attrs) {
-		ret = sysfs_create_group(&dev_info->dev.kobj,
-					 dev_info->scan_el_attrs);
+	if (idi->scan_el_attrs) {
+		ret = sysfs_create_group(&idi->dev.kobj,
+					 idi->scan_el_attrs);
 		if (ret)
-			dev_err(&dev_info->dev,
+			dev_err(&idi->dev,
 				"Failed to add sysfs scan els\n");
 	}
 
@@ -527,13 +527,13 @@ error_ret:
 	return ret;
 }
 
-static void iio_device_unregister_sysfs(struct iio_dev *dev_info)
+static void iio_device_unregister_sysfs(struct iio_dev *idi)
 {
-	if (dev_info->scan_el_attrs)
-		sysfs_remove_group(&dev_info->dev.kobj,
-				   dev_info->scan_el_attrs);
+	if (idi->scan_el_attrs)
+		sysfs_remove_group(&idi->dev.kobj,
+				   idi->scan_el_attrs);
 
-	sysfs_remove_group(&dev_info->dev.kobj, dev_info->attrs);
+	sysfs_remove_group(&idi->dev.kobj, idi->attrs);
 }
 
 int iio_get_new_idr_val(struct idr *this_idr)
@@ -565,33 +565,33 @@ void iio_free_idr_val(struct idr *this_idr, int id)
 }
 EXPORT_SYMBOL(iio_free_idr_val);
 
-static int iio_device_register_id(struct iio_dev *dev_info,
+static int iio_device_register_id(struct iio_dev *idi,
 				  struct idr *this_idr)
 {
 
-	dev_info->id = iio_get_new_idr_val(&iio_idr);
-	if (dev_info->id < 0)
-		return dev_info->id;
+	idi->id = iio_get_new_idr_val(&iio_idr);
+	if (idi->id < 0)
+		return idi->id;
 	return 0;
 }
 
-static void iio_device_unregister_id(struct iio_dev *dev_info)
+static void iio_device_unregister_id(struct iio_dev *idi)
 {
-	iio_free_idr_val(&iio_idr, dev_info->id);
+	iio_free_idr_val(&iio_idr, idi->id);
 }
 
-static inline int __iio_add_event_config_attrs(struct iio_dev *dev_info, int i)
+static inline int __iio_add_event_config_attrs(struct iio_dev *idi, int i)
 {
 	int ret;
 	/*p for adding, q for removing */
 	struct attribute **attrp, **attrq;
 
-	if (dev_info->event_conf_attrs && dev_info->event_conf_attrs[i].attrs) {
-		attrp = dev_info->event_conf_attrs[i].attrs;
+	if (idi->event_conf_attrs && idi->event_conf_attrs[i].attrs) {
+		attrp = idi->event_conf_attrs[i].attrs;
 		while (*attrp) {
-			ret =  sysfs_add_file_to_group(&dev_info->dev.kobj,
+			ret =  sysfs_add_file_to_group(&idi->dev.kobj,
 						       *attrp,
-						       dev_info
+						       idi
 						       ->event_attrs[i].name);
 			if (ret)
 				goto error_ret;
@@ -601,29 +601,29 @@ static inline int __iio_add_event_config_attrs(struct iio_dev *dev_info, int i)
 	return 0;
 
 error_ret:
-	attrq = dev_info->event_conf_attrs[i].attrs;
+	attrq = idi->event_conf_attrs[i].attrs;
 	while (attrq != attrp) {
-			sysfs_remove_file_from_group(&dev_info->dev.kobj,
+			sysfs_remove_file_from_group(&idi->dev.kobj,
 					     *attrq,
-					     dev_info->event_attrs[i].name);
+					     idi->event_attrs[i].name);
 		attrq++;
 	}
 
 	return ret;
 }
 
-static inline int __iio_remove_event_config_attrs(struct iio_dev *dev_info,
+static inline int __iio_remove_event_config_attrs(struct iio_dev *idi,
 						  int i)
 {
 	struct attribute **attrq;
 
-	if (dev_info->event_conf_attrs
-		&& dev_info->event_conf_attrs[i].attrs) {
-		attrq = dev_info->event_conf_attrs[i].attrs;
+	if (idi->event_conf_attrs
+		&& idi->event_conf_attrs[i].attrs) {
+		attrq = idi->event_conf_attrs[i].attrs;
 		while (*attrq) {
-			sysfs_remove_file_from_group(&dev_info->dev.kobj,
+			sysfs_remove_file_from_group(&idi->dev.kobj,
 						     *attrq,
-						     dev_info
+						     idi
 						     ->event_attrs[i].name);
 			attrq++;
 		}
@@ -632,74 +632,74 @@ static inline int __iio_remove_event_config_attrs(struct iio_dev *dev_info,
 	return 0;
 }
 
-static int iio_device_register_eventset(struct iio_dev *dev_info)
+static int iio_device_register_eventset(struct iio_dev *idi)
 {
 	int ret = 0, i, j;
 
-	if (dev_info->num_interrupt_lines == 0)
+	if (idi->num_interrupt_lines == 0)
 		return 0;
 
-	dev_info->event_interfaces =
+	idi->event_interfaces =
 		kzalloc(sizeof(struct iio_event_interface)
-			*dev_info->num_interrupt_lines,
+			*idi->num_interrupt_lines,
 			GFP_KERNEL);
-	if (dev_info->event_interfaces == NULL) {
+	if (idi->event_interfaces == NULL) {
 		ret = -ENOMEM;
 		goto error_ret;
 	}
 
-	dev_info->interrupts = kzalloc(sizeof(struct iio_interrupt *)
-				       *dev_info->num_interrupt_lines,
+	idi->interrupts = kzalloc(sizeof(struct iio_interrupt *)
+				       *idi->num_interrupt_lines,
 				       GFP_KERNEL);
-	if (dev_info->interrupts == NULL) {
+	if (idi->interrupts == NULL) {
 		ret = -ENOMEM;
 		goto error_free_event_interfaces;
 	}
 
-	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
-		dev_info->event_interfaces[i].owner = dev_info->driver_module;
+	for (i = 0; i < idi->num_interrupt_lines; i++) {
+		idi->event_interfaces[i].owner = idi->driver_module;
 		ret = iio_get_new_idr_val(&iio_event_idr);
 		if (ret)
 			goto error_free_setup_ev_ints;
 		else
-			dev_info->event_interfaces[i].id = ret;
+			idi->event_interfaces[i].id = ret;
 
-		snprintf(dev_info->event_interfaces[i]._name, 20,
+		snprintf(idi->event_interfaces[i]._name, 20,
 			 "event_line%d",
-			dev_info->event_interfaces[i].id);
+			idi->event_interfaces[i].id);
 
-		ret = iio_setup_ev_int(&dev_info->event_interfaces[i],
-				       (const char *)(dev_info
+		ret = iio_setup_ev_int(&idi->event_interfaces[i],
+				       (const char *)(idi
 						      ->event_interfaces[i]
 						      ._name),
-				       dev_info->driver_module,
-				       &dev_info->dev);
+				       idi->driver_module,
+				       &idi->dev);
 		if (ret) {
-			dev_err(&dev_info->dev,
+			dev_err(&idi->dev,
 				"Could not get chrdev interface\n");
 			iio_free_idr_val(&iio_event_idr,
-					 dev_info->event_interfaces[i].id);
+					 idi->event_interfaces[i].id);
 			goto error_free_setup_ev_ints;
 		}
 	}
 
-	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
-		snprintf(dev_info->event_interfaces[i]._attrname, 20,
+	for (i = 0; i < idi->num_interrupt_lines; i++) {
+		snprintf(idi->event_interfaces[i]._attrname, 20,
 			"event_line%d_sources", i);
-		dev_info->event_attrs[i].name
+		idi->event_attrs[i].name
 			= (const char *)
-			(dev_info->event_interfaces[i]._attrname);
-		ret = sysfs_create_group(&dev_info->dev.kobj,
-					 &dev_info->event_attrs[i]);
+			(idi->event_interfaces[i]._attrname);
+		ret = sysfs_create_group(&idi->dev.kobj,
+					 &idi->event_attrs[i]);
 		if (ret) {
-			dev_err(&dev_info->dev,
+			dev_err(&idi->dev,
 				"Failed to register sysfs for event attrs");
 			goto error_remove_sysfs_interfaces;
 		}
 	}
 
-	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
-		ret = __iio_add_event_config_attrs(dev_info, i);
+	for (i = 0; i < idi->num_interrupt_lines; i++) {
+		ret = __iio_add_event_config_attrs(idi, i);
 		if (ret)
 			goto error_unregister_config_attrs;
 	}
@@ -708,44 +708,44 @@ static int iio_device_register_eventset(struct iio_dev *dev_info)
 
 error_unregister_config_attrs:
 	for (j = 0; j < i; j++)
-		__iio_remove_event_config_attrs(dev_info, i);
-	i = dev_info->num_interrupt_lines - 1;
+		__iio_remove_event_config_attrs(idi, i);
+	i = idi->num_interrupt_lines - 1;
 error_remove_sysfs_interfaces:
 	for (j = 0; j < i; j++)
-		sysfs_remove_group(&dev_info->dev.kobj,
-				   &dev_info->event_attrs[j]);
-	i = dev_info->num_interrupt_lines - 1;
+		sysfs_remove_group(&idi->dev.kobj,
+				   &idi->event_attrs[j]);
+	i = idi->num_interrupt_lines - 1;
 error_free_setup_ev_ints:
 	for (j = 0; j < i; j++) {
 		iio_free_idr_val(&iio_event_idr,
-				 dev_info->event_interfaces[i].id);
-		iio_free_ev_int(&dev_info->event_interfaces[j]);
+				 idi->event_interfaces[i].id);
+		iio_free_ev_int(&idi->event_interfaces[j]);
 	}
-	kfree(dev_info->interrupts);
+	kfree(idi->interrupts);
 error_free_event_interfaces:
-	kfree(dev_info->event_interfaces);
+	kfree(idi->event_interfaces);
 error_ret:
 
 	return ret;
 }
 
-static void iio_device_unregister_eventset(struct iio_dev *dev_info)
+static void iio_device_unregister_eventset(struct iio_dev *idi)
 {
 	int i;
 
-	if (dev_info->num_interrupt_lines == 0)
+	if (idi->num_interrupt_lines == 0)
 		return;
-	for (i = 0; i < dev_info->num_interrupt_lines; i++)
-		sysfs_remove_group(&dev_info->dev.kobj,
-				   &dev_info->event_attrs[i]);
+	for (i = 0; i < idi->num_interrupt_lines; i++)
+		sysfs_remove_group(&idi->dev.kobj,
+				   &idi->event_attrs[i]);
 
-	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
+	for (i = 0; i < idi->num_interrupt_lines; i++) {
 		iio_free_idr_val(&iio_event_idr,
-				 dev_info->event_interfaces[i].id);
-		iio_free_ev_int(&dev_info->event_interfaces[i]);
+				 idi->event_interfaces[i].id);
+		iio_free_ev_int(&idi->event_interfaces[i]);
 	}
-	kfree(dev_info->interrupts);
-	kfree(dev_info->event_interfaces);
+	kfree(idi->interrupts);
+	kfree(idi->event_interfaces);
 }
 
 static void iio_dev_release(struct device *device)
@@ -785,56 +785,56 @@ void iio_free_device(struct iio_dev *dev)
 }
 EXPORT_SYMBOL(iio_free_device);
 
-int iio_device_register(struct iio_dev *dev_info)
+int iio_device_register(struct iio_dev *idi)
 {
 	int ret;
 
-	ret = iio_device_register_id(dev_info, &iio_idr);
+	ret = iio_device_register_id(idi, &iio_idr);
 	if (ret) {
-		dev_err(&dev_info->dev, "Failed to get id\n");
+		dev_err(&idi->dev, "Failed to get id\n");
 		goto error_ret;
 	}
-	dev_set_name(&dev_info->dev, "device%d", dev_info->id);
+	dev_set_name(&idi->dev, "device%d", idi->id);
 
-	ret = device_add(&dev_info->dev);
+	ret = device_add(&idi->dev);
 	if (ret)
 		goto error_free_idr;
-	ret = iio_device_register_sysfs(dev_info);
+	ret = iio_device_register_sysfs(idi);
 	if (ret) {
-		dev_err(dev_info->dev.parent,
+		dev_err(idi->dev.parent,
 			"Failed to register sysfs interfaces\n");
 		goto error_del_device;
 	}
-	ret = iio_device_register_eventset(dev_info);
+	ret = iio_device_register_eventset(idi);
 	if (ret) {
-		dev_err(dev_info->dev.parent,
+		dev_err(idi->dev.parent,
 			"Failed to register event set \n");
 		goto error_free_sysfs;
 	}
-	if (dev_info->modes & INDIO_RING_TRIGGERED)
-		iio_device_register_trigger_consumer(dev_info);
+	if (idi->modes & INDIO_RING_TRIGGERED)
+		iio_device_register_trigger_consumer(idi);
 
 	return 0;
 
 error_free_sysfs:
-	iio_device_unregister_sysfs(dev_info);
+	iio_device_unregister_sysfs(idi);
 error_del_device:
-	device_del(&dev_info->dev);
+	device_del(&idi->dev);
 error_free_idr:
-	iio_device_unregister_id(dev_info);
+	iio_device_unregister_id(idi);
 error_ret:
 	return ret;
 }
 EXPORT_SYMBOL(iio_device_register);
 
-void iio_device_unregister(struct iio_dev *dev_info)
+void iio_device_unregister(struct iio_dev *idi)
 {
-	if (dev_info->modes & INDIO_RING_TRIGGERED)
-		iio_device_unregister_trigger_consumer(dev_info);
-	iio_device_unregister_eventset(dev_info);
-	iio_device_unregister_sysfs(dev_info);
-	iio_device_unregister_id(dev_info);
-	device_unregister(&dev_info->dev);
+	if (idi->modes & INDIO_RING_TRIGGERED)
+		iio_device_unregister_trigger_consumer(idi);
+	iio_device_unregister_eventset(idi);
+	iio_device_unregister_sysfs(idi);
+	iio_device_unregister_id(idi);
+	device_unregister(&idi->dev);
 }
 EXPORT_SYMBOL(iio_device_unregister);
 
diff --git a/drivers/staging/iio/industrialio-ring.c b/drivers/staging/iio/industrialio-ring.c
index ebe5ccc..345ece1 100644
--- a/drivers/staging/iio/industrialio-ring.c
+++ b/drivers/staging/iio/industrialio-ring.c
@@ -258,11 +258,11 @@ static void __iio_free_ring_buffer_access_chrdev(struct iio_ring_buffer *buf)
 }
 
 void iio_ring_buffer_init(struct iio_ring_buffer *ring,
-			  struct iio_dev *dev_info)
+			  struct iio_dev *idi)
 {
 	if (ring->access.mark_param_change)
 		ring->access.mark_param_change(ring);
-	ring->indio_dev = dev_info;
+	ring->indio_dev = idi;
 	ring->ev_int.private = ring;
 	ring->access_handler.private = ring;
 }
@@ -382,10 +382,10 @@ ssize_t iio_store_ring_enable(struct device *dev,
 	bool requested_state, current_state;
 	int previous_mode;
 	struct iio_ring_buffer *ring = dev_get_drvdata(dev);
-	struct iio_dev *dev_info = ring->indio_dev;
+	struct iio_dev *idi = ring->indio_dev;
 
-	mutex_lock(&dev_info->mlock);
-	previous_mode = dev_info->currentmode;
+	mutex_lock(&idi->mlock);
+	previous_mode = idi->currentmode;
 	requested_state = !(buf[0] == '0');
 	current_state = !!(previous_mode & INDIO_ALL_RING_MODES);
 	if (current_state == requested_state) {
@@ -394,7 +394,7 @@ ssize_t iio_store_ring_enable(struct device *dev,
 	}
 	if (requested_state) {
 		if (ring->preenable) {
-			ret = ring->preenable(dev_info);
+			ret = ring->preenable(idi);
 			if (ret) {
 				printk(KERN_ERR
 				       "Buffer not started:"
@@ -414,8 +414,8 @@ ssize_t iio_store_ring_enable(struct device *dev,
 		if (ring->access.mark_in_use)
 			ring->access.mark_in_use(ring);
 		/* Definitely possible for devices to support both of these.*/
-		if (dev_info->modes & INDIO_RING_TRIGGERED) {
-			if (!dev_info->trig) {
+		if (idi->modes & INDIO_RING_TRIGGERED) {
+			if (!idi->trig) {
 				printk(KERN_INFO
 				       "Buffer not started: no trigger\n");
 				ret = -EINVAL;
@@ -423,9 +423,9 @@ ssize_t iio_store_ring_enable(struct device *dev,
 					ring->access.unmark_in_use(ring);
 				goto error_ret;
 			}
-			dev_info->currentmode = INDIO_RING_TRIGGERED;
-		} else if (dev_info->modes & INDIO_RING_HARDWARE_BUFFER)
-			dev_info->currentmode = INDIO_RING_HARDWARE_BUFFER;
+			idi->currentmode = INDIO_RING_TRIGGERED;
+		} else if (idi->modes & INDIO_RING_HARDWARE_BUFFER)
+			idi->currentmode = INDIO_RING_HARDWARE_BUFFER;
 		else { /* should never be reached */
 			ret = -EINVAL;
 			goto error_ret;
@@ -433,40 +433,40 @@ ssize_t iio_store_ring_enable(struct device *dev,
 
 		if (ring->postenable) {
 
-			ret = ring->postenable(dev_info);
+			ret = ring->postenable(idi);
 			if (ret) {
 				printk(KERN_INFO
 				       "Buffer not started:"
 				       "postenable failed\n");
 				if (ring->access.unmark_in_use)
 					ring->access.unmark_in_use(ring);
-				dev_info->currentmode = previous_mode;
+				idi->currentmode = previous_mode;
 				if (ring->postdisable)
-					ring->postdisable(dev_info);
+					ring->postdisable(idi);
 				goto error_ret;
 			}
 		}
 	} else {
 		if (ring->predisable) {
-			ret = ring->predisable(dev_info);
+			ret = ring->predisable(idi);
 			if (ret)
 				goto error_ret;
 		}
 		if (ring->access.unmark_in_use)
 			ring->access.unmark_in_use(ring);
-		dev_info->currentmode = INDIO_DIRECT_MODE;
+		idi->currentmode = INDIO_DIRECT_MODE;
 		if (ring->postdisable) {
-			ret = ring->postdisable(dev_info);
+			ret = ring->postdisable(idi);
 			if (ret)
 				goto error_ret;
 		}
 	}
 done:
-	mutex_unlock(&dev_info->mlock);
+	mutex_unlock(&idi->mlock);
 	return len;
 
 error_ret:
-	mutex_unlock(&dev_info->mlock);
+	mutex_unlock(&idi->mlock);
 	return ret;
 }
 EXPORT_SYMBOL(iio_store_ring_enable);
diff --git a/drivers/staging/iio/industrialio-trigger.c b/drivers/staging/iio/industrialio-trigger.c
index 693ebc4..8f33535 100644
--- a/drivers/staging/iio/industrialio-trigger.c
+++ b/drivers/staging/iio/industrialio-trigger.c
@@ -288,13 +288,13 @@ static ssize_t iio_trigger_read_current(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
+	struct iio_dev *idi = dev_get_drvdata(dev);
 	int len = 0;
-	if (dev_info->trig)
+	if (idi->trig)
 		len = snprintf(buf,
 			       IIO_TRIGGER_NAME_LENGTH,
 			       "%s\n",
-			       dev_info->trig->name);
+			       idi->trig->name);
 	return len;
 }
 
@@ -310,22 +310,22 @@ static ssize_t iio_trigger_write_current(struct device *dev,
 					 const char *buf,
 					 size_t len)
 {
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct iio_trigger *oldtrig = dev_info->trig;
-	mutex_lock(&dev_info->mlock);
-	if (dev_info->currentmode == INDIO_RING_TRIGGERED) {
-		mutex_unlock(&dev_info->mlock);
+	struct iio_dev *idi = dev_get_drvdata(dev);
+	struct iio_trigger *oldtrig = idi->trig;
+	mutex_lock(&idi->mlock);
+	if (idi->currentmode == INDIO_RING_TRIGGERED) {
+		mutex_unlock(&idi->mlock);
 		return -EBUSY;
 	}
-	mutex_unlock(&dev_info->mlock);
+	mutex_unlock(&idi->mlock);
 
 	len = len < IIO_TRIGGER_NAME_LENGTH ? len : IIO_TRIGGER_NAME_LENGTH;
 
-	dev_info->trig = iio_trigger_find_by_name(buf, len);
-	if (oldtrig && dev_info->trig != oldtrig)
+	idi->trig = iio_trigger_find_by_name(buf, len);
+	if (oldtrig && idi->trig != oldtrig)
 		iio_put_trigger(oldtrig);
-	if (dev_info->trig)
-		iio_get_trigger(dev_info->trig);
+	if (idi->trig)
+		iio_get_trigger(idi->trig);
 
 	return len;
 }
@@ -380,18 +380,18 @@ void iio_free_trigger(struct iio_trigger *trig)
 }
 EXPORT_SYMBOL(iio_free_trigger);
 
-int iio_device_register_trigger_consumer(struct iio_dev *dev_info)
+int iio_device_register_trigger_consumer(struct iio_dev *idi)
 {
 	int ret;
-	ret = sysfs_create_group(&dev_info->dev.kobj,
+	ret = sysfs_create_group(&idi->dev.kobj,
 				 &iio_trigger_consumer_attr_group);
 	return ret;
 }
 EXPORT_SYMBOL(iio_device_register_trigger_consumer);
 
-int iio_device_unregister_trigger_consumer(struct iio_dev *dev_info)
+int iio_device_unregister_trigger_consumer(struct iio_dev *idi)
 {
-	sysfs_remove_group(&dev_info->dev.kobj,
+	sysfs_remove_group(&idi->dev.kobj,
 			   &iio_trigger_consumer_attr_group);
 	return 0;
 }
diff --git a/drivers/staging/iio/ring_generic.h b/drivers/staging/iio/ring_generic.h
index 09044ad..6da8bae 100644
--- a/drivers/staging/iio/ring_generic.h
+++ b/drivers/staging/iio/ring_generic.h
@@ -131,7 +131,7 @@ struct iio_ring_buffer {
 
 };
 void iio_ring_buffer_init(struct iio_ring_buffer *ring,
-			  struct iio_dev *dev_info);
+			  struct iio_dev *idi);
 
 /**
  * __iio_init_ring_buffer() - initialize common elements of ring buffers
@@ -166,7 +166,7 @@ struct iio_scan_el {
 	unsigned int			label;
 
 	int (*set_state)(struct iio_scan_el *scanel,
-			 struct iio_dev *dev_info,
+			 struct iio_dev *idi,
 			 bool state);
 };
 
diff --git a/drivers/staging/iio/trigger_consumer.h b/drivers/staging/iio/trigger_consumer.h
index 9d52d96..944d562 100644
--- a/drivers/staging/iio/trigger_consumer.h
+++ b/drivers/staging/iio/trigger_consumer.h
@@ -11,32 +11,32 @@
 #ifdef CONFIG_IIO_TRIGGER
 /**
  * iio_device_register_trigger_consumer() - set up an iio_dev to use triggers
- * @dev_info: iio_dev associated with the device that will consume the trigger
+ * @idi: iio_dev associated with the device that will consume the trigger
  **/
-int iio_device_register_trigger_consumer(struct iio_dev *dev_info);
+int iio_device_register_trigger_consumer(struct iio_dev *idi);
 
 /**
  * iio_device_unregister_trigger_consumer() - reverse the registration process
- * @dev_info: iio_dev associated with the device that consumed the trigger
+ * @idi: iio_dev associated with the device that consumed the trigger
  **/
-int iio_device_unregister_trigger_consumer(struct iio_dev *dev_info);
+int iio_device_unregister_trigger_consumer(struct iio_dev *idi);
 
 #else
 
 /**
  * iio_device_register_trigger_consumer() - set up an iio_dev to use triggers
- * @dev_info: iio_dev associated with the device that will consume the trigger
+ * @idi: iio_dev associated with the device that will consume the trigger
  **/
-static int iio_device_register_trigger_consumer(struct iio_dev *dev_info)
+static int iio_device_register_trigger_consumer(struct iio_dev *idi)
 {
 	return 0;
 };
 
 /**
  * iio_device_unregister_trigger_consumer() - reverse the registration process
- * @dev_info: iio_dev associated with the device that consumed the trigger
+ * @idi: iio_dev associated with the device that consumed the trigger
  **/
-static int iio_device_unregister_trigger_consumer(struct iio_dev *dev_info)
+static int iio_device_unregister_trigger_consumer(struct iio_dev *idi)
 {
 	return 0;
 };
-- 
1.7.0.3.311.g6a6955


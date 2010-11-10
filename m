Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab0KJGUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 01:20:32 -0500
Received: from mail.vyatta.com ([76.74.103.46]:60044 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab0KJGUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 01:20:31 -0500
Date: Tue, 9 Nov 2010 22:20:29 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Greg KH <greg@kroah.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] virtio: fix format of sysfs driver/vendor files
Message-ID: <20101109222029.65f3e192@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sysfs files for virtio produce the wrong format and are missing
the required newline. The output for virtio bus vendor/device should
have the same format as the corresponding entries for PCI devices.

Although this technically changes the ABI for sysfs, these files were
broken to start with!

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/drivers/virtio/virtio.c	2010-11-09 21:39:31.713916249 -0800
+++ b/drivers/virtio/virtio.c	2010-11-09 21:40:16.072089461 -0800
@@ -9,19 +9,19 @@ static ssize_t device_show(struct device
 			   struct device_attribute *attr, char *buf)
 {
 	struct virtio_device *dev = container_of(_d,struct virtio_device,dev);
-	return sprintf(buf, "%hu", dev->id.device);
+	return sprintf(buf, "0x%04x\n", dev->id.device);
 }
 static ssize_t vendor_show(struct device *_d,
 			   struct device_attribute *attr, char *buf)
 {
 	struct virtio_device *dev = container_of(_d,struct virtio_device,dev);
-	return sprintf(buf, "%hu", dev->id.vendor);
+	return sprintf(buf, "0x%04x\n", dev->id.vendor);
 }
 static ssize_t status_show(struct device *_d,
 			   struct device_attribute *attr, char *buf)
 {
 	struct virtio_device *dev = container_of(_d,struct virtio_device,dev);
-	return sprintf(buf, "0x%08x", dev->config->get_status(dev));
+	return sprintf(buf, "0x%08x\n", dev->config->get_status(dev));
 }
 static ssize_t modalias_show(struct device *_d,
 			     struct device_attribute *attr, char *buf)

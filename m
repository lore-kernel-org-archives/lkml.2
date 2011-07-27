Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab1G0Vil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:38:41 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:42425 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab1G0Vii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:38:38 -0400
Subject: [PATCH 2/2] cciss: add transport mode attribute to sys
To: axboe@kernel.dk
From: Joe Handzik <joseph.t.handzik@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, stephenmcameron@gmail.com,
        scameron@beardog.cce.hp.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, thenzl@redhat.com
Date: Wed, 27 Jul 2011 16:38:36 -0500
Message-ID: <20110727213835.13453.64091.stgit@beardog.cce.hp.com>
In-Reply-To: <20110727213830.13453.15208.stgit@beardog.cce.hp.com>
References: <20110727213830.13453.15208.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Handzik <joseph.t.handzik@beardog.cce.hp.com>

Signed-off-by: Joseph Handzik <joseph.t.handzik@beardog.cce.hp.com>
---
 .../ABI/testing/sysfs-bus-pci-devices-cciss        |    7 +++++++
 drivers/block/cciss.c                              |   13 +++++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
index f5bb0a3..53d99ed 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
+++ b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
@@ -71,3 +71,10 @@ Description:	Value of 1 indicates the controller can honor the reset_devices
 		a dump device, as kdump requires resetting the device in order
 		to work reliably.
 
+Where:		/sys/bus/pci/devices/<dev>/ccissX/transport_mode
+Date:		July 2011
+Kernel Version:	3.0
+Contact:	iss_storagedev@hp.com
+Description:	Value of "simple" indicates that the controller has been placed
+		in "simple mode". Value of "performant" indicates that the
+		controller has been placed in "performant mode".
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 61f0b5b..6da7ede 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -641,6 +641,18 @@ static ssize_t host_store_rescan(struct device *dev,
 }
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
 
+static ssize_t host_show_transport_mode(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct ctlr_info *h = to_hba(dev);
+
+	return snprintf(buf, 20, "%s\n",
+		h->transMethod & CFGTBL_Trans_Performant ?
+			"performant" : "simple");
+}
+static DEVICE_ATTR(transport_mode, S_IRUGO, host_show_transport_mode, NULL);
+
 static ssize_t dev_show_unique_id(struct device *dev,
 				 struct device_attribute *attr,
 				 char *buf)
@@ -813,6 +825,7 @@ static DEVICE_ATTR(usage_count, S_IRUGO, cciss_show_usage_count, NULL);
 static struct attribute *cciss_host_attrs[] = {
 	&dev_attr_rescan.attr,
 	&dev_attr_resettable.attr,
+	&dev_attr_transport_mode.attr,
 	NULL
 };
 


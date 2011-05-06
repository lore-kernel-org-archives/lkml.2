Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab1EFKyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:54:39 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:37670 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756335Ab1EFKyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:54:37 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 12/16] staging: usbip: vhci_sysfs.c: coding style cleanup
Date: Fri,  6 May 2011 03:47:52 -0700
Message-Id: <dc9256b9b85be6dffa8926cb4f18c02588b53d6f.1304676742.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1304676742.git.mfm@muteddisk.com>
References: <cover.1304676742.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few alignment issues and remove extraneous lines.
Add braces to else clause.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/vhci_sysfs.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
index e2dadbd..be851d8 100644
--- a/drivers/staging/usbip/vhci_sysfs.c
+++ b/drivers/staging/usbip/vhci_sysfs.c
@@ -53,20 +53,19 @@ static ssize_t show_status(struct device *dev, struct device_attribute *attr,
 		struct vhci_device *vdev = port_to_vdev(i);
 
 		spin_lock(&vdev->ud.lock);
-
 		out += sprintf(out, "%03u %03u ", i, vdev->ud.status);
 
 		if (vdev->ud.status == VDEV_ST_USED) {
 			out += sprintf(out, "%03u %08x ",
-					vdev->speed, vdev->devid);
+				       vdev->speed, vdev->devid);
 			out += sprintf(out, "%16p ", vdev->ud.tcp_socket);
 			out += sprintf(out, "%s", dev_name(&vdev->udev->dev));
 
-		} else
+		} else {
 			out += sprintf(out, "000 000 000 0000000000000000 0-0");
+		}
 
 		out += sprintf(out, "\n");
-
 		spin_unlock(&vdev->ud.lock);
 	}
 
@@ -127,6 +126,7 @@ static ssize_t store_detach(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	usbip_dbg_vhci_sysfs("Leave\n");
+
 	return count;
 }
 static DEVICE_ATTR(detach, S_IWUSR, NULL, store_detach);
@@ -183,8 +183,7 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
 	sscanf(buf, "%u %u %u %u", &rhport, &sockfd, &devid, &speed);
 
 	usbip_dbg_vhci_sysfs("rhport(%u) sockfd(%u) devid(%u) speed(%u)\n",
-				rhport, sockfd, devid, speed);
-
+			     rhport, sockfd, devid, speed);
 
 	/* check received parameters */
 	if (valid_args(rhport, speed) < 0)
@@ -199,9 +198,7 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
 
 	/* begin a lock */
 	spin_lock(&the_controller->lock);
-
 	vdev = port_to_vdev(rhport);
-
 	spin_lock(&vdev->ud.lock);
 
 	if (vdev->ud.status != VDEV_ST_NULL) {
@@ -214,7 +211,7 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
 	}
 
 	usbip_uinfo("rhport(%u) sockfd(%d) devid(%u) speed(%u)\n",
-				rhport, sockfd, devid, speed);
+		    rhport, sockfd, devid, speed);
 
 	vdev->devid         = devid;
 	vdev->speed         = speed;
-- 
1.7.5.1


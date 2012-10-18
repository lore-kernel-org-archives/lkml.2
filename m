Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab2JRBxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 21:53:34 -0400
Received: from noserose.net ([66.220.18.76]:37041 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753364Ab2JRBxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 21:53:33 -0400
Date: Wed, 17 Oct 2012 18:53:31 -0700
Message-Id: <d79aad28cf58962d1565c8dcf2b449b005b450ec.1350524227.git.ecashin@coraid.com>
In-Reply-To: <cover.1350524227.git.ecashin@coraid.com>
References: <cover.1350524227.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 6/9] aoe: "payload" sysfs file exports per-AoE-command data transfer size
To: akpm@linux-foundation.org
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The userland aoetools package includes an "aoe-stat" command that
can display a "payload size" column when the aoe driver exports
this information.  Users can quickly see what amount of user data
is transferred inside each AoE command on the network, network
headers excluded.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoeblk.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index d5aa3b8..56736cd 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -98,6 +98,14 @@ static ssize_t aoedisk_show_fwver(struct device *dev,
 
 	return snprintf(page, PAGE_SIZE, "0x%04x\n", (unsigned int) d->fw_ver);
 }
+static ssize_t aoedisk_show_payload(struct device *dev,
+				    struct device_attribute *attr, char *page)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	struct aoedev *d = disk->private_data;
+
+	return snprintf(page, PAGE_SIZE, "%lu\n", d->maxbcnt);
+}
 
 static DEVICE_ATTR(state, S_IRUGO, aoedisk_show_state, NULL);
 static DEVICE_ATTR(mac, S_IRUGO, aoedisk_show_mac, NULL);
@@ -106,12 +114,14 @@ static struct device_attribute dev_attr_firmware_version = {
 	.attr = { .name = "firmware-version", .mode = S_IRUGO },
 	.show = aoedisk_show_fwver,
 };
+static DEVICE_ATTR(payload, S_IRUGO, aoedisk_show_payload, NULL);
 
 static struct attribute *aoe_attrs[] = {
 	&dev_attr_state.attr,
 	&dev_attr_mac.attr,
 	&dev_attr_netif.attr,
 	&dev_attr_firmware_version.attr,
+	&dev_attr_payload.attr,
 	NULL,
 };
 
-- 
1.7.1


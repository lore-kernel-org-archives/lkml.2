Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab2CJHEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 02:04:01 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:39520 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704Ab2CJHDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 02:03:30 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 37/37] PCI, sysfs: Prepare to kill pci device rescan
Date: Fri,  9 Mar 2012 23:00:37 -0800
Message-Id: <1331362837-10740-38-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090209.4F5AFCBF.0041,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hope we can kill it after one year.

Print warning to catch real users for that feature.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 Documentation/feature-removal-schedule.txt |    9 +++++++++
 drivers/pci/pci-sysfs.c                    |    3 +++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index a0ffac0..1b984a1 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -299,6 +299,15 @@ Why:	In 2.6.27, the semantics of /sys/bus/pci/slots was redefined to
 	fakephp interface.
 Who:	Alex Chiang <achiang@hp.com>
 
+-----------------------------
+
+What:	/sys/bus/pci/devices/.../rescan
+When:	April 2013
+Why:	That rescan will rescan pci parent's bus. It is confusing.
+	Now we have bridge rescan_bridge and bus rescan, and they could
+	be used on exact device and bus that need to be rescaned.
+Who:	Yinghai Lu <yinghai@kernel.org>
+
 ---------------------------
 
 What:	CONFIG_RFKILL_INPUT
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index fc0a7de..c180455 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -320,6 +320,9 @@ dev_rescan_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	if (val) {
+		printk(KERN_WARNING "rescan with pci device will be removed "
+			 "shortly, please use bridge rescan_bridge\n"
+			 "or bus/rescan instead\n");
 		mutex_lock(&pci_remove_rescan_mutex);
 		pci_rescan_bus(pdev->bus);
 		mutex_unlock(&pci_remove_rescan_mutex);
-- 
1.7.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab2CJHDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 02:03:36 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:39498 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2CJHDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 02:03:25 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 35/37] PCI: Make /sys/bus/pci/rescan rescan root
Date: Fri,  9 Mar 2012 23:00:35 -0800
Message-Id: <1331362837-10740-36-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F5AFCBA.006D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will rediscover removed pci root buses.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci-sysfs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 4d122cb..fc0a7de 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -284,6 +284,7 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
 
 #ifdef CONFIG_HOTPLUG
 static DEFINE_MUTEX(pci_remove_rescan_mutex);
+void __weak arch_pci_root_rescan(void) { }
 static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
 				size_t count)
 {
@@ -295,6 +296,7 @@ static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
 
 	if (val) {
 		mutex_lock(&pci_remove_rescan_mutex);
+		arch_pci_root_rescan();
 		while ((b = pci_find_next_bus(b)) != NULL)
 			pci_rescan_bus(b);
 		mutex_unlock(&pci_remove_rescan_mutex);
-- 
1.7.7


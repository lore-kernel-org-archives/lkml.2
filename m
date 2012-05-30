Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab2E3FMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 01:12:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab2E3FKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 01:10:21 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 1/7] driver core: Add iommu_group tracking to struct device
To: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, benh@kernel.crashing.org, aik@ozlabs.ru,
        david@gibson.dropbear.id.au, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        gregkh@linuxfoundation.org, ddutile@redhat.com,
        alex.williamson@redhat.com
Date: Tue, 29 May 2012 23:10:08 -0600
Message-ID: <20120530051007.1543.81765.stgit@bling.home>
In-Reply-To: <20120530045150.1543.73660.stgit@bling.home>
References: <20120530045150.1543.73660.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU groups allow IOMMU drivers to represent DMA visibility
and isolation of devices.  Multiple devices may be grouped
together for the purposes of DMA.  Placing a pointer on
struct device enable easy access for things like streaming
DMA programming and drivers like VFIO.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

 include/linux/device.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/device.h b/include/linux/device.h
index 161d962..d0e4d99 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -36,6 +36,7 @@ struct subsys_private;
 struct bus_type;
 struct device_node;
 struct iommu_ops;
+struct iommu_group;
 
 struct bus_attribute {
 	struct attribute	attr;
@@ -687,6 +688,7 @@ struct device {
 	const struct attribute_group **groups;	/* optional groups */
 
 	void	(*release)(struct device *dev);
+	struct iommu_group	*iommu_group;
 };
 
 /* Get the wakeup routines, which depend on struct device */


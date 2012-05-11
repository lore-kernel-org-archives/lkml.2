Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab2EKW4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:56:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab2EKWz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:55:59 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 01/13] driver core: Add iommu_group tracking to struct device
To: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org
Cc: chrisw@sous-sol.org, agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, alex.williamson@redhat.com
Date: Fri, 11 May 2012 16:55:35 -0600
Message-ID: <20120511225534.30496.54563.stgit@bling.home>
In-Reply-To: <20120511222148.30496.68571.stgit@bling.home>
References: <20120511222148.30496.68571.stgit@bling.home>
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
---

 include/linux/device.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 5ad17cc..13dd26b 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -35,6 +35,7 @@ struct subsys_private;
 struct bus_type;
 struct device_node;
 struct iommu_ops;
+struct iommu_group;
 
 struct bus_attribute {
 	struct attribute	attr;
@@ -677,6 +678,7 @@ struct device {
 	const struct attribute_group **groups;	/* optional groups */
 
 	void	(*release)(struct device *dev);
+	struct iommu_group	*iommu_group;
 };
 
 /* Get the wakeup routines, which depend on struct device */


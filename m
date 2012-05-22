Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab2EVFFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 01:05:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab2EVFE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 01:04:59 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 01/13] driver core: Add iommu_group tracking to struct
 device
To: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org
Cc: chrisw@sous-sol.org, agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, ddutile@redhat.com, alex.williamson@redhat.com
Date: Mon, 21 May 2012 23:04:39 -0600
Message-ID: <20120522050438.5871.56283.stgit@bling.home>
In-Reply-To: <20120522043607.5871.11340.stgit@bling.home>
References: <20120522043607.5871.11340.stgit@bling.home>
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab2F1IHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 04:07:45 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45856 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab2F1IHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 04:07:38 -0400
Date: Thu, 28 Jun 2012 11:07:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, walter harms <wharms@bfs.de>
Subject: [patch 1/3 v2] vfio: signedness bug in vfio_config_do_rw()
Message-ID: <20120628080725.GA22595@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEC0480.7010508@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "count" variable needs to be signed here because we use it to store
negative error codes.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Just declare count as signed.

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index a4f7321..2e00aa8 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1419,7 +1419,7 @@ void vfio_config_free(struct vfio_pci_device *vdev)
 }
 
 static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
-				 size_t count, loff_t *ppos, bool iswrite)
+				 ssize_t count, loff_t *ppos, bool iswrite)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct perm_bits *perm;

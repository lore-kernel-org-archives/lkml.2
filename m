Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0J3Q7Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 12:59:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab0J3Q7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 12:59:13 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 1/5] vfio: Fix the ROM mask
To: pugs@cisco.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, chrisw@redhat.com, mst@redhat.com,
        alex.williamson@redhat.com
Date: Sat, 30 Oct 2010 10:59:11 -0600
Message-ID: <20101030165901.885.82395.stgit@s20.home>
In-Reply-To: <20101030164626.885.89216.stgit@s20.home>
References: <20101030164626.885.89216.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OR in the enable address, don't set the whole mask with it.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/vfio/vfio_pci_config.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/vfio/vfio_pci_config.c b/drivers/vfio/vfio_pci_config.c
index 88deb19..8af995d 100644
--- a/drivers/vfio/vfio_pci_config.c
+++ b/drivers/vfio/vfio_pci_config.c
@@ -797,7 +797,7 @@ static void vfio_bar_fixup(struct vfio_dev *vdev)
 
 	if (pci_resource_start(pdev, PCI_ROM_RESOURCE)) {
 		mask = ~(pci_resource_len(pdev, PCI_ROM_RESOURCE) - 1);
-		mask = PCI_ROM_ADDRESS_ENABLE;
+		mask |= PCI_ROM_ADDRESS_ENABLE;
 	} else
 		mask = 0;
 	lp = (u32 *)(vdev->vconfig + PCI_ROM_ADDRESS);


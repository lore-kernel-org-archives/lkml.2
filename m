Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030497Ab2HGWic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:38:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56801 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030417Ab2HGWiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:38:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 042/109] iommu/amd: Add missing spin_lock initialization
Date: Tue,  7 Aug 2012 15:35:01 -0700
Message-Id: <20120807222046.795181962@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 2c13d47a1a7ee8808796016c617aef25fd1d1925 upstream.

Add missing spin_lock initialization in
amd_iommu_bind_pasid() function and make lockdep happy
again.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu_v2.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -681,6 +681,8 @@ int amd_iommu_bind_pasid(struct pci_dev
 
 	atomic_set(&pasid_state->count, 1);
 	init_waitqueue_head(&pasid_state->wq);
+	spin_lock_init(&pasid_state->lock);
+
 	pasid_state->task         = task;
 	pasid_state->mm           = get_task_mm(task);
 	pasid_state->device_state = dev_state;



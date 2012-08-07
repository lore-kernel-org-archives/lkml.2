Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab2HGXdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:33:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51593 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab2HGWaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:30:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 060/122] iommu/amd: Add missing spin_lock initialization
Date: Tue,  7 Aug 2012 15:25:48 -0700
Message-Id: <20120807221953.708164916@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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



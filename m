Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab1G2RVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:21:13 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39969 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab1G2RVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:21:00 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 2/2]drivers:staging:usbip:vhci_hcd.c change SPIN_LOCK_UNLOCKED to __SPIN_LOCK_UNLOCKED
Date: Fri, 29 Jul 2011 10:20:37 -0700
Message-Id: <1311960037-9581-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311960037-9581-1-git-send-email-justinmattock@gmail.com>
References: <1311960037-9581-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>


The patch below updates SPIN_LOCK_UNLOCKED to __SPIN_LOCK_UNLOCKED since it is 
deprected according to my search results.
Note: Keep in mind I am not sure if this is the correct change for this(still learning)
even though it's commented out and such.(figured to give this a try and see).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/usbip/vhci_hcd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 2ee97e2..8426be8 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -934,14 +934,14 @@ static void vhci_device_init(struct vhci_device *vdev)
 
 	vdev->ud.side   = USBIP_VHCI;
 	vdev->ud.status = VDEV_ST_NULL;
-	/* vdev->ud.lock   = SPIN_LOCK_UNLOCKED; */
+	/* vdev->ud.lock   = __SPIN_LOCK_UNLOCKED(ud.lock); */
 	spin_lock_init(&vdev->ud.lock);
 
 	INIT_LIST_HEAD(&vdev->priv_rx);
 	INIT_LIST_HEAD(&vdev->priv_tx);
 	INIT_LIST_HEAD(&vdev->unlink_tx);
 	INIT_LIST_HEAD(&vdev->unlink_rx);
-	/* vdev->priv_lock = SPIN_LOCK_UNLOCKED; */
+	/* vdev->priv_lock = __SPIN_LOCK_UNLOCKED(priv_lock); */
 	spin_lock_init(&vdev->priv_lock);
 
 	init_waitqueue_head(&vdev->waitq_tx);
-- 
1.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933935Ab1D2WGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:06:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761015Ab1D2WGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:06:03 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] vfio: Fix free in dma mapping error path
To: pugs@ieee.org
Cc: alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, qemu-devel@nongnu.org, chrisw@redhat.com
Date: Fri, 29 Apr 2011 16:05:54 -0600
Message-ID: <20110429220534.10316.63083.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is allocated via vmalloc, so needs vfree, not kfree.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/vfio/vfio_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/vfio/vfio_dma.c b/drivers/vfio/vfio_dma.c
index cee1a25..4a488b6 100644
--- a/drivers/vfio/vfio_dma.c
+++ b/drivers/vfio/vfio_dma.c
@@ -322,7 +322,7 @@ int vfio_dma_map_common(struct vfio_listener *listener,
 	if (ret != npage) {
 		printk(KERN_ERR "%s: get_user_pages_fast returns %d, not %d\n",
 			__func__, ret, npage);
-		kfree(pages);
+		vfree(pages);
 		ret = -EFAULT;
 		goto out_lock;
 	}


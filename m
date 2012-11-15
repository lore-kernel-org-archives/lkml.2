Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768487Ab2KOQoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:44:44 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55490 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768408Ab2KOQom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:44:42 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Joerg Roedel <joerg.roedel@amd.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH v2 3/3] VFIO: fix out of order labels for error recovery in vfio_pci_init()
Date: Fri, 16 Nov 2012 00:43:18 +0800
Message-Id: <1352997798-18891-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352997798-18891-1-git-send-email-jiang.liu@huawei.com>
References: <1352997798-18891-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two labels for error recovery in function vfio_pci_init() is out of
order, so fix it.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/vfio/pci/vfio_pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 6968b72..d07fb7e 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -563,9 +563,9 @@ static int __init vfio_pci_init(void)
 
 	return 0;
 
-out_virqfd:
-	vfio_pci_virqfd_exit();
 out_driver:
+	vfio_pci_virqfd_exit();
+out_virqfd:
 	vfio_pci_uninit_perm_bits();
 	return ret;
 }
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab2JKBK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:10:58 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49671 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab2JKBKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:10:54 -0400
MIME-Version: 1.0
Date: Thu, 11 Oct 2012 09:10:53 +0800
Message-ID: <CAPgLHd-GzSDQ+E-zboLA8RfbOVk5bHFK+NTDe2WkWihVFVCtmA@mail.gmail.com>
Subject: [PATCH] virtio-pci: use module_pci_driver to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: rusty@rustcorp.com.au, mst@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use the module_pci_driver() macro to make the code simpler
by eliminating module_init and module_exit calls.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/virtio/virtio_pci.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index c33aea3..b59237c 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -830,16 +830,4 @@ static struct pci_driver virtio_pci_driver = {
 #endif
 };
 
-static int __init virtio_pci_init(void)
-{
-	return pci_register_driver(&virtio_pci_driver);
-}
-
-module_init(virtio_pci_init);
-
-static void __exit virtio_pci_exit(void)
-{
-	pci_unregister_driver(&virtio_pci_driver);
-}
-
-module_exit(virtio_pci_exit);
+module_pci_driver(virtio_pci_driver);



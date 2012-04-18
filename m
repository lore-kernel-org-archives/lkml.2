Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab2DROCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:02:13 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40099 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab2DROCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:02:11 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-pcmcia@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/pcmcia/electra_cf.c: add missing iounmap and kfree
Date: Wed, 18 Apr 2012 16:02:02 +0200
Message-Id: <1334757722-16187-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

cf and cf->mem_base have been allocated at the point of this failure, so
they should be freed before leaving the function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
I'm not sure to understand how the call to device_init_wakeup(&ofdev->dev,
0); fits in, but there seems to be no reason why this would more
appropriate in the error case a few lines below than in the error case here.

 drivers/pcmcia/electra_cf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pcmcia/electra_cf.c b/drivers/pcmcia/electra_cf.c
index 7647d23..558d706 100644
--- a/drivers/pcmcia/electra_cf.c
+++ b/drivers/pcmcia/electra_cf.c
@@ -214,8 +214,10 @@ static int __devinit electra_cf_probe(struct platform_device *ofdev)
 	cf->io_size = PAGE_ALIGN(resource_size(&io));
 
 	area = __get_vm_area(cf->io_size, 0, PHB_IO_BASE, PHB_IO_END);
-	if (area == NULL)
-		return -ENOMEM;
+	if (area == NULL) {
+		status = -ENOMEM;
+		goto fail1;
+	}
 
 	cf->io_virt = (void __iomem *)(area->addr);
 


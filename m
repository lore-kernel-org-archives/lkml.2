Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab0G1Qjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:39:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55220 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab0G1Qjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:39:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FXQFf5jD8srYrDbAS3lqxnlgBUK2Ewh/xupoIQ2sDWVUJLWL/XxmZO3VOiQ48BnaM1
         igV5Ci8wlI81Cq4u+UMGcre8sNOH+fqdBf557OOxAoiG37zSDSxwmjjbnE0oVCfVrJ9f
         U1EvIr69lOZyoDR7urTdJ/9GkOta7paMO+670=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Tejun Heo <tj@kernel.org>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] sh: dma: check return value of create_proc_read_entry()
Date: Wed, 28 Jul 2010 20:39:26 +0400
Message-Id: <1280335166-23225-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_proc_read_entry() may fail, if so return -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/sh/drivers/dma/dma-api.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh/drivers/dma/dma-api.c b/arch/sh/drivers/dma/dma-api.c
index 4a27722..f46848f 100644
--- a/arch/sh/drivers/dma/dma-api.c
+++ b/arch/sh/drivers/dma/dma-api.c
@@ -412,8 +412,8 @@ EXPORT_SYMBOL(unregister_dmac);
 static int __init dma_api_init(void)
 {
 	printk(KERN_NOTICE "DMA: Registering DMA API.\n");
-	create_proc_read_entry("dma", 0, 0, dma_read_proc, 0);
-	return 0;
+	return create_proc_read_entry("dma", 0, 0, dma_read_proc, 0)
+		    ? 0 : -ENOMEM;
 }
 subsys_initcall(dma_api_init);
 
-- 
1.7.0.4


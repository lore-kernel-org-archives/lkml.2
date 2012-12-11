Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab2LKIX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 03:23:26 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33598 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2LKIXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 03:23:25 -0500
Message-ID: <1355214199.7387.3.camel@phoenix>
Subject: [PATCH] mfd: vexpress-config: Export __vexpress_config_func_get and
 vexpress_config_func_put
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Pawel Moll <pawel.moll@arm.com>, linux-kernel@vger.kernel.org
Date: Tue, 11 Dec 2012 16:23:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes below build error:

  Building modules, stage 2.
  MODPOST 17 modules
ERROR: "__vexpress_config_func_get" [drivers/regulator/vexpress.ko] undefined!
ERROR: "vexpress_config_func_put" [drivers/regulator/vexpress.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/mfd/vexpress-config.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/vexpress-config.c b/drivers/mfd/vexpress-config.c
index fae15d8..e6b8cbc 100644
--- a/drivers/mfd/vexpress-config.c
+++ b/drivers/mfd/vexpress-config.c
@@ -142,6 +142,7 @@ struct vexpress_config_func *__vexpress_config_func_get(struct device *dev,
 
 	return func;
 }
+EXPORT_SYMBOL_GPL(__vexpress_config_func_get);
 
 void vexpress_config_func_put(struct vexpress_config_func *func)
 {
@@ -149,6 +150,7 @@ void vexpress_config_func_put(struct vexpress_config_func *func)
 	of_node_put(func->bridge->node);
 	kfree(func);
 }
+EXPORT_SYMBOL_GPL(vexpress_config_func_put);
 
 
 struct vexpress_config_trans {
-- 
1.7.9.5




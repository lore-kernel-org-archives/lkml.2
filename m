Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031460Ab2HIPyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:54:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38732 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031292Ab2HIPyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:54:11 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 6/8] mfd: Use interrupt-parent as IRQ controller if specified in DT
Date: Thu,  9 Aug 2012 16:53:53 +0100
Message-Id: <1344527635-6163-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch the default behaviour is to climb the Device
Tree and use the first encountered interrupt controller. This
does not take into account if a device node has specified to use
a particular IRQ controller using the interrupt-parent property.
This patch ensures that property is adhered to.

CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/mfd-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 0c3a01c..bb5e753 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -97,7 +97,7 @@ static int mfd_add_device(struct device *parent, int id,
 		for_each_child_of_node(parent->of_node, np) {
 			if (of_device_is_compatible(np, cell->of_compatible)) {
 				pdev->dev.of_node = np;
-				domain = irq_find_host(parent->of_node);
+				domain = irq_find_host(np);
 				break;
 			}
 		}
-- 
1.7.9.5


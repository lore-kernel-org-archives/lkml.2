Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab2EYINS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:13:18 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:59676 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756307Ab2EYINF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:13:05 -0400
From: Felipe Balbi <balbi@ti.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de, svadivu@ti.com,
        aneesh@ti.com, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] misc: emif: fix compilation error
Date: Fri, 25 May 2012 11:11:32 +0300
Message-Id: <1337933492-25361-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 99d3eccf (ARM: OMAP4/5: EMIF: Probe
Emif driver with initcall) introduced a compile
error by not removing module_init() when adding
postcore_initcall().

This problem would've been caught by just compiling
the driver as module.

Fix the issue by removing module_init() from the
driver.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/misc/emif.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/misc/emif.c b/drivers/misc/emif.c
index 36fda8e..8725ea9 100644
--- a/drivers/misc/emif.c
+++ b/drivers/misc/emif.c
@@ -1663,7 +1663,6 @@ static void __exit emif_unregister(void)
 }
 
 postcore_initcall(emif_register);
-module_init(emif_register);
 module_exit(emif_unregister);
 MODULE_DESCRIPTION("TI EMIF SDRAM Controller Driver");
 MODULE_LICENSE("GPL");
-- 
1.7.10.2


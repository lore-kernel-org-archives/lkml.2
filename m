Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab2KIFQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 00:16:56 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51773 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab2KIFQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 00:16:54 -0500
Message-ID: <1352438201.23783.1.camel@phoenix>
Subject: [PATCH] mfd: rtsx_pcr: Include linux/slab.h to fix build error
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Wei WANG <wei_wang@realsil.com.cn>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
Date: Fri, 09 Nov 2012 13:16:41 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build error:

  CC [M]  drivers/mfd/rtsx_pcr.o
drivers/mfd/rtsx_pcr.c: In function 'rtsx_pci_init_chip':
drivers/mfd/rtsx_pcr.c:985:2: error: implicit declaration of function 'kcalloc' [-Werror=implicit-function-declaration]
drivers/mfd/rtsx_pcr.c:985:13: warning: assignment makes pointer from integer without a cast [enabled by default]
drivers/mfd/rtsx_pcr.c:993:3: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]
drivers/mfd/rtsx_pcr.c: In function 'rtsx_pci_probe':
drivers/mfd/rtsx_pcr.c:1021:2: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]
drivers/mfd/rtsx_pcr.c:1021:6: warning: assignment makes pointer from integer without a cast [enabled by default]
drivers/mfd/rtsx_pcr.c:1027:9: warning: assignment makes pointer from integer without a cast [enabled by default]
cc1: some warnings being treated as errors
make[2]: *** [drivers/mfd/rtsx_pcr.o] Error 1
make[1]: *** [drivers/mfd] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/mfd/rtsx_pcr.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 56d4377..a510584 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -27,6 +27,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/idr.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/rtsx_pci.h>
-- 
1.7.9.5




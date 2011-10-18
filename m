Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab1JRMGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 08:06:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53163 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab1JRMGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 08:06:51 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, jic23@cam.ac.uk, hemanthv@ti.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCHv2 2/7] input/cma3000_d0x: Check silicon version
Date: Tue, 18 Oct 2011 14:06:31 +0200
Message-Id: <1318939596-27330-3-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1318939596-27330-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1318939596-27330-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve probing of the cma3000 chip, by checking the revision of the
device.

---

v2: Fixes suggested by Jonathan Cameron
	-Remove WhoamI pr_info

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/input/misc/cma3000_d0x.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c
index f2e87e3..3877cbe 100644
--- a/drivers/input/misc/cma3000_d0x.c
+++ b/drivers/input/misc/cma3000_d0x.c
@@ -26,6 +26,8 @@
 
 #include "cma3000_d0x.h"
 
+#define CMA3000_REV         0x10
+
 #define CMA3000_WHOAMI      0x00
 #define CMA3000_REVID       0x01
 #define CMA3000_CTRL        0x02
@@ -366,7 +368,11 @@ struct cma3000_accl_data *cma3000_init(struct device *dev, int irq,
 		error = rev;
 		goto err_free_mem;
 	}
-
+	if (rev != CMA3000_REV) {
+		error = -EINVAL;
+		pr_err("CMA3000 Accelerometer: Unknown Revision %x\n", rev);
+		goto err_free_mem;
+	}
 	pr_info("CMA3000 Accelerometer: Revision %x\n", rev);
 
 	error = request_threaded_irq(irq, NULL, cma3000_thread_irq,
-- 
1.7.7


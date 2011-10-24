Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab1JXUVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 16:21:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59894 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab1JXUV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 16:21:29 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: dmitry.torokhov@gmail.com, grant.likely@secretlab.ca,
        sameo@linux.intel.com, peter.ujfalusi@ti.com, jic23@cam.ac.uk,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, hemanthv@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCHv4 2/6] input/cma3000_d0x: Check silicon version
Date: Mon, 24 Oct 2011 22:21:12 +0200
Message-Id: <1319487676-27181-3-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1319487676-27181-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1319487676-27181-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve probing of the cma3000 chip, by checking the revision of the
device.

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
---

v4: Add ACKs to patch

v2: Fixes suggested by Jonathan Cameron
	-Remove WhoamI pr_info

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/input/misc/cma3000_d0x.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c
index e66036d..97e36fa 100644
--- a/drivers/input/misc/cma3000_d0x.c
+++ b/drivers/input/misc/cma3000_d0x.c
@@ -27,6 +27,8 @@
 
 #include "cma3000_d0x.h"
 
+#define CMA3000_REV         0x10
+
 #define CMA3000_WHOAMI      0x00
 #define CMA3000_REVID       0x01
 #define CMA3000_CTRL        0x02
@@ -420,7 +422,11 @@ struct cma3000_accl_data *cma3000_init(struct device *dev, int irq,
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


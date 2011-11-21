Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab1KUKsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:48:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35475 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab1KUKsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:48:52 -0500
From: Dave Martin <dave.martin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, linux-arm-kernel@lists.infradead.org,
        Dave Martin <dave.martin@linaro.org>
Subject: [PATCH 1/2] ARM: amba: Move definition of struct amba_id to mod_devicetable.h
Date: Mon, 21 Nov 2011 10:48:29 +0000
Message-Id: <1321872510-2562-2-git-send-email-dave.martin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1321872510-2562-1-git-send-email-dave.martin@linaro.org>
References: <1321872510-2562-1-git-send-email-dave.martin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The general kernel infrastructure for adding module alises during
module post processing expects the affected device type
identification structures in a common header
<linux/mod_devicetable.h>.

This patch simple moves struct amba_id to the common header, and
adds the appropriate include in <linux/amba/bus.h>.

Signed-off-by: Dave Martin <dave.martin@linaro.org>
---
 include/linux/amba/bus.h        |    7 +------
 include/linux/mod_devicetable.h |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index fcbbe71..724c69c 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -16,6 +16,7 @@
 
 #include <linux/clk.h>
 #include <linux/device.h>
+#include <linux/mod_devicetable.h>
 #include <linux/err.h>
 #include <linux/resource.h>
 #include <linux/regulator/consumer.h>
@@ -35,12 +36,6 @@ struct amba_device {
 	unsigned int		irq[AMBA_NR_IRQS];
 };
 
-struct amba_id {
-	unsigned int		id;
-	unsigned int		mask;
-	void			*data;
-};
-
 struct amba_driver {
 	struct device_driver	drv;
 	int			(*probe)(struct amba_device *, const struct amba_id *);
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 468819c..83ac071 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -542,4 +542,22 @@ struct isapnp_device_id {
 	kernel_ulong_t driver_data;	/* data private to the driver */
 };
 
+/**
+ * struct amba_id - identifies a device on an AMBA bus
+ * @id: The significant bits if the hardware device ID
+ * @mask: Bitmask specifying which bits of the id field are significant when
+ *	matching.  A driver binds to a device when ((hardware device ID) & mask)
+ *	== id.
+ * @data: Private data used by the driver.
+ */
+struct amba_id {
+	unsigned int		id;
+	unsigned int		mask;
+#ifndef __KERNEL__
+	kernel_ulong_t		data;
+#else
+	void			*data;
+#endif
+};
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
-- 
1.7.4.1


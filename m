Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab0GXQBP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 12:01:15 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34778 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab0GXQBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 12:01:14 -0400
Subject: [PATCH] of/device: Make of_device_make_bus_id() usable by other code.
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 24 Jul 2010 10:01:11 -0600
Message-ID: <20100724160111.7072.68144.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMBA bus should also use of_device_make_bus_id() when populating device
out of device tree data.  This patch makes the function non-static, and
adds a suitable prototype in of_device.h

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/platform.c     |    2 +-
 include/linux/of_device.h |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 94fa719..600d77f 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -508,7 +508,7 @@ EXPORT_SYMBOL(of_unregister_driver);
  * value to derive a unique name.  As a last resort it will use the node
  * name followed by a unique number.
  */
-static void of_device_make_bus_id(struct device *dev)
+void of_device_make_bus_id(struct device *dev)
 {
 	static atomic_t bus_no_reg_magic;
 	struct device_node *node = dev->of_node;
diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index e11a0be..249bc11 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -27,6 +27,9 @@
 
 extern const struct of_device_id *of_match_device(
 	const struct of_device_id *matches, const struct device *dev);
+#if !defined(CONFIG_SPARC)
+extern void of_device_make_bus_id(struct device *dev);
+#endif
 
 /**
  * of_driver_match_device - Tell if a driver's of_match_table matches a device.


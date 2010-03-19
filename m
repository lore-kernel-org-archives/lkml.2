Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab0CSPSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:18:41 -0400
Received: from kroah.org ([198.145.64.141]:45863 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab0CSPSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:18:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/7] uartlite: Fix build on sparc.
Date: Fri, 19 Mar 2010 08:18:32 -0700
Message-Id: <1269011916-8836-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100319151326.GC8541@kroah.com>
References: <20100319151326.GC8541@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

We can get this driver enabled via MFD_TIMBERDALE which only
requires GPIO to be on.

But the of_address_to_resource() function is only present on
powerpc and microblaze, so we have to conditionalize the
CONFIG_OF probing bits on that.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/uartlite.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
index ab2ab3c..f0a6c61 100644
--- a/drivers/serial/uartlite.c
+++ b/drivers/serial/uartlite.c
@@ -19,7 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <asm/io.h>
-#if defined(CONFIG_OF)
+#if defined(CONFIG_OF) && (defined(CONFIG_PPC32) || defined(CONFIG_MICROBLAZE))
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
@@ -581,7 +581,7 @@ static struct platform_driver ulite_platform_driver = {
 /* ---------------------------------------------------------------------
  * OF bus bindings
  */
-#if defined(CONFIG_OF)
+#if defined(CONFIG_OF) && (defined(CONFIG_PPC32) || defined(CONFIG_MICROBLAZE))
 static int __devinit
 ulite_of_probe(struct of_device *op, const struct of_device_id *match)
 {
@@ -631,11 +631,11 @@ static inline void __exit ulite_of_unregister(void)
 {
 	of_unregister_platform_driver(&ulite_of_driver);
 }
-#else /* CONFIG_OF */
-/* CONFIG_OF not enabled; do nothing helpers */
+#else /* CONFIG_OF && (CONFIG_PPC32 || CONFIG_MICROBLAZE) */
+/* Appropriate config not enabled; do nothing helpers */
 static inline int __init ulite_of_register(void) { return 0; }
 static inline void __exit ulite_of_unregister(void) { }
-#endif /* CONFIG_OF */
+#endif /* CONFIG_OF && (CONFIG_PPC32 || CONFIG_MICROBLAZE) */
 
 /* ---------------------------------------------------------------------
  * Module setup/teardown
-- 
1.7.0.2


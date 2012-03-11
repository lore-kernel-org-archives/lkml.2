Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2CKL5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 07:57:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57978 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210Ab2CKL4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 07:56:54 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Rejig struct declarations for stubbed API
Date: Sun, 11 Mar 2012 11:56:50 +0000
Message-Id: <1331467010-5608-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure we have a forward declaration of struct regmap that isn't just
the return value of regmap_init() and make the definition of the
register defaults available.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regmap.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 33d5f1d..14b8252 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -16,11 +16,10 @@
 #include <linux/device.h>
 #include <linux/list.h>
 
-#ifdef CONFIG_REGMAP
-
 struct module;
 struct i2c_client;
 struct spi_device;
+struct regmap;
 
 /* An enum of all the supported cache types */
 enum regcache_type {
@@ -42,6 +41,8 @@ struct reg_default {
 	unsigned int def;
 };
 
+#ifdef CONFIG_REGMAP
+
 /**
  * Configuration for the register map of a device.
  *
-- 
1.7.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab1JXL1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 07:27:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33118 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820Ab1JXL1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 07:27:36 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant@secretlab.ca>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] gpiolib: Provide a definition of struct gpio for the stub gpiolib
Date: Mon, 24 Oct 2011 13:27:29 +0200
Message-Id: <1319455649-4916-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the stub gpio_request_array() much more usable as drivers can
declare struct gpio variables.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/gpio.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 17b5a0d..e885103 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -24,7 +24,6 @@
 #include <linux/errno.h>
 
 struct device;
-struct gpio;
 struct gpio_chip;
 
 /*
@@ -36,6 +35,12 @@ struct gpio_chip;
  * warning when something is wrongly called.
  */
 
+struct gpio {
+	unsigned	gpio;
+	unsigned long	flags;
+	const char	*label;
+};
+
 static inline bool gpio_is_valid(int number)
 {
 	return false;
-- 
1.7.6.3


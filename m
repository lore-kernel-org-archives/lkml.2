Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab0JRWrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 18:47:45 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42983 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161Ab0JRWrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 18:47:35 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, device-drivers-devel@blackfin.uclinux.org,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 2/2] gpio: adp5588-gpio: gpio_start must be signed
Date: Mon, 18 Oct 2010 18:50:18 -0400
Message-Id: <1287442218-7265-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287442218-7265-1-git-send-email-vapier@gentoo.org>
References: <1287442218-7265-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Common code interprets this as a signed value (a negative value is
used to request dynamic ID allocation), so make sure the platform
data has proper types to support that.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/i2c/adp5588.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/i2c/adp5588.h b/include/linux/i2c/adp5588.h
index 8bdd83c..d550679 100644
--- a/include/linux/i2c/adp5588.h
+++ b/include/linux/i2c/adp5588.h
@@ -127,9 +127,9 @@ struct adp5588_kpad_platform_data {
 };
 
 struct adp5588_gpio_platform_data {
-	unsigned gpio_start;		/* GPIO Chip base # */
-	unsigned irq_base;		/* interrupt base # */
-	unsigned pullup_dis_mask;	/* Pull-Up Disable Mask */
+	int gpio_start;		/* GPIO Chip base # */
+	unsigned irq_base;	/* interrupt base # */
+	unsigned pullup_dis_mask; /* Pull-Up Disable Mask */
 	int	(*setup)(struct i2c_client *client,
 				int gpio, unsigned ngpio,
 				void *context);
-- 
1.7.3.1


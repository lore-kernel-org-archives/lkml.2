Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab0JPWdf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 18:33:35 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45209 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756373Ab0JPWde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 18:33:34 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH] gpio: adp5588-gpio: add i2c forward declaration
Date: Sat, 16 Oct 2010 18:33:17 -0400
Message-Id: <1287268397-9881-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Some ADP5588 functions take a pointer to an i2c_client, but if the i2c
header doesn't happen to be included first, we hit the standard "struct
declared inside parameter list" warnings from gcc.  So add a simple
forward decl of the i2c_client struct.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/i2c/adp5588.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/i2c/adp5588.h b/include/linux/i2c/adp5588.h
index 269181b..089d4d9 100644
--- a/include/linux/i2c/adp5588.h
+++ b/include/linux/i2c/adp5588.h
@@ -126,6 +126,8 @@ struct adp5588_kpad_platform_data {
 	const struct adp5588_gpio_platform_data *gpio_data;
 };
 
+struct i2c_client; /* forward declaration */
+
 struct adp5588_gpio_platform_data {
 	unsigned gpio_start;		/* GPIO Chip base # */
 	unsigned pullup_dis_mask;	/* Pull-Up Disable Mask */
-- 
1.7.3.1


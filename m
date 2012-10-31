Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2JaHAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:00:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:39912 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847Ab2JaHAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:00:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,685,1344236400"; 
   d="scan'208";a="213353595"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 2/2] gpio: do not call __gpio_xxx under !CONFIG_GPIOLIB
Date: Wed, 31 Oct 2012 15:00:55 +0800
Message-Id: <1351666855-23854-2-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351666855-23854-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1351666855-23854-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those functions are availabe only when CONFIG_GPIOLIB is set. So, we
should not call them under !CONFIG_GPIOLIB block.

This would fix following build errros:
include/asm-generic/gpio.h: In function 'gpio_get_value_cansleep':
include/asm-generic/gpio.h:220:2: error: implicit declaration of function '__gpio_get_value'
include/asm-generic/gpio.h: In function 'gpio_set_value_cansleep':
nclude/asm-generic/gpio.h:226:2: error: implicit declaration of function '__gpio_set_value'

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 include/asm-generic/gpio.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index a73272d..704bf5d 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -257,14 +257,13 @@ static inline int gpio_cansleep(unsigned gpio)
 
 static inline int gpio_get_value_cansleep(unsigned gpio)
 {
-	might_sleep();
-	return __gpio_get_value(gpio);
+	WARN_ON(1);
+	return 0;
 }
 
 static inline void gpio_set_value_cansleep(unsigned gpio, int value)
 {
-	might_sleep();
-	__gpio_set_value(gpio, value);
+	WARN_ON(1);
 }
 
 #endif /* !CONFIG_GPIOLIB */
-- 
1.7.7.6


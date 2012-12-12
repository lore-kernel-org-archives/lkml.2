Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab2LLJHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:07:49 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:32865 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab2LLJFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:05:14 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-leds@vger.kernel.org>
Subject: [PATCH v4 3/7] pwm: Correct parameter name in header for *pwm_get() functions
Date: Wed, 12 Dec 2012 10:04:48 +0100
Message-ID: <1355303092-15523-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355303092-15523-1-git-send-email-peter.ujfalusi@ti.com>
References: <1355303092-15523-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To synchronize the header file definition and the actual code. In the code
the consumer parameter is named as con_id, change the header file and replace
consumer -> con_id in the parameter list.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/pwm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 6d661f3..cc908a5 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -174,10 +174,10 @@ struct pwm_device *pwm_request_from_chip(struct pwm_chip *chip,
 struct pwm_device *of_pwm_xlate_with_flags(struct pwm_chip *pc,
 		const struct of_phandle_args *args);
 
-struct pwm_device *pwm_get(struct device *dev, const char *consumer);
+struct pwm_device *pwm_get(struct device *dev, const char *con_id);
 void pwm_put(struct pwm_device *pwm);
 
-struct pwm_device *devm_pwm_get(struct device *dev, const char *consumer);
+struct pwm_device *devm_pwm_get(struct device *dev, const char *con_id);
 void devm_pwm_put(struct device *dev, struct pwm_device *pwm);
 #else
 static inline int pwm_set_chip_data(struct pwm_device *pwm, void *data)
-- 
1.8.0


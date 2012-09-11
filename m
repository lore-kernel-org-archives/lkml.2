Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2IKGH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:07:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60004 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab2IKGHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:07:25 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@avionic-design.de, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH] pwm: Fix compilation error when CONFIG_PWM is not defined
Date: Tue, 11 Sep 2012 11:34:24 +0530
Message-Id: <1347343464-15417-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per Documentation/pwm.txt, PWM_LOOKUP and pwm_add_table are used in
board support files to add PWM chip entries. Currently these
definitions are protected within CONFIG_PWM macro in
include/linux/pwm.h.

Otherwise, we have to add ifdef's in machine file to fix following
compilation error.

error: array type has incomplete element type
error: implicit declaration of function ‘PWM_LOOKUP’ [-Werror=implicit-function-declaration]
error: implicit declaration of function ‘pwm_add_table’ [-Werror=implicit-function-declaration]
error: bit-field ‘<anonymous>’ width not an integer constant

Reported-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 include/linux/pwm.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 21d076c..87e7f45 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -124,6 +124,7 @@ struct pwm_device *pwm_request_from_chip(struct pwm_chip *chip,
 
 struct pwm_device *pwm_get(struct device *dev, const char *consumer);
 void pwm_put(struct pwm_device *pwm);
+#endif
 
 struct pwm_lookup {
 	struct list_head list;
@@ -141,8 +142,10 @@ struct pwm_lookup {
 		.con_id = _con_id,			\
 	}
 
+#ifdef CONFIG_PWM
 void pwm_add_table(struct pwm_lookup *table, size_t num);
-
+#else
+static void pwm_add_table(struct pwm_lookup *table, size_t num) {}
 #endif
 
 #endif /* __LINUX_PWM_H */
-- 
1.7.4.1


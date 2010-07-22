Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab0GVVGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:06:05 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18453 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025Ab0GVVGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:06:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6051"; a="48200666"
From: Gregory Bean <gbean@codeaurora.org>
To: akpm@linux-foundation.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Gregory Bean <gbean@codeaurora.org>,
        Jani Nikula <ext-jani.1.nikula@nokia.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH] gpio: remove spurious gpio_unexport debug error.
Date: Thu, 22 Jul 2010 14:05:58 -0700
Message-Id: <1279832758-25442-1-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make gpio_unexport generate success instead of an -EINVAL
if asked to unexport a line which is not exported, because
the only result of that condition is a pr_debug
which complains of what is really a harmless no-op:
when an unexported gpio is unexported again, nothing happens.
That's not a failure, just a trivial border case.
Since gpio_free calls gpio_unexport unconditionally
and exported gpio lines are uncommon, most calls to
gpio_free with debug flags enabled generate -EINVAL
warnings in the log, causing unnecessary stress.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 drivers/gpio/gpiolib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 3ca3654..b718aea 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -914,7 +914,8 @@ void gpio_unexport(unsigned gpio)
 			status = 0;
 		} else
 			status = -ENODEV;
-	}
+	} else
+		status = 0;
 
 	mutex_unlock(&sysfs_lock);
 done:
-- 
1.7.0.4

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

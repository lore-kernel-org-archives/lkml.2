Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab1LUHEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 02:04:20 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56211 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab1LUHET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 02:04:19 -0500
Message-ID: <4EF18515.9030800@linaro.org>
Date: Wed, 21 Dec 2011 11:04:53 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: linaro-dev@lists.linaro.org
CC: patches@linaro.org, linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: use usleep_range() instead of mdelay()/udelay()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From 00753f3d48c4b6c45c1778c3e37bc9949ed79e77 Mon Sep 17 00:00:00 2001
From: Dmitry Antipov <dmitry.antipov@linaro.org>
Date: Wed, 21 Dec 2011 11:01:42 +0400
Subject: [PATCH] regulator: use usleep_range() instead of mdelay()/udelay()

---
  drivers/regulator/core.c |    7 +------
  1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 938398f..183ded8 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1379,12 +1379,7 @@ static int _regulator_enable(struct regulator_dev *rdev)

  			trace_regulator_enable_delay(rdev_get_name(rdev));

-			if (delay >= 1000) {
-				mdelay(delay / 1000);
-				udelay(delay % 1000);
-			} else if (delay) {
-				udelay(delay);
-			}
+			usleep_range(delay, delay + 1000);

  			trace_regulator_enable_complete(rdev_get_name(rdev));

-- 
1.7.7.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab2KFIax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:30:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:14740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137Ab2KFIaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:30:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,721,1344236400"; 
   d="scan'208";a="215707819"
Subject: [PATCH 5/7] can: janz-ican3: Fix the usage of
 wait_for_completion_timeout
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: wg@grandegger.com, mkl@pengutronix.de
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1352222894.15558.1595.camel@cliu38-desktop-build>
References: <1352222317.15558.1584.camel@cliu38-desktop-build>
	 <1352222480.15558.1587.camel@cliu38-desktop-build>
	 <1352222555.15558.1589.camel@cliu38-desktop-build>
	 <1352222894.15558.1595.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Nov 2012 01:31:37 +0800
Message-ID: <1352223097.15558.1599.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The return value of wait_for_completion_timeout() is always
>= 0 with unsigned int type.

So the condition "ret < 0" or "ret >= 0" is pointless.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/net/can/janz-ican3.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 7edadee..c0bfb0a 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1692,7 +1692,7 @@ static int ican3_get_berr_counter(const struct net_device *ndev,
 		return ret;
 
 	ret = wait_for_completion_timeout(&mod->buserror_comp, HZ);
-	if (ret <= 0) {
+	if (ret == 0) {
 		dev_info(mod->dev, "%s timed out\n", __func__);
 		return -ETIMEDOUT;
 	}
@@ -1718,7 +1718,7 @@ static ssize_t ican3_sysfs_show_term(struct device *dev,
 		return ret;
 
 	ret = wait_for_completion_timeout(&mod->termination_comp, HZ);
-	if (ret <= 0) {
+	if (ret == 0) {
 		dev_info(mod->dev, "%s timed out\n", __func__);
 		return -ETIMEDOUT;
 	}
-- 
1.7.0.4




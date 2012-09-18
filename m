Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab2IRBp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 21:45:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51881 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab2IRBpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 21:45:53 -0400
Message-ID: <1347932747.6562.3.camel@phoenix>
Subject: [PATCH] cpufreq: OMAP: Check IS_ERR() instead of NULL for
 omap_device_get_by_hwmod_name
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-omap@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Tue, 18 Sep 2012 09:45:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap_device_get_by_hwmod_name() returns ERR_PTR on error.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/cpufreq/omap-cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index 6e22f44..65f8e9a 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -266,9 +266,9 @@ static int __init omap_cpufreq_init(void)
 	}
 
 	mpu_dev = omap_device_get_by_hwmod_name("mpu");
-	if (!mpu_dev) {
+	if (IS_ERR(mpu_dev)) {
 		pr_warning("%s: unable to get the mpu device\n", __func__);
-		return -EINVAL;
+		return PTR_ERR(mpu_dev);
 	}
 
 	mpu_reg = regulator_get(mpu_dev, "vcc");
-- 
1.7.9.5




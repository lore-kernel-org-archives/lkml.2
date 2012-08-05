Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab2HEUZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 16:25:20 -0400
Received: from gloria.sntech.de ([95.129.55.99]:33285 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab2HEUZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 16:25:19 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: [PATCH] PM / Domains: Only check for errors when calling dev_pm_get_subsys_data
Date: Sun, 5 Aug 2012 22:25:08 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208052225.09503.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1d5fcfec22 (PM / Domains: Add device domain data reference counter)
added a check for the return value of dev_pm_get_subsys_data.

But this function does not only return error codes but also "1" when a
new object has been created.

So, change the check to only catch real errors.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
against 3.6-rc1

 drivers/base/power/domain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index ba3487c..5959fcb 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -1323,7 +1323,7 @@ int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
 		}
 
 	ret = dev_pm_get_subsys_data(dev);
-	if (ret)
+	if (ret < 0)
 		goto out;
 
 	genpd->device_count++;
-- 
1.7.2.3


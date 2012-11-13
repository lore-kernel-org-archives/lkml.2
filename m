Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2KMItZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:49:25 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:59638 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab2KMItV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:49:21 -0500
X-AuditID: cbfee61b-b7f616d00000319b-86-50a2099024ce
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 2/3] regulator: threat regulators with constant volatage as
 fixed
Date: Tue, 13 Nov 2012 09:48:52 +0100
Message-id: <1352796533-12350-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1352796533-12350-1-git-send-email-m.szyprowski@samsung.com>
References: <1352796533-12350-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t9jQd0JnIsCDFr3Slpc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJ2/ZrDXPCRreL9z8wGxqesXYwcHBICJhKv/up2MXIC
	mWISF+6tZ+ti5OIQEpjOKNH4cT8rhNPOJNG/5gMTSBWbgKFE19suNpBmEQFrib0LfUFqmAVO
	M0pMmrWdDaRGWCBY4sPnf+wgNSwCqhLfZrCChHkFPCSOLjnHCLFXQWLOJBuQMKeAp8Sq/kvM
	ILYQUMm65a+ZJjDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kR7PVn0jsYVzVYHGIU
	4GBU4uFVtFwYIMSaWFZcmXuIUYKDWUmE17weKMSbklhZlVqUH19UmpNafIhRmoNFSZy32SMl
	QEggPbEkNTs1tSC1CCbLxMEp1cDozZwu3BTInn+24/oDW9X5+nNeS4Yad/OcZnIJdetk+FF1
	onhKBhvnUsa1W+Xfxy3K2GDlcvNCzHNZOb6OdTlLjMX2nF7Bct6xuP7Bgj1WB/+brJ1h7Ngm
	t3Zun2JD4+Fpu/oDzjRkc97aXjlN11NHa1uI+LPsN72Vx+ImsnNIPJrx5lL5tklKLMUZiYZa
	zEXFiQCcSRKy9gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers has additional logic for fixed regulators. Let regulator core
to threat regulators which cannot change their voltage due to applied
constraints as fixed.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/regulator/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 042c1ff..271182e 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1872,7 +1872,10 @@ int regulator_count_voltages(struct regulator *regulator)
 {
 	struct regulator_dev	*rdev = regulator->rdev;
 
-	return rdev->desc->n_voltages ? : -EINVAL;
+	if (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)
+		return rdev->desc->n_voltages ? : -EINVAL;
+	else
+		return 1;
 }
 EXPORT_SYMBOL_GPL(regulator_count_voltages);
 
-- 
1.7.9.5


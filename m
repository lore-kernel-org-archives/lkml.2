Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab2KMItV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:49:21 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:59629 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab2KMItS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:49:18 -0500
X-AuditID: cbfee61b-b7f616d00000319b-50-50a2098d133f
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 1/3] regulator: fix voltage check in
 regulator_is_supported_voltage()
Date: Tue, 13 Nov 2012 09:48:51 +0100
Message-id: <1352796533-12350-2-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1352796533-12350-1-git-send-email-m.szyprowski@samsung.com>
References: <1352796533-12350-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t9jQd1ezkUBBtemi1tc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDIm39rLXrCSrWLRuhvMDYxzWLsYOTkkBEwkVu9ewg5h
	i0lcuLeeDcQWEpjOKNFwTL+LkQvIbmeS+Pr6PTNIgk3AUKLrbRdQEQeHiIC1xN6FviA1zAKn
	GSUmzdoO1iwsEC5xuKcRbCiLgKrE4w/fwXp5BTwk9kx4zA7SKyGgIDFnkg1ImFPAU2JV/yVm
	iL0eEuuWv2aawMi7gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkaw559J72Bc1WBxiFGA
	g1GJh1fRcmGAEGtiWXFl7iFGCQ5mJRFe83qgEG9KYmVValF+fFFpTmrxIUZpDhYlcd5mj5QA
	IYH0xJLU7NTUgtQimCwTB6dUA+PsTae8PuQX8Wa1V+3a+2+Vs/su5v+n9y19xfnw3oTUqjTB
	msAHrMkbEu7v366m02u7wjxE32rdtrvLgnt+MNUvOPul5J+t9y3fjglOfLcc/Zg4dk5d08LL
	uTHecg5raK6T+JQUj/d796V+NRSe2Jxfs/RXoFJKs8LsnZsPmV5Y3O2x9l9mcb0SS3FGoqEW
	c1FxIgA5cXQe+AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_is_supported_voltage() should return true only if the voltage
of fixed/constant regulator is between min_uV and max_uV.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 1a35251..042c1ff 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1974,7 +1974,7 @@ int regulator_is_supported_voltage(struct regulator *regulator,
 	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)) {
 		ret = regulator_get_voltage(regulator);
 		if (ret >= 0)
-			return (min_uV >= ret && ret <= max_uV);
+			return (min_uV <= ret && ret <= max_uV);
 		else
 			return ret;
 	}
-- 
1.7.9.5


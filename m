Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab0LUFEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 00:04:49 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:13329 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab0LUFEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 00:04:48 -0500
Date: Tue, 21 Dec 2010 14:04:39 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 1/2] regulator: max8952 - fix max8952_set_voltage check
 condition.
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1292907880-3353-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 21 Dec 2010 05:04:40.0601 (UTC)
 FILETIME=[92BFD890:01CBA0CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current implementation, the GPIO pin, vid0 is checked twice
(duplicated!) while vid1 is never checked; however, both vid0 and
vid1 should be checked. This patch fixes the typo that stated vid0 where
should've stated vid1.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/max8952.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index 0d5dda4..c7dae2b 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -139,7 +139,7 @@ static int max8952_set_voltage(struct regulator_dev *rdev,
 	s8 vid = -1, i;
 
 	if (!gpio_is_valid(max8952->pdata->gpio_vid0) ||
-			!gpio_is_valid(max8952->pdata->gpio_vid0)) {
+			!gpio_is_valid(max8952->pdata->gpio_vid1)) {
 		/* DVS not supported */
 		return -EPERM;
 	}
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab2DDBeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 21:34:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56518 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab2DDBeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 21:34:13 -0400
From: jhbird.choi@gmail.com
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH] PM / devfreq : Remove duplicate freq check code in exynos4_bus.c
Date: Tue,  3 Apr 2012 21:34:06 -0400
Message-Id: <1333503246-8925-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

New freq & old freq is already checked before exynos42xx_set_busclk().
"if (old_freq == freq) return 0" is existed at the begin of a
exynos4_bus_target().

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/devfreq/exynos4_bus.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
index 88ddc77..d94998c 100644
--- a/drivers/devfreq/exynos4_bus.c
+++ b/drivers/devfreq/exynos4_bus.c
@@ -648,18 +648,17 @@ static int exynos4_bus_target(struct device *dev, unsigned long *_freq,
 	if (err)
 		goto out;
 
-	if (old_freq != freq) {
-		switch (data->type) {
-		case TYPE_BUSF_EXYNOS4210:
-			err = exynos4210_set_busclk(data, opp);
-			break;
-		case TYPE_BUSF_EXYNOS4x12:
-			err = exynos4x12_set_busclk(data, opp);
-			break;
-		default:
-			err = -EINVAL;
-		}
+	switch (data->type) {
+	case TYPE_BUSF_EXYNOS4210:
+		err = exynos4210_set_busclk(data, opp);
+		break;
+	case TYPE_BUSF_EXYNOS4x12:
+		err = exynos4x12_set_busclk(data, opp);
+		break;
+	default:
+		err = -EINVAL;
 	}
+
 	if (err)
 		goto out;
 
-- 
1.7.0.4


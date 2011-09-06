Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab1IFHMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 03:12:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40758 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752840Ab1IFHMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 03:12:39 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?=C3=89ric=20Piel?= <eric.piel@tremplin-utc.net>,
        Ilkka Koskinen <ilkka.koskinen@nokia.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, stable@kernel.org
Subject: [PATCH 1/2] lis3lv02d: Fix read() call in lis3lv02d_get_odr()
Date: Tue,  6 Sep 2011 00:12:28 -0700
Message-Id: <1315293149-3881-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is passing a struct lis3lv02d ** to the read() operation but
the read() operation wants a struct lis3lv02d * causing compiler warnings
and presumably also runtime problems.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@kernel.org
---
 drivers/misc/lis3lv02d/lis3lv02d.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index e67dcea..72a1f92 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -200,7 +200,7 @@ static int lis3lv02d_get_odr(struct lis3lv02d *lis3)
 	u8 ctrl;
 	int shift;
 
-	lis3->read(&lis3, CTRL_REG1, &ctrl);
+	lis3->read(lis3, CTRL_REG1, &ctrl);
 	ctrl &= lis3->odr_mask;
 	shift = ffs(lis3->odr_mask) - 1;
 	return lis3->odrs[(ctrl >> shift)];
-- 
1.7.5.4


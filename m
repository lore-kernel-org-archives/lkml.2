Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1GCBrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 21:47:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42906 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab1GCBrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 21:47:15 -0400
From: Chris Forbes <chrisf@ijw.co.nz>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chris Forbes <chrisf@ijw.co.nz>
Subject: [PATCH] drivers: staging: iio: adc: fix uninitialized use
Date: Sun,  3 Jul 2011 13:47:01 +1200
Message-Id: <1309657621-21711-1-git-send-email-chrisf@ijw.co.nz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed an uninitialized variable access. In the first two error paths in
max1363_probe(), 'st' is not yet initialized, but its 'reg' member is
accessed anyway. This would most likely crash.

The intended value for st->reg *is* available at that point in 'reg',
so just use that directly.

Signed-off-by: Chris Forbes <chrisf@ijw.co.nz>
---
 drivers/staging/iio/adc/max1363_core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/adc/max1363_core.c b/drivers/staging/iio/adc/max1363_core.c
index 98cebd2..ebecf14 100644
--- a/drivers/staging/iio/adc/max1363_core.c
+++ b/drivers/staging/iio/adc/max1363_core.c
@@ -1335,11 +1335,11 @@ error_free_device:
 	else
 		iio_device_unregister(indio_dev);
 error_disable_reg:
-	if (!IS_ERR(st->reg))
-		regulator_disable(st->reg);
+	if (!IS_ERR(reg))
+		regulator_disable(reg);
 error_put_reg:
-	if (!IS_ERR(st->reg))
-		regulator_put(st->reg);
+	if (!IS_ERR(reg))
+		regulator_put(reg);
 
 	return ret;
 }
-- 
1.7.4.1


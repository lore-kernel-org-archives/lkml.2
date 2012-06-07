Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781Ab2FGIZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:25:36 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:53494 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752032Ab2FGIZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:25:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAPdk0E9bdWOb/2dsb2JhbABFhU6uToEHghkBBSMECwFGECUCJgICVwcSiA+mFJJlgSOOcIESA5UdiSOGV4Ji
X-IronPort-AV: E=Sophos;i="4.75,730,1330902000"; 
   d="scan'208";a="923788894"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: gregkh@linuxfoundation.org, siglesias@igalia.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 2/9] Staging: ipack/bridges/tpci200: remove "out" label in tpci200_slot_map_space()
Date: Thu,  7 Jun 2012 10:24:51 +0200
Message-Id: <1339057498-5256-2-git-send-email-magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339057498-5256-1-git-send-email-magomez@igalia.com>
References: <1339057498-5256-1-git-send-email-magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the "out" label from tpci200_slot_map_space(), as it can directly return
the error code instead of jumping.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 31f6b5d..3eaf387 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -625,15 +625,11 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 	struct tpci200_board *tpci200;
 
 	tpci200 = check_slot(dev);
-	if (tpci200 == NULL) {
-		res = -EINVAL;
-		goto out;
-	}
+	if (tpci200 == NULL)
+		return -EINVAL;
 
-	if (mutex_lock_interruptible(&tpci200->mutex)) {
-		res = -ERESTARTSYS;
-		goto out;
-	}
+	if (mutex_lock_interruptible(&tpci200->mutex))
+		return -ERESTARTSYS;
 
 	switch (space) {
 	case IPACK_IO_SPACE:
@@ -698,7 +694,6 @@ static int tpci200_slot_map_space(struct ipack_device *dev,
 
 out_unlock:
 	mutex_unlock(&tpci200->mutex);
-out:
 	return res;
 }
 
-- 
1.7.9.5


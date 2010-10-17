Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab0JQGVp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 02:21:45 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:38081 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863Ab0JQGVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 02:21:44 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        steven miao <realmz6@gmail.com>
Subject: [PATCH] ad525x_dpot: use correct rdac channel for ad5251/ad5252
Date: Sun, 17 Oct 2010 02:24:02 -0400
Message-Id: <1287296642-23207-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: steven miao <realmz6@gmail.com>

The ad5251/ad5252 devices have rdac1 and rdac3, but no rdac0.  So make
sure we use the right channels so userspace gets correct data and not
just garbage.

Signed-off-by: steven miao <realmz6@gmail.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/misc/ad525x_dpot.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ad525x_dpot.h b/drivers/misc/ad525x_dpot.h
index 78b89fd..5f4f3d7 100644
--- a/drivers/misc/ad525x_dpot.h
+++ b/drivers/misc/ad525x_dpot.h
@@ -47,9 +47,9 @@ enum dpot_devid {
 	AD5258_ID = DPOT_CONF(F_RDACS_RW_TOL, BRDAC0, 6, 0), /* I2C */
 	AD5259_ID = DPOT_CONF(F_RDACS_RW_TOL, BRDAC0, 8, 1),
 	AD5251_ID = DPOT_CONF(F_RDACS_RW_TOL | F_CMD_INC,
-			BRDAC0 | BRDAC3, 6, 2),
+			BRDAC1 | BRDAC3, 6, 2),
 	AD5252_ID = DPOT_CONF(F_RDACS_RW_TOL | F_CMD_INC,
-			BRDAC0 | BRDAC3, 8, 3),
+			BRDAC1 | BRDAC3, 8, 3),
 	AD5253_ID = DPOT_CONF(F_RDACS_RW_TOL | F_CMD_INC,
 			BRDAC0 | BRDAC1 | BRDAC2 | BRDAC3, 6, 4),
 	AD5254_ID = DPOT_CONF(F_RDACS_RW_TOL | F_CMD_INC,
-- 
1.7.3.1


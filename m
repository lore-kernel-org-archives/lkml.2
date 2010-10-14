Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab0JNJGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:06:49 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:57094 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab0JNJGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:06:31 -0400
Cc: linux-kernel@vger.kernel.org, ddbua@analog.com, drivers@analog.com,
        mike.frysinger@analog.com, chrisv@cyberswitching.com,
        Michael Hennerich <michael.hennerich@analog.com>
X-IronPort-AV: E=Sophos;i="4.57,329,1283745600"; 
   d="scan'208";a="23340937"
From: <michael.hennerich@analog.com>
To: akpm@linux-foundation.org
Subject: [PATCH 2/3] drivers: misc: ad525x_dpot: Fix part name typos in defines
Date: Thu, 14 Oct 2010 10:59:47 +0200
Message-ID: <1287046788-25122-2-git-send-email-michael.hennerich@analog.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1287046788-25122-1-git-send-email-michael.hennerich@analog.com>
References: <1287046788-25122-1-git-send-email-michael.hennerich@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>


Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
---
 drivers/misc/ad525x_dpot.c |   10 +++++-----
 drivers/misc/ad525x_dpot.h |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index 5e6fa84..9698c75 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -166,7 +166,7 @@ static s32 dpot_read_i2c(struct dpot_data *dpot, u8 reg)
 	case DPOT_UID(AD5280_ID):
 	case DPOT_UID(AD5282_ID):
 		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
-			0 : DPOT_AD5291_RDAC_AB;
+			0 : DPOT_AD5282_RDAC_AB;
 		return dpot_read_r8d8(dpot, ctrl);
 	case DPOT_UID(AD5170_ID):
 	case DPOT_UID(AD5171_ID):
@@ -175,7 +175,7 @@ static s32 dpot_read_i2c(struct dpot_data *dpot, u8 reg)
 	case DPOT_UID(AD5172_ID):
 	case DPOT_UID(AD5173_ID):
 		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
-			0 : DPOT_AD5272_3_A0;
+			0 : DPOT_AD5172_3_A0;
 		return dpot_read_r8d8(dpot, ctrl);
 	default:
 		if ((reg & DPOT_REG_TOL) || (dpot->max_pos > 256))
@@ -273,7 +273,7 @@ static s32 dpot_write_i2c(struct dpot_data *dpot, u8 reg, u16 value)
 	case DPOT_UID(AD5280_ID):
 	case DPOT_UID(AD5282_ID):
 		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
-			0 : DPOT_AD5291_RDAC_AB;
+			0 : DPOT_AD5282_RDAC_AB;
 		return dpot_write_r8d8(dpot, ctrl, value);
 		break;
 	case DPOT_UID(AD5171_ID):
@@ -289,12 +289,12 @@ static s32 dpot_write_i2c(struct dpot_data *dpot, u8 reg, u16 value)
 	case DPOT_UID(AD5172_ID):
 	case DPOT_UID(AD5173_ID):
 		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
-			0 : DPOT_AD5272_3_A0;
+			0 : DPOT_AD5172_3_A0;
 		if (reg & DPOT_ADDR_OTP) {
 			tmp = dpot_read_r8d16(dpot, ctrl);
 			if (tmp >> 14) /* Ready to Program? */
 				return -EFAULT;
-			ctrl |= DPOT_AD5270_2_3_FUSE;
+			ctrl |= DPOT_AD5170_2_3_FUSE;
 		}
 		return dpot_write_r8d8(dpot, ctrl, value);
 		break;
diff --git a/drivers/misc/ad525x_dpot.h b/drivers/misc/ad525x_dpot.h
index 78b89fd..7609d49 100644
--- a/drivers/misc/ad525x_dpot.h
+++ b/drivers/misc/ad525x_dpot.h
@@ -166,14 +166,14 @@ enum dpot_devid {
 #define DPOT_AD5291_RDAC	0x01
 #define DPOT_AD5291_READ_RDAC	0x02
 
-/* AD524x use special commands */
 #define DPOT_AD5291_RDAC_AB	0x80
 
+#define DPOT_AD5282_RDAC_AB	0x80
 #define DPOT_AD5273_FUSE	0x80
-#define DPOT_AD5270_2_3_FUSE	0x20
-#define DPOT_AD5270_2_3_OW	0x08
-#define DPOT_AD5272_3_A0	0x08
-#define DPOT_AD5270_2FUSE	0x80
+#define DPOT_AD5170_2_3_FUSE	0x20
+#define DPOT_AD5170_2_3_OW	0x08
+#define DPOT_AD5172_3_A0	0x08
+#define DPOT_AD5170_2FUSE	0x80
 
 struct dpot_data;
 
-- 
1.6.0.2


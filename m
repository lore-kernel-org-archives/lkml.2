Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0JNM4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 08:56:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49714 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab0JNM4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 08:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OHjBxJIsblQnjuB8jMi6KkI2pyYXuDQ1bkOQxdAR9d06CUuM/BwGGvVarGlPQjlbHj
         QiEBTA4gihmAeGQgF9bC5l2pHKmX2hziKUDWPa/jF0dohSUM/eoS6XNJd/19V0QhzlXR
         of3B2mbsyUEyHSfeSFuwbaYYwVjYry3cKYvas=
From: zhangyd <zhangyd6@gmail.com>
To: dwmw2@infradead.org
Cc: w.sang@pengutronix.de, Artem.Bityutskiy@nokia.com, jkosina@suse.cz,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyd <zhangyd6@gmail.com>
Subject: [PATCH] [MTD] [CHIPS]  Add JEDEC probe support for the SST38VF6401 flash chip
Date: Wed, 13 Oct 2010 13:19:29 -0400
Message-Id: <1286990369-5165-1-git-send-email-zhangyd6@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SST38VF6401(8Mbit) chip to jedec_probe.

Signed-off-by: yidong zhang<zhangyd6@gmail.com>
---
 drivers/mtd/chips/jedec_probe.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index d72a5fb..b7a1016 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -163,6 +163,7 @@
 #define SST49LF030A	0x001C
 #define SST49LF040A	0x0051
 #define SST49LF080A	0x005B
+#define SST38VF6401	0x536B
 #define SST36VF3203	0x7354
 
 /* Toshiba */
@@ -1569,6 +1570,18 @@ static const struct amd_flash_info jedec_table[] = {
 		}
 	}, {
 		.mfr_id		= CFI_MFR_ST,
+		.dev_id		= SST38VF6401,
+		.name		= "SST 38VF6401",
+		.devtypes	= CFI_DEVICETYPE_X16,
+		.uaddr		= MTD_UADDR_0X0AAA_0x555,
+		.dev_size	= SIZE_8MiB,
+		.cmd_set	= P_ID_AMD_STD,
+		.nr_regions	= 1,
+		.regions	= {
+			ERASEINFO(0x10000,128),
+		}
+	}, {
+		.mfr_id		= CFI_MFR_ST,
 		.dev_id		= M29F800AB,
 		.name		= "ST M29F800AB",
 		.devtypes	= CFI_DEVICETYPE_X16|CFI_DEVICETYPE_X8,
-- 
1.7.2.3


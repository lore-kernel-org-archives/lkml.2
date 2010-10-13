Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0JON22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:28:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48626 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab0JON21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:28:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cZnJBb+pDRh+Q0fm2N+BRVgmNQ8/H5Z+eVJbt7sqrXcANhl5sT7QM/IAgJQbt2VApn
         vdwv/kHC4n4Ea6XcgLiQbUIc0OpoIeyASzpE5yumjLJ5r5XVVG3AHoX2B+UFjbG7btQr
         EPVRGbl1kHFeaabjQram2uCvQDHbZ9I8l0vbM=
From: zhangyd <zhangyd6@gmail.com>
To: dwmw2@infradead.org
Cc: w.sang@pengutronix.de, Artem.Bityutskiy@nokia.com, ladis@linux-mips.org,
        jkosina@suse.cz, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyd <zhangyd6@gmail.com>
Subject: [PATCH] [MTD] [CHIPS]  Add JEDEC probe support for the SST38VF6401 flash chip
Date: Wed, 13 Oct 2010 13:54:42 -0400
Message-Id: <1286992482-6009-1-git-send-email-zhangyd6@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SST38VF6401(64Mbit) chip to jedec_probe. Sorry for the wrong description of the flash size in last patch. 

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


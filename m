Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0JROHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:07:38 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44065 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab0JROHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:07:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Rpv51hOVZCj/to8s9/hkdAwuJc1UJPaENwS99wr1DN2VIeL20OmO2q8NIZtSJzpKY8
         KE+nAWGSDE0ghTtmO3+mADtPX2D6m7X710Gvnbd0IejTbrhHq8sp3U0hQSjpFpcpLHLr
         wDi1nofkfp6pSpw9rTGdRxMZAStmYLuc0F8po=
From: zhangyd <zhangyd6@gmail.com>
To: dwmw2@infradead.org
Cc: w.sang@pengutronix.de, Artem.Bityutskiy@nokia.com, ladis@linux-mips.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyd <zhangyd6@gmail.com>
Subject: [PATCH] mtd: chips: Add SST38VF640x NOR-flashes
Date: Mon, 18 Oct 2010 22:06:50 -0400
Message-Id: <1287454010-2718-1-git-send-email-zhangyd6@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Du to the wrong sector size description(The actual sector size is
8KBytes/sector, but the reporting size is 64KBytes/sector),you can get
the wrong size of the memory. So they should be moved to the jedec_probe.

Signed-off-by: yidong zhang<zhangyd6@gmail.com>
---
 drivers/mtd/chips/jedec_probe.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index d72a5fb..0e8df3b 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -163,6 +163,7 @@
 #define SST49LF030A	0x001C
 #define SST49LF040A	0x0051
 #define SST49LF080A	0x005B
+#define SST38VF6401	0x536B
 #define SST36VF3203	0x7354
 
 /* Toshiba */
@@ -1568,6 +1569,16 @@ static const struct amd_flash_info jedec_table[] = {
 			ERASEINFO(0x10000,64),
 		}
 	}, {
+		.mfr_id		= CFI_MFR_SST,
+		.dev_id		= SST38VF6401,
+		.name		= "SST 38VF6401",
+		.devtypes	= CFI_DEVICETYPE_X16,
+		.cmd_set	= P_ID_AMD_STD,
+		.nr_regions	= 1,
+		.regions	= {
+			ERASEINFO(0x10000,128),
+		}
+	}, {
 		.mfr_id		= CFI_MFR_ST,
 		.dev_id		= M29F800AB,
 		.name		= "ST M29F800AB",
-- 
1.7.2.3


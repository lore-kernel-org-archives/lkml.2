Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab2DOVKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 17:10:21 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53457 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751469Ab2DOVKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 17:10:20 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19O08FMLHlOkx2QLcyinRJjkbL4madjTqtldWvriA
	3TasEYN1fe7mT0
From: Peter Huewe <peterhuewe@gmx.de>
To: Thomas Winischhofer <thomas@winischhofer.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 1/2] video/sis: Use SiS_DRAMType from init.h and annotate it __devinitconst
Date: Sun, 15 Apr 2012 23:10:08 +0200
Message-Id: <1334524209-20518-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the duplicated SiS_DRAMType from sis_main.c since it
is already defined exactly the same in init.h.
Since SiS_DRAMType is const and only used by sisfb_post_300_rwtest which is
marked __devinit we can also annotate SiS_DRAMType with __devinitconst.

And since hardcoded values are bad we use ARRAY_SIZE for determining the
size of SiS_DRAMType ;)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/video/sis/init.h     |    2 +-
 drivers/video/sis/sis_main.c |   21 +--------------------
 2 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/video/sis/init.h b/drivers/video/sis/init.h
index aff7384..26ffb3e 100644
--- a/drivers/video/sis/init.h
+++ b/drivers/video/sis/init.h
@@ -105,7 +105,7 @@ static const unsigned short ModeIndex_1920x1440[]    = {0x68, 0x69, 0x00, 0x6b};
 static const unsigned short ModeIndex_300_2048x1536[]= {0x6c, 0x6d, 0x00, 0x00};
 static const unsigned short ModeIndex_310_2048x1536[]= {0x6c, 0x6d, 0x00, 0x6e};
 
-static const unsigned short SiS_DRAMType[17][5]={
+static const unsigned short __devinitconst SiS_DRAMType[17][5] = {
 	{0x0C,0x0A,0x02,0x40,0x39},
 	{0x0D,0x0A,0x01,0x40,0x48},
 	{0x0C,0x09,0x02,0x20,0x35},
diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 078ca21..8abd42b 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -4231,27 +4231,8 @@ sisfb_post_300_rwtest(struct sis_video_info *ivideo, int iteration, int buswidth
 	unsigned short sr14;
 	unsigned int k, RankCapacity, PageCapacity, BankNumHigh, BankNumMid;
 	unsigned int PhysicalAdrOtherPage, PhysicalAdrHigh, PhysicalAdrHalfPage;
-	static const unsigned short SiS_DRAMType[17][5] = {
-		{0x0C,0x0A,0x02,0x40,0x39},
-		{0x0D,0x0A,0x01,0x40,0x48},
-		{0x0C,0x09,0x02,0x20,0x35},
-		{0x0D,0x09,0x01,0x20,0x44},
-		{0x0C,0x08,0x02,0x10,0x31},
-		{0x0D,0x08,0x01,0x10,0x40},
-		{0x0C,0x0A,0x01,0x20,0x34},
-		{0x0C,0x09,0x01,0x08,0x32},
-		{0x0B,0x08,0x02,0x08,0x21},
-		{0x0C,0x08,0x01,0x08,0x30},
-		{0x0A,0x08,0x02,0x04,0x11},
-		{0x0B,0x0A,0x01,0x10,0x28},
-		{0x09,0x08,0x02,0x02,0x01},
-		{0x0B,0x09,0x01,0x08,0x24},
-		{0x0B,0x08,0x01,0x04,0x20},
-		{0x0A,0x08,0x01,0x02,0x10},
-		{0x09,0x08,0x01,0x01,0x00}
-	};
 
-	 for(k = 0; k <= 16; k++) {
+	 for (k = 0; k < ARRAY_SIZE(SiS_DRAMType); k++) {
 
 		RankCapacity = buswidth * SiS_DRAMType[k][3];
 
-- 
1.7.3.4


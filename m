Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab2ECWPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 18:15:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:42608 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755943Ab2ECWPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 18:15:01 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18ZoyFQ3kAZ0yNOXfWM++dV30zIerfsGjNwZbpEUi
	SALb/tkz4TKNvC
From: Peter Huewe <peterhuewe@gmx.de>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Thomas Winischhofer <thomas@winischhofer.net>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] video/sis: Annotate SiS_DRAMType as __devinitconst
Date: Fri,  4 May 2012 00:14:55 +0200
Message-Id: <1336083295-7327-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <4FA2FD10.6090306@gmx.de>
References: <4FA2FD10.6090306@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SiS_DRAMType is const and only used by sisfb_post_300_rwtest which is
marked __devinit we can annotate SiS_DRAMType with __devinitconst and
move it into the file scope in order to not have it created on the
stack.
This patch decreases the compiled module size by about 100bytes.

And since hardcoded values are bad we use ARRAY_SIZE for determining
the size of SiS_DRAMType ;)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/video/sis/sis_main.c |   41 +++++++++++++++++++++--------------------
 1 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 078ca21..a7a48db 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -4222,6 +4222,26 @@ sisfb_post_300_buswidth(struct sis_video_info *ivideo)
 	return 1;			/* 32bit */
 }
 
+static const unsigned short __devinitconst SiS_DRAMType[17][5] = {
+	{0x0C,0x0A,0x02,0x40,0x39},
+	{0x0D,0x0A,0x01,0x40,0x48},
+	{0x0C,0x09,0x02,0x20,0x35},
+	{0x0D,0x09,0x01,0x20,0x44},
+	{0x0C,0x08,0x02,0x10,0x31},
+	{0x0D,0x08,0x01,0x10,0x40},
+	{0x0C,0x0A,0x01,0x20,0x34},
+	{0x0C,0x09,0x01,0x08,0x32},
+	{0x0B,0x08,0x02,0x08,0x21},
+	{0x0C,0x08,0x01,0x08,0x30},
+	{0x0A,0x08,0x02,0x04,0x11},
+	{0x0B,0x0A,0x01,0x10,0x28},
+	{0x09,0x08,0x02,0x02,0x01},
+	{0x0B,0x09,0x01,0x08,0x24},
+	{0x0B,0x08,0x01,0x04,0x20},
+	{0x0A,0x08,0x01,0x02,0x10},
+	{0x09,0x08,0x01,0x01,0x00}
+};
+
 static int __devinit
 sisfb_post_300_rwtest(struct sis_video_info *ivideo, int iteration, int buswidth,
 			int PseudoRankCapacity, int PseudoAdrPinCount,
@@ -4231,27 +4251,8 @@ sisfb_post_300_rwtest(struct sis_video_info *ivideo, int iteration, int buswidth
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
+	 for(k = 0; k < ARRAY_SIZE(SiS_DRAMType); k++) {
 
 		RankCapacity = buswidth * SiS_DRAMType[k][3];
 
-- 
1.7.3.4


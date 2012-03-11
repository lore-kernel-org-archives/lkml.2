Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab2CKNPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 09:15:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36792 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2CKNPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 09:15:42 -0400
From: santosh nayak <santoshprasadnayak@gmail.com>
To: linux@arm.linux.org.uk
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH] Video : Amba: Use in_interrupt() in clcdfb_sleep().
Date: Sun, 11 Mar 2012 18:44:25 +0530
Message-Id: <1331471665-22226-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

Instead of "in_atomic()", we can use in_interrupt() to check whether
its an interrupt context.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/video/amba-clcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/amba-clcd.c b/drivers/video/amba-clcd.c
index 0a2cce7..63c25da 100644
--- a/drivers/video/amba-clcd.c
+++ b/drivers/video/amba-clcd.c
@@ -39,7 +39,7 @@ static const char *clcd_name = "CLCD FB";
  */
 static inline void clcdfb_sleep(unsigned int ms)
 {
-	if (in_atomic()) {
+	if (in_interrupt()) {
 		mdelay(ms);
 	} else {
 		msleep(ms);
-- 
1.7.4.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab2GGGCY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 02:02:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56059 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab2GGGCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 02:02:23 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        wwang <wei_wang@realsil.com.cn>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 1/2] staging/rts_pstor: fix the no brace needed warning
Date: Sat,  7 Jul 2012 11:32:15 +0530
Message-Id: <1341640935-25148-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for if else statements having single block no braces are needed
fixed the following checkpatch warning

drivers/staging/rts_pstor/sd.c:140: WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/rts_pstor/sd.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index b9474a8..ff9bf0f 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -137,11 +137,10 @@ static int sd_check_data0_status(struct rtsx_chip *chip)
 {
 	u8 stat;
 
-	if (CHECK_PID(chip, 0x5209)) {
+	if (CHECK_PID(chip, 0x5209))
 		RTSX_READ_REG(chip, REG_SD_BUS_STAT, &stat);
-	} else {
+	else
 		RTSX_READ_REG(chip, REG_SD_STAT1, &stat);
-	}
 
 	if (!(stat & SD_DAT0_STATUS)) {
 		sd_set_err_code(chip, SD_BUSY);
-- 
1.7.9.5


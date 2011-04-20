Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1DTHO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 03:14:27 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:54573 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1DTHO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 03:14:26 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.07 with qID p3K7EC8A026412, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH] staging: rts_pstor: clear error when read sd lba0 fail
Date: Wed, 20 Apr 2011 15:14:05 +0800
X-BOX-Message-Id: p3K7EC8A026412
Message-ID: <1303283645-8169-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

Call rtsx_clear_sd_error if sd_read_data fail when reading sd lba0.

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/staging/rts_pstor/sd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 21bfa57..cd18abe 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -2227,6 +2227,7 @@ static int sd_read_lba0(struct rtsx_chip *chip)
 	retval = sd_read_data(chip, SD_TM_NORMAL_READ, cmd,
 		5, 512, 1, bus_width, NULL, 0, 100);
 	if (retval != STATUS_SUCCESS) {
+		rtsx_clear_sd_error(chip);
 		TRACE_RET(chip, STATUS_FAIL);
 	}
 
-- 
1.7.4.4


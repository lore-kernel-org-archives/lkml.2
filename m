Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab0JCRWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 13:22:55 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34873 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab0JCRWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 13:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=p6JUoROqd0chwjhXrHNU0D0cMSABGmeitUyW6TkaTwNXTWHWVaBrExmD8gfpgb9UVv
         6wBmUlP4jX6+Zx7p+nbMieaQfCfZL5Ye8UVAdCIigvCvvvknjxO6z7/3i5HryRTmOPpE
         wqyys53xMmKAaM2fX6fI3FOI07hGQ4yAV9WAE=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: ft1000: fix kernel info leak to userland for statistics
Date: Sun,  3 Oct 2010 21:22:48 +0400
Message-Id: <1286126569-20666-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_stat_data is not fully initialized before copy_to_user() call,
e.g. LedStat is not always set.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 65087ce..b666ae6 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -623,7 +623,7 @@ static int ft1000_ChIoctl (struct file *File, unsigned int Command,
         break;
     case IOCTL_GET_DSP_STAT_CMD:
         //DEBUG("FT1000:ft1000_ChIoctl: IOCTL_FT1000_GET_DSP_STAT called\n");
-
+	memset(&get_stat_data, 0, sizeof(get_stat_data));
         memcpy(get_stat_data.DspVer, info->DspVer, DSPVERSZ);
         memcpy(get_stat_data.HwSerNum, info->HwSerNum, HWSERNUMSZ);
         memcpy(get_stat_data.Sku, info->Sku, SKUSZ);
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0I1Rtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:49:43 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44310 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab0I1Rtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:49:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=O4fYRQJ6C2+gzeZMnzMdIwhG0fIetsi2zHz1xmKhXgVXh9aNCJeM4yNuvakrnSh7C8
         JRaR4SBKsgzachq6lOw81yi0DXuSbDJ8DkMx6LBbK42x0zZwOr4atVd5yM5U51HhwoSD
         gLL1kO4ayTroSsqIo6AcmhKHKodIqdoXQCMZQ=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] statistics_write: ft1000: fix kernel info leak to userland
Date: Tue, 28 Sep 2010 21:49:38 +0400
Message-Id: <1285696178-5696-1-git-send-email-segooon@gmail.com>
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
index 65087ce..467fd31 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -623,7 +623,7 @@ static int ft1000_ChIoctl (struct file *File, unsigned int Command,
         break;
     case IOCTL_GET_DSP_STAT_CMD:
         //DEBUG("FT1000:ft1000_ChIoctl: IOCTL_FT1000_GET_DSP_STAT called\n");
-
+	memset(get_stat_data, 0, sizeof(get_stat_data));
         memcpy(get_stat_data.DspVer, info->DspVer, DSPVERSZ);
         memcpy(get_stat_data.HwSerNum, info->HwSerNum, HWSERNUMSZ);
         memcpy(get_stat_data.Sku, info->Sku, SKUSZ);
-- 
1.7.0.4


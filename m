Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab0IMIm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:42:56 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49729 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab0IMIkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JTnQ2JDWB6r+TsEf15T5ndrBGeLI7t7PgBP0X7NnbCvecLOUnFYHHaKBYkZGAesr4Q
         CwYVW6vr3uIn58z+W2UjzGZvljluUQ21x8xsPl+wRhx/dQE2LXkRit7U7rfXZXzkO2Tt
         9E2x1g0dnx9eqysZmNRdY3X1cNGr8vSPY01BI=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCHv2 04/10] staging: cxt1e1: use '%pMF' format to print MAC address
Date: Mon, 13 Sep 2010 11:40:28 +0300
Message-Id: <2b324117556af2fd2070d946955738e33fa706ad.1284316738.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
In-Reply-To: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/cxt1e1/sbeproc.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/cxt1e1/sbeproc.c b/drivers/staging/cxt1e1/sbeproc.c
index 4f4dcd3..c3eed4b 100644
--- a/drivers/staging/cxt1e1/sbeproc.c
+++ b/drivers/staging/cxt1e1/sbeproc.c
@@ -142,9 +142,8 @@ sbecom_proc_get_sbe_info (char *buffer, char **start, off_t offset,
     len += sprintf (buffer + len, "Board Number:  %d\n", bip->brdno);
     len += sprintf (buffer + len, "Hardware ID:   0x%02X\n", ci->hdw_bid);
     len += sprintf (buffer + len, "Board SN:      %06X\n", bip->brd_sn);
-    len += sprintf (buffer + len, "Board MAC:     %02X-%02X-%02X-%02X-%02X-%02X\n",
-           bip->brd_mac_addr[0], bip->brd_mac_addr[1], bip->brd_mac_addr[2],
-          bip->brd_mac_addr[3], bip->brd_mac_addr[4], bip->brd_mac_addr[5]);
+	len += sprintf(buffer + len, "Board MAC:     %pMF\n",
+		bip->brd_mac_addr);
     len += sprintf (buffer + len, "Ports:         %d\n", ci->max_port);
     len += sprintf (buffer + len, "Channels:      %d\n", bip->brd_chan_cnt);
 #if 1
-- 
1.7.2.2


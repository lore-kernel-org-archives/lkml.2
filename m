Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab0IKOTF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 10:19:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50581 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab0IKORg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 10:17:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qCo+k23HY2WNWdfSSkeFnwVv1NcZWcnLXSujWyN6o1JH7lAE2P05WPdtK5vH4MEsmH
         UiBhzO8nP/g1DrYZqPsflWudTmldY8BxG34LnTSq8s3ILYftN9Qo37CF2r6DIkqixBLh
         BsuTzjCCs9mFJAi4u6htxy2PijNFf5nsNMqHg=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 04/10] staging: cxt1e1: use '%pMF' format to print MAC address
Date: Sat, 11 Sep 2010 17:17:07 +0300
Message-Id: <bacc2cf5bd633ae2a0c882c5aad41f194e9730b4.1284214460.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
References: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
In-Reply-To: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
References: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/cxt1e1/sbeproc.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/cxt1e1/sbeproc.c b/drivers/staging/cxt1e1/sbeproc.c
index 4f4dcd3..af8fce4 100644
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
+		&bip->brd_mac_addr[0]);
     len += sprintf (buffer + len, "Ports:         %d\n", ci->max_port);
     len += sprintf (buffer + len, "Channels:      %d\n", bip->brd_chan_cnt);
 #if 1
-- 
1.7.2.2


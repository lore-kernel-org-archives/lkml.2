Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab0IKOSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 10:18:12 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62351 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab0IKORo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 10:17:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XlaMFLF17ShyYqmypUvaiYWPZIug1SDAb9amAsryueyxqYXVw/j7Zrp2l1npCcWW66
         msnuCeUpXDqwE5joOA4NFSGpn3WHKMTA463FH6MpCcJ8O/xPjo4ioN3cKT36dWn9Kfno
         JAPQ0XlOM778WTYccbTBDc1+V6RLBF7PivsWc=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 09/10] staging: vt6655: use '%pM' format to print MAC address
Date: Sat, 11 Sep 2010 17:17:12 +0300
Message-Id: <b1b86b356fdf3bd627c64065bfa047b822b05a9d.1284214460.git.andy.shevchenko@gmail.com>
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
 drivers/staging/vt6655/iwctl.c   |    4 +---
 drivers/staging/vt6655/vntwifi.c |    7 +++----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 4009c0b..d74b744 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -2018,9 +2018,7 @@ param->u.wpa_key.seq_len = seq_len;
 
 #if 0
 printk("param->u.wpa_key.alg_name =%d\n",param->u.wpa_key.alg_name);
-printk("param->addr=%02x:%02x:%02x:%02x:%02x:%02x\n",
-	      param->addr[0],param->addr[1],param->addr[2],
-	      param->addr[3],param->addr[4],param->addr[5]);
+printk(KERN_DEBUG "param->addr=%pM\n", &param->addr[0]);
 printk("param->u.wpa_key.set_tx =%d\n",param->u.wpa_key.set_tx);
 printk("param->u.wpa_key.key_index =%d\n",param->u.wpa_key.key_index);
 printk("param->u.wpa_key.key_len =%d\n",param->u.wpa_key.key_len);
diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index fcf26ab..db9cbe9 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -565,10 +565,9 @@ VNTWIFIvGetTxRate(
 
 		wTxDataRate = (pMgmt->sNodeDBTable[0].wTxDataRate);
 #ifdef	PLICE_DEBUG
-		printk("GetTxRate:AP MAC is %02x:%02x:%02x:%02x:%02x:%02x,TxRate is %d\n",
-				pMgmt->sNodeDBTable[0].abyMACAddr[0],pMgmt->sNodeDBTable[0].abyMACAddr[1],
-				pMgmt->sNodeDBTable[0].abyMACAddr[2],pMgmt->sNodeDBTable[0].abyMACAddr[3],
-				pMgmt->sNodeDBTable[0].abyMACAddr[4],pMgmt->sNodeDBTable[0].abyMACAddr[5],wTxDataRate);
+		printk(KERN_DEBUG "GetTxRate:AP MAC is %pM,TxRate is %d\n",
+				&pMgmt->sNodeDBTable[0].abyMACAddr[0],
+				wTxDataRate);
 #endif
 
 
-- 
1.7.2.2


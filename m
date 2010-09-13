Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab0IMIlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:41:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61289 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab0IMIlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:41:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=raSKgPRS2sotLEfsK1UEZHLMcRRCmYqF9u9HLc49C43c1y/ENFeI6SUerscFsjBtge
         4DxlRgmmILGSGar8MyZ+xqhMMnf2ARMLq9zFCBEZgZpOB4s3rCuZ7TIKu+pfiJtViYP6
         fYciheojrmhheG6x2eqmT1Aua2TyL5GRChzks=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCHv2 09/10] staging: vt6655: use '%pM' format to print MAC address
Date: Mon, 13 Sep 2010 11:40:33 +0300
Message-Id: <0676e32cb45f36ea5cfdb9e5497532622ca37916.1284316740.git.andy.shevchenko@gmail.com>
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
 drivers/staging/vt6655/iwctl.c   |    4 +---
 drivers/staging/vt6655/vntwifi.c |    6 ++----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 4009c0b..92e3399 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -2018,9 +2018,7 @@ param->u.wpa_key.seq_len = seq_len;
 
 #if 0
 printk("param->u.wpa_key.alg_name =%d\n",param->u.wpa_key.alg_name);
-printk("param->addr=%02x:%02x:%02x:%02x:%02x:%02x\n",
-	      param->addr[0],param->addr[1],param->addr[2],
-	      param->addr[3],param->addr[4],param->addr[5]);
+printk(KERN_DEBUG "param->addr=%pM\n", param->addr);
 printk("param->u.wpa_key.set_tx =%d\n",param->u.wpa_key.set_tx);
 printk("param->u.wpa_key.key_index =%d\n",param->u.wpa_key.key_index);
 printk("param->u.wpa_key.key_len =%d\n",param->u.wpa_key.key_len);
diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index fcf26ab..0491d0b 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -565,10 +565,8 @@ VNTWIFIvGetTxRate(
 
 		wTxDataRate = (pMgmt->sNodeDBTable[0].wTxDataRate);
 #ifdef	PLICE_DEBUG
-		printk("GetTxRate:AP MAC is %02x:%02x:%02x:%02x:%02x:%02x,TxRate is %d\n",
-				pMgmt->sNodeDBTable[0].abyMACAddr[0],pMgmt->sNodeDBTable[0].abyMACAddr[1],
-				pMgmt->sNodeDBTable[0].abyMACAddr[2],pMgmt->sNodeDBTable[0].abyMACAddr[3],
-				pMgmt->sNodeDBTable[0].abyMACAddr[4],pMgmt->sNodeDBTable[0].abyMACAddr[5],wTxDataRate);
+		printk(KERN_DEBUG "GetTxRate:AP MAC is %pM,TxRate is %d\n",
+				pMgmt->sNodeDBTable[0].abyMACAddr, wTxDataRate);
 #endif
 
 
-- 
1.7.2.2


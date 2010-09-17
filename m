Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab0IQIZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:25:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63753 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0IQIZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:25:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=luXAD0QoF4ZSLdsZ8pX1xY4MY6XxFeoEVpJpWDutVqbvnWjujRKRXNtMa/i+Bg96Xp
         uhRLtiM5Ey9eUTf4igW5ELm1dCuMD70mTB4bE7lYK3tSxVj7YzG42yLMeUJ2wjpgx7KC
         jxoJohj4afCYB9kfHwcfwtI8TG3JhAMheVijA=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 8/9] staging: vt6655: '&pointer[0]' to 'pointer' fix
Date: Fri, 17 Sep 2010 11:24:50 +0300
Message-Id: <45b51ae28a8e80d3fb257cc204e6eec5eafd239e.1284711623.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <20100916225346.GA14448@kroah.com>
References: <20100916225346.GA14448@kroah.com>
In-Reply-To: <668ce39e9bd64e2a285367e2cc0963d678d1b501.1284711623.git.andy.shevchenko@gmail.com>
References: <668ce39e9bd64e2a285367e2cc0963d678d1b501.1284711623.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/vt6655/iwctl.c   |    2 +-
 drivers/staging/vt6655/vntwifi.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index d74b744..92e3399 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -2018,7 +2018,7 @@ param->u.wpa_key.seq_len = seq_len;
 
 #if 0
 printk("param->u.wpa_key.alg_name =%d\n",param->u.wpa_key.alg_name);
-printk(KERN_DEBUG "param->addr=%pM\n", &param->addr[0]);
+printk(KERN_DEBUG "param->addr=%pM\n", param->addr);
 printk("param->u.wpa_key.set_tx =%d\n",param->u.wpa_key.set_tx);
 printk("param->u.wpa_key.key_index =%d\n",param->u.wpa_key.key_index);
 printk("param->u.wpa_key.key_len =%d\n",param->u.wpa_key.key_len);
diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index db9cbe9..0491d0b 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -566,8 +566,7 @@ VNTWIFIvGetTxRate(
 		wTxDataRate = (pMgmt->sNodeDBTable[0].wTxDataRate);
 #ifdef	PLICE_DEBUG
 		printk(KERN_DEBUG "GetTxRate:AP MAC is %pM,TxRate is %d\n",
-				&pMgmt->sNodeDBTable[0].abyMACAddr[0],
-				wTxDataRate);
+				pMgmt->sNodeDBTable[0].abyMACAddr, wTxDataRate);
 #endif
 
 
-- 
1.7.2.2


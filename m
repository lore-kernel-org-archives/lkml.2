Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab0IQIZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:25:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33365 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab0IQIZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:25:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=i9lPMQJ2bGuqD04PTC2YhIpsoIBl7/etmSndVqxKu8sBz+lxfOH02+dcFYl4TZcYoT
         TUAnnTeLbOjR5CA1PHyEo4x5f4/p146SxBUamnIckW/7gBqZK0lrH3+3DL7zitMlGKKG
         eive89lqhH0h/1jtmeh7w2P23OxAnlQrkEeaQ=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 5/9] staging: otus: '&pointer[0]' to 'pointer' fix
Date: Fri, 17 Sep 2010 11:24:47 +0300
Message-Id: <bb9258227c56217c7717f2f6257cc19f286df585.1284711623.git.andy.shevchenko@gmail.com>
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
 drivers/staging/otus/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/otus/ioctl.c b/drivers/staging/otus/ioctl.c
index 405bd29..a403d9c 100644
--- a/drivers/staging/otus/ioctl.c
+++ b/drivers/staging/otus/ioctl.c
@@ -2188,7 +2188,7 @@ int usbdrv_wpa_ioctl(struct net_device *dev, struct athr_wlan_param *zdparm)
 		printk(KERN_ERR "usbdrv_wpa_ioctl: ZD_CMD_SET_MLME\n");
 
 		/* Translate STA's address */
-		sprintf(mac_addr, "%pM", &zdparm->sta_addr[0]);
+		sprintf(mac_addr, "%pM", zdparm->sta_addr);
 
 		switch (zdparm->u.mlme.cmd) {
 		case MLME_STA_DEAUTH:
-- 
1.7.2.2


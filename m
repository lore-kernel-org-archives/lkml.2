Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462Ab0GWNSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 09:18:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52671 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757727Ab0GWNSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 09:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pX8LZsG+zMUp9J//4yUGFyvCD68pFFK503GM+gwAupbrph2jFQs9hMALWTz/92373H
         RxMEk+7gJ5HrWfjbeYhocE6RD6nGRgo+jkHtMCs+60Db3RcBfhmzzdY7K0kuIVi1JTza
         Aj9YJ5hPxffa+8dVGikEh39i5PLG3I0qSpX2E=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 2/5] drivers: net: use newly introduced hex_to_bin()
Date: Fri, 23 Jul 2010 16:18:07 +0300
Message-Id: <3f9b9040fd8614141d4d7df59fbccf32d50e997d.1279890832.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1279890832.git.andy.shevchenko@gmail.com>
References: <cover.1279890832.git.andy.shevchenko@gmail.com>
In-Reply-To: <cover.1279890832.git.andy.shevchenko@gmail.com>
References: <cover.1279890832.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/net/ksz884x.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ksz884x.c b/drivers/net/ksz884x.c
index 1d998e1..37504a3 100644
--- a/drivers/net/ksz884x.c
+++ b/drivers/net/ksz884x.c
@@ -6894,13 +6894,12 @@ static void get_mac_addr(struct dev_info *hw_priv, u8 *macaddr, int port)
 	i = j = num = got_num = 0;
 	while (j < MAC_ADDR_LEN) {
 		if (macaddr[i]) {
+			int digit;
+
 			got_num = 1;
-			if ('0' <= macaddr[i] && macaddr[i] <= '9')
-				num = num * 16 + macaddr[i] - '0';
-			else if ('A' <= macaddr[i] && macaddr[i] <= 'F')
-				num = num * 16 + 10 + macaddr[i] - 'A';
-			else if ('a' <= macaddr[i] && macaddr[i] <= 'f')
-				num = num * 16 + 10 + macaddr[i] - 'a';
+			digit = hex_to_bin(macaddr[i]);
+			if (digit >= 0)
+				num = num * 16 + digit;
 			else if (':' == macaddr[i])
 				got_num = 2;
 			else
-- 
1.7.1.1


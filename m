Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab0IKOSs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 10:18:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62351 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab0IKORl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 10:17:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dCEma4QzUZ74R2aGPpker1eVxn0NgYfGBu13xmeljF+zw8PR4gFUq+3N/hWUQgxaOi
         w77d5/851bXcfZ67l4GFbFPWtW0s6FZAsTE9vmelQvsCG6dEpuVf+fDEkVQgh1+GZZmR
         Nnd1MfBnr1czYYCDNlMqp3IKq/49mr475PB3s=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 07/10] staging: rt2870: use '%pM' format to print MAC address
Date: Sat, 11 Sep 2010 17:17:10 +0300
Message-Id: <a28e5da012adbef9c31f433889767e6952d5ac11.1284214460.git.andy.shevchenko@gmail.com>
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
 drivers/staging/rt2870/common/rtusb_io.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rt2870/common/rtusb_io.c b/drivers/staging/rt2870/common/rtusb_io.c
index 6b9ca24..eb01c8a 100644
--- a/drivers/staging/rt2870/common/rtusb_io.c
+++ b/drivers/staging/rt2870/common/rtusb_io.c
@@ -1879,13 +1879,10 @@ void CMDHandler(struct rt_rtmp_adapter *pAd)
 					AsicUpdateRxWCIDTable(pAd, pEntry->Aid,
 							      pEntry->Addr);
 					DBGPRINT(RT_DEBUG_TRACE,
-						 ("UpdateRxWCIDTable(): Aid=%d, Addr=%02x:%02x:%02x:%02x:%02x:%02x!\n",
-						  pEntry->Aid, pEntry->Addr[0],
-						  pEntry->Addr[1],
-						  pEntry->Addr[2],
-						  pEntry->Addr[3],
-						  pEntry->Addr[4],
-						  pEntry->Addr[5]));
+						("UpdateRxWCIDTable(): Aid=%d, "
+							"Addr=%pM!\n",
+							pEntry->Aid,
+							&pEntry->Addr[0]));
 				}
 				break;
 
-- 
1.7.2.2


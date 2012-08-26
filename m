Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2HZAzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 20:55:20 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:62708 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab2HZAzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 20:55:15 -0400
MIME-Version: 1.0
Date: Sun, 26 Aug 2012 08:55:15 +0800
Message-ID: <CAPgLHd-AoztgFV5tYFi_drvRMtMgXL1D+KZpFwpZ6ZWp4Zg8Yw@mail.gmail.com>
Subject: [PATCH] et131x: using is_zero_ether_addr() to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mark.einon@gmail.com, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using is_zero_ether_addr() to simplify the code

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/et131x/et131x.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 029725c..c13499d 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -3955,12 +3955,7 @@ static void et131x_hwaddr_init(struct et131x_adapter *adapter)
 	 * EEPROM then we need to generate the last octet and set it on the
 	 * device
 	 */
-	if (adapter->rom_addr[0] == 0x00 &&
-	    adapter->rom_addr[1] == 0x00 &&
-	    adapter->rom_addr[2] == 0x00 &&
-	    adapter->rom_addr[3] == 0x00 &&
-	    adapter->rom_addr[4] == 0x00 &&
-	    adapter->rom_addr[5] == 0x00) {
+	if (is_zero_ether_addr(adapter->rom_addr)) {
 		/*
 		 * We need to randomly generate the last octet so we
 		 * decrease our chances of setting the mac address to


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab2KHJfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:35:42 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61187 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2KHJfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:35:39 -0500
MIME-Version: 1.0
Date: Thu, 8 Nov 2012 17:35:38 +0800
Message-ID: <CAPgLHd96n4i905x6WdYtKM5wkSGo7V+zLKzE1mjCXBJ2v6-EbA@mail.gmail.com>
Subject: [PATCH -next] mtip32xx: fix potential NULL pointer dereference in mtip_timeout_function()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: axboe@kernel.dk, smani@micron.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference to port should be moved below the NULL test.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/block/mtip32xx/mtip32xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index adc6f36..fe16b32 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -559,7 +559,7 @@ static void mtip_timeout_function(unsigned long int data)
 	struct mtip_cmd *command;
 	int tag, cmdto_cnt = 0;
 	unsigned int bit, group;
-	unsigned int num_command_slots = port->dd->slot_groups * 32;
+	unsigned int num_command_slots;
 	unsigned long to, tagaccum[SLOTBITS_IN_LONGS];
 
 	if (unlikely(!port))
@@ -572,6 +572,7 @@ static void mtip_timeout_function(unsigned long int data)
 	}
 	/* clear the tag accumulator */
 	memset(tagaccum, 0, SLOTBITS_IN_LONGS * sizeof(long));
+	num_command_slots = port->dd->slot_groups * 32;
 
 	for (tag = 0; tag < num_command_slots; tag++) {
 		/*



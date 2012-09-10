Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab2IJEwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 00:52:39 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35463 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2IJEwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 00:52:38 -0400
MIME-Version: 1.0
Date: Mon, 10 Sep 2012 12:52:37 +0800
Message-ID: <CAPgLHd_VmPgv4z4ecRHwcAqdFsM5Q00MMOnYsT4p5dg4gfx82Q@mail.gmail.com>
Subject: [PATCH] memstick: move the dereference below the NULL test
From: Wei Yongjun <weiyj.lk@gmail.com>
To: maximlevitsky@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/memstick/host/r592.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
index 29b2172..a7c5b31 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -454,7 +454,7 @@ static int r592_transfer_fifo_pio(struct r592_device *dev)
 /* Executes one TPC (data is read/written from small or large fifo) */
 static void r592_execute_tpc(struct r592_device *dev)
 {
-	bool is_write = dev->req->tpc >= MS_TPC_SET_RW_REG_ADRS;
+	bool is_write;
 	int len, error;
 	u32 status, reg;
 
@@ -463,6 +463,7 @@ static void r592_execute_tpc(struct r592_device *dev)
 		return;
 	}
 
+	is_write = dev->req->tpc >= MS_TPC_SET_RW_REG_ADRS;
 	len = dev->req->long_data ?
 		dev->req->sg.length : dev->req->data_len;
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab2JHCou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 22:44:50 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42921 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2JHCos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 22:44:48 -0400
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 10:44:47 +0800
Message-ID: <CAPgLHd-P2iYGkFovRD82jyM-m8bUi4+cxOh1cSwbK2nJp9T_Ow@mail.gmail.com>
Subject: [PATCH v2] drivers:misc: ti-st: fix potential NULL pointer
 dereference in st_register()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove the pointless NULL dereference above the NULL test.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
v1 -> v2: drop the NULL dereference
---
 drivers/misc/ti-st/st_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index 46937b1..b90a224 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -511,7 +511,6 @@ long st_register(struct st_proto_s *new_proto)
 	unsigned long flags = 0;
 
 	st_kim_ref(&st_gdata, 0);
-	pr_info("%s(%d) ", __func__, new_proto->chnl_id);
 	if (st_gdata == NULL || new_proto == NULL || new_proto->recv == NULL
 	    || new_proto->reg_complete_cb == NULL) {
 		pr_err("gdata/new_proto/recv or reg_complete_cb not ready");



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab2JHAli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 20:41:38 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46292 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2JHAlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 20:41:36 -0400
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 08:41:36 +0800
Message-ID: <CAPgLHd_PcLZGPtXQUUJ3VZJub+27zTsDvHF6X2vUrKJ9cKZ+7w@mail.gmail.com>
Subject: [PATCH] drivers:misc: ti-st: fix potential NULL pointer dereference
 in st_register()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/misc/ti-st/st_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index 46937b1..ee341ea 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -511,13 +511,14 @@ long st_register(struct st_proto_s *new_proto)
 	unsigned long flags = 0;
 
 	st_kim_ref(&st_gdata, 0);
-	pr_info("%s(%d) ", __func__, new_proto->chnl_id);
 	if (st_gdata == NULL || new_proto == NULL || new_proto->recv == NULL
 	    || new_proto->reg_complete_cb == NULL) {
 		pr_err("gdata/new_proto/recv or reg_complete_cb not ready");
 		return -EINVAL;
 	}
 
+	pr_info("%s(%d) ", __func__, new_proto->chnl_id);
+
 	if (new_proto->chnl_id >= ST_MAX_CHANNELS) {
 		pr_err("chnl_id %d not supported", new_proto->chnl_id);
 		return -EPROTONOSUPPORT;


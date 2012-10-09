Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2JIGOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:14:24 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44476 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2JIGOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:14:22 -0400
MIME-Version: 1.0
Date: Tue, 9 Oct 2012 14:14:21 +0800
Message-ID: <CAPgLHd_AHHe7=H18K54LvbiS0M7_w1vTMOxwwxgVdRaiXNN-OA@mail.gmail.com>
Subject: [PATCH] ubi: use list_move_tail instead of list_del/list_add_tail
From: Wei Yongjun <weiyj.lk@gmail.com>
To: richard@nod.at, dedekind1@gmail.com, dwmw2@infradead.org
Cc: yongjun_wei@trendmicro.com.cn, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mtd/ubi/fastmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 1a5f53c..5f540c5 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -815,8 +815,7 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 		ai->max_sqnum = max_sqnum;
 
 	list_for_each_entry_safe(tmp_aeb, _tmp_aeb, &free, u.list) {
-		list_del(&tmp_aeb->u.list);
-		list_add_tail(&tmp_aeb->u.list, &ai->free);
+		list_move_tail(&tmp_aeb->u.list, &ai->free);
 	}
 
 	/*


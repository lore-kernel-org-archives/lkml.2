Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2HRV1l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 17:27:41 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:61443 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753272Ab2HRV0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 17:26:23 -0400
X-IronPort-AV: E=Sophos;i="4.77,791,1336341600"; 
   d="scan'208";a="170194856"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] drivers/net/wireless/ath/ath6kl/main.c: introduce missing initialization
Date: Sat, 18 Aug 2012 23:25:58 +0200
Message-Id: <1345325159-7365-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The result of one call to a function is tested, and then at the second call
to the same function, the previous result, and not the current result, is
tested again.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression ret;
identifier f;
statement S1,S2;
@@

*ret = f(...);
if (\(ret != 0\|ret < 0\|ret == NULL\)) S1
... when any
*f(...);
if (\(ret != 0\|ret < 0\|ret == NULL\)) S2
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/wireless/ath/ath6kl/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index c189e28..c312c61 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -322,7 +322,8 @@ int ath6kl_read_fwlogs(struct ath6kl *ar)
 
 		address = TARG_VTOP(ar->target_type,
 				    le32_to_cpu(debug_buf.next));
-		ath6kl_diag_read(ar, address, &debug_buf, sizeof(debug_buf));
+		ret = ath6kl_diag_read(ar, address, &debug_buf,
+				       sizeof(debug_buf));
 		if (ret)
 			goto out;
 


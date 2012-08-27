Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab2H0HGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:06:44 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47997 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2H0HGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:06:43 -0400
MIME-Version: 1.0
Date: Mon, 27 Aug 2012 15:06:42 +0800
Message-ID: <CAPgLHd-SUWNg=wHWeJNjUNjkN1ZRQe2ibXPdzEmytb3EfWEEPg@mail.gmail.com>
Subject: [PATCH] cciss: remove useless set memory to zero use memset()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mike.miller@hp.com
Cc: yongjun_wei@trendmicro.com.cn, iss_storagedev@hp.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The memory return by kzalloc() or kmem_cache_zalloc() has already
be set to zero, so remove useless memset(0).

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/block/cciss.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b0f553b..ca83f96 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -5205,7 +5205,6 @@ static void cciss_shutdown(struct pci_dev *pdev)
 		return;
 	}
 	/* write all data in the battery backed cache to disk */
-	memset(flush_buf, 0, 4);
 	return_code = sendcmd_withirq(h, CCISS_CACHE_FLUSH, flush_buf,
 		4, 0, CTLR_LUNID, TYPE_CMD);
 	kfree(flush_buf);


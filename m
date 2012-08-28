Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab2H1NLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 09:11:05 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40183 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab2H1NLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 09:11:01 -0400
MIME-Version: 1.0
Date: Tue, 28 Aug 2012 21:11:00 +0800
Message-ID: <CAPgLHd_u2CE7PAhS4Y9MtbY=ZFphZfUrYYiqD_gx6-kf1O0C-w@mail.gmail.com>
Subject: [PATCH] staging: ozwpan: remove pointless conditional before kfree_skb()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: rgujare@ozmodevices.com, ckelly@ozmodevices.com,
        gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove pointless conditional before kfree_skb().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/ozwpan/ozpd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 6c287ac..d515714 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -752,8 +752,7 @@ int oz_isoc_stream_create(struct oz_pd *pd, u8 ep_num)
  */
 static void oz_isoc_stream_free(struct oz_isoc_stream *st)
 {
-	if (st->skb)
-		kfree_skb(st->skb);
+	kfree_skb(st->skb);
 	kfree(st);
 }
 /*------------------------------------------------------------------------------


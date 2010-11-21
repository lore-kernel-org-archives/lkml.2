Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab0KUCkK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:40:10 -0500
Received: from mail.perches.com ([173.55.12.10]:1646 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab0KUCjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:39:52 -0500
From: Joe Perches <joe@perches.com>
To: Divy Le Ray <divy@chelsio.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/62] cxgb3: Use static const
Date: Sat, 20 Nov 2010 18:38:13 -0800
Message-Id: <20d3c8494abd65f7a63cc7a51c6a1bbafa7552f2.1290305776.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
  42246	     56	   8816	  51118	   c7ae	drivers/net/cxgb3/t3_hw.o.new
  42198	    104	   8816	  51118	   c7ae	drivers/net/cxgb3/t3_hw.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/cxgb3/t3_hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index 0b19704..d55db6b 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -1562,7 +1562,7 @@ static void tp_intr_handler(struct adapter *adapter)
 		{0}
 	};
 
-	static struct intr_info tp_intr_info_t3c[] = {
+	static const struct intr_info tp_intr_info_t3c[] = {
 		{0x1fffffff, "TP parity error", -1, 1},
 		{F_FLMRXFLSTEMPTY, "TP out of Rx pages", -1, 1},
 		{F_FLMTXFLSTEMPTY, "TP out of Tx pages", -1, 1},
-- 
1.7.3.2.245.g03276.dirty


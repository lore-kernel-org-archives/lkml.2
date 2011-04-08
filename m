Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab1DHNjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 09:39:10 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51709 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab1DHNjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 09:39:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=cDRyPD3uHIy0dXHE+/rstkMlZT3obw3pEGRfuJyI0dVtSBF/ZGuPVHYWL4Lz53zG2I
         O0Hs8DQZ4sTkE6cF9yatA+2UwlO7Xh6WBPloIlioH4iR1iN7Z5U6nc1DSzr0qv7q8b2q
         zK5dnM44LeYigT7V0RtcDaAMxhBqsWGv/B85s=
From: =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= 
	<panweiping3@gmail.com>
To: fubar@us.ibm.com, andy@greyhouse.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Weiping=20Pan (=E6=BD=98=E5=8D=AB=E5=B9=B3) ?= 
	<panweiping3@gmail.com>
Subject: [PATCH] bonding:set save_load to 0 when initializing
Date: Fri,  8 Apr 2011 21:40:19 +0800
Message-Id: <1302270019-11698-1-git-send-email-panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is unnecessary to set save_load to 1 here,
as the tx_hashtbl is just kzalloced.

Signed-off-by: Weiping Pan(潘卫平) <panweiping3@gmail.com>
---
 drivers/net/bonding/bond_alb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 9bc5de3..ab69e5a 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -176,7 +176,7 @@ static int tlb_initialize(struct bonding *bond)
 	bond_info->tx_hashtbl = new_hashtbl;
 
 	for (i = 0; i < TLB_HASH_TABLE_SIZE; i++) {
-		tlb_init_table_entry(&bond_info->tx_hashtbl[i], 1);
+		tlb_init_table_entry(&bond_info->tx_hashtbl[i], 0);
 	}
 
 	_unlock_tx_hashtbl(bond);
-- 
1.7.4


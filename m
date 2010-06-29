Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0F2KPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:15:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:3013 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab0F2KPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:15:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GCzIHRIxaS+DGqMaP2dKuDsVzHt1Sr0qluuGptueUexRVf3IYmBKeO7wUwAGkAauJr
         Iu4HFlDx417Ihyn/evGsHgk+p5Mu3ZUgNDPSWJA8N0rmmgurlqib+Lf56K902Jp/W78P
         DsbomIsLr2gxkLNg/AINuAfnwv7Ok6dAUx+XU=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/25] r852: remove casts from void*
Date: Tue, 29 Jun 2010 14:14:57 +0400
Message-Id: <1277806498-30738-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/mtd/nand/r852.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/r852.c b/drivers/mtd/nand/r852.c
index 78a4232..c0a9835 100644
--- a/drivers/mtd/nand/r852.c
+++ b/drivers/mtd/nand/r852.c
@@ -64,8 +64,8 @@ static inline void r852_write_reg_dword(struct r852_device *dev,
 /* returns pointer to our private structure */
 static inline struct r852_device *r852_get_dev(struct mtd_info *mtd)
 {
-	struct nand_chip *chip = (struct nand_chip *)mtd->priv;
-	return (struct r852_device *)chip->priv;
+	struct nand_chip *chip = mtd->priv;
+	return chip->priv;
 }
 
 
-- 
1.7.0.4


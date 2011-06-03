Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab1FCGKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 02:10:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64844 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1FCGK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 02:10:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=TNKbuw3d88lXNjn4OFaIUcTIWEzbRfg/Ni//rJi/LPqMf5mAB1Jtio//LV5lTtzlin
         86wO+8r/5/cTgLJVQXJfSPd5zfMX6Uijk6X8DlScTX2IXOco0WdgUnFtyipgpbTWV3GC
         lIEM06DyJys0CLBgHJIv5kZdtR5BjlM0djvWk=
Subject: [PATCH] mtd: mtdblock: Use DEFINE_MUTEX() for mtdblks_lock
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Matthias Kaehlcke <matthias@kaehlcke.net>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 14:10:22 +0800
Message-ID: <1307081422.6450.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mtdblks_lock can be initialized automatically with
DEFINE_MUTEX() rather than explicitly calling mutex_init().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mtd/mtdblock.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/mtdblock.c b/drivers/mtd/mtdblock.c
index 3326615..1976b6c 100644
--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -44,7 +44,7 @@ struct mtdblk_dev {
 	enum { STATE_EMPTY, STATE_CLEAN, STATE_DIRTY } cache_state;
 };
 
-static struct mutex mtdblks_lock;
+static DEFINE_MUTEX(mtdblks_lock);
 
 /*
  * Cache stuff...
@@ -389,8 +389,6 @@ static struct mtd_blktrans_ops mtdblock_tr = {
 
 static int __init init_mtdblock(void)
 {
-	mutex_init(&mtdblks_lock);
-
 	return register_mtd_blktrans(&mtdblock_tr);
 }
 
-- 
1.7.4.1




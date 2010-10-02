Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab0JBNzJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 09:55:09 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:52939 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548Ab0JBNy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 09:54:59 -0400
From: Julia Lawall <julia@diku.dk>
To: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: kernel-janitors@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] drivers/atm/idt77252.c: Remove unnecessary error check
Date: Sat,  2 Oct 2010 15:59:18 +0200
Message-Id: <1286027958-7333-4-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code does not call deinit_card(card); in an error case, as done in
other error-handling code in the same function.  But actually, the called
function init_sram can only return 0, so there is no need for the error
check at all.

A simplified version of the sematic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
@r@
statement S1,S2,S3;
constant C1,C2,C3;
@@

*if (...)
 {... S1 return -C1;}
...
*if (...)
 {... when != S1
    return -C2;}
...
*if (...)
 {... S1 return -C3;}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/atm/idt77252.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 1679cbf..08ccde6 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -3410,8 +3410,7 @@ init_card(struct atm_dev *dev)
 
 	writel(readl(SAR_REG_CFG) | conf, SAR_REG_CFG);
 
-	if (init_sram(card) < 0)
-		return -1;
+	init_sram(card);
 
 /********************************************************************/
 /*  A L L O C   R A M   A N D   S E T   V A R I O U S   T H I N G S */


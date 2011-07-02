Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab1GBUrc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 16:47:32 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14928 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab1GBUr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 16:47:29 -0400
Date: Sat, 2 Jul 2011 22:38:11 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Samuel Ortiz <sameo@linux.intel.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] mfd: remove dead code from
 drivers/mfd/max8997-irq.c:get_i2c()
Message-ID: <alpine.LNX.2.00.1107022235380.16316@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We either hit one of the case's or the default in the switch statement
in get_i2c(), so the 'return ERR_PTR(-EINVAL);' at the end of the
function is just dead code - remove it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/mfd/max8997-irq.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/max8997-irq.c b/drivers/mfd/max8997-irq.c
index 638bf7e..09274cf 100644
--- a/drivers/mfd/max8997-irq.c
+++ b/drivers/mfd/max8997-irq.c
@@ -58,8 +58,6 @@ static struct i2c_client *get_i2c(struct max8997_dev *max8997,
 	default:
 		return ERR_PTR(-EINVAL);
 	}
-
-	return ERR_PTR(-EINVAL);
 }
 
 struct max8997_irq_data {
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab2JLWSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 18:18:40 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:27587 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab2JLWSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 18:18:38 -0400
Date: Sun, 9 Nov 2008 18:04:42 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: linux-media@vger.kernel.org, Ezequiel Garcia <elezegarcia@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] stk1160: Remove dead code from
 stk1160_i2c_read_reg()
Message-ID: <alpine.LNX.2.00.0811091803320.23782@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two checks for 'rc' being less than zero with no change to
'rc' between the two, so the second is just dead code - remove it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/media/usb/stk1160/stk1160-i2c.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-i2c.c b/drivers/media/usb/stk1160/stk1160-i2c.c
index 176ac93..035cf8c 100644
--- a/drivers/media/usb/stk1160/stk1160-i2c.c
+++ b/drivers/media/usb/stk1160/stk1160-i2c.c
@@ -117,9 +117,6 @@ static int stk1160_i2c_read_reg(struct stk1160 *dev, u8 addr,
 		return rc;
 
 	stk1160_read_reg(dev, STK1160_SBUSR_RD, value);
-	if (rc < 0)
-		return rc;
-
 	return 0;
 }
 
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


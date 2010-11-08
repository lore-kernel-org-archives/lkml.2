Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab0KHXUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:20:19 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:39355 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab0KHXUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:20:17 -0500
Date: Tue, 9 Nov 2010 00:08:50 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 05/17][trivial] drivers/message/, i2o: Remove unnecessary
 casts of void ptr returning alloc function return values
Message-ID: <alpine.LNX.2.00.1011082323470.23697@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The [vk][cmz]alloc(_node) family of functions return void pointers which
it's completely unnecessary/pointless to cast to other pointer types since
that happens implicitly.

This patch removes such casts from drivers/message/


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 i2o_config.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index 7d3cc57..098de2b 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -1044,8 +1044,7 @@ static long i2o_cfg_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 
 static int cfg_open(struct inode *inode, struct file *file)
 {
-	struct i2o_cfg_info *tmp =
-	    (struct i2o_cfg_info *)kmalloc(sizeof(struct i2o_cfg_info),
+	struct i2o_cfg_info *tmp = kmalloc(sizeof(struct i2o_cfg_info),
 					   GFP_KERNEL);
 	unsigned long flags;
 


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.


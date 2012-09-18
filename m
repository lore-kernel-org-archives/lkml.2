Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab2IRMIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:08:32 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59700 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843Ab2IRMIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:08:18 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: jayalk@intworks.biz
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 10/10] drivers/video/arcfb.c: fix error return code
Date: Tue, 18 Sep 2012 14:08:00 +0200
Message-Id: <1347970080-25175-10-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347970080-25175-1-git-send-email-peter.senna@gmail.com>
References: <1347970080-25175-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/video/arcfb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/arcfb.c b/drivers/video/arcfb.c
index a1d58e9..4659d5d 100644
--- a/drivers/video/arcfb.c
+++ b/drivers/video/arcfb.c
@@ -552,6 +552,7 @@ static int __devinit arcfb_probe(struct platform_device *dev)
 				"arcfb", info)) {
 			printk(KERN_INFO
 				"arcfb: Failed req IRQ %d\n", par->irq);
+			retval = -EBUSY;
 			goto err1;
 		}
 	}
-- 
1.7.11.4


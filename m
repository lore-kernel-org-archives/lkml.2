Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965225Ab2JCQWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:22:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39624 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965046Ab2JCQSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:18:31 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: samuel@sortiz.org
Cc: kernel-janitors@vger.kernel.org, irda-users@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/20] drivers/net/irda/irtty-sir.c: fix error return code
Date: Wed,  3 Oct 2012 18:18:01 +0200
Message-Id: <1349281090-10013-11-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
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
 drivers/net/irda/irtty-sir.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/irda/irtty-sir.c b/drivers/net/irda/irtty-sir.c
index 30087ca..6e4d4b6 100644
--- a/drivers/net/irda/irtty-sir.c
+++ b/drivers/net/irda/irtty-sir.c
@@ -459,8 +459,10 @@ static int irtty_open(struct tty_struct *tty)
 
 	/* allocate private device info block */
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
+	if (!priv) {
+		ret = -ENOMEM;
 		goto out_put;
+	}
 
 	priv->magic = IRTTY_MAGIC;
 	priv->tty = tty;


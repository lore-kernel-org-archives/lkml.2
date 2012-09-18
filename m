Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab2IRMLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:11:31 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58280 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403Ab2IRMIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:08:13 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 03/10] drivers/video/cg3.c: fix error return code
Date: Tue, 18 Sep 2012 14:07:53 +0200
Message-Id: <1347970080-25175-3-git-send-email-peter.senna@gmail.com>
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
 drivers/video/cg3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/cg3.c b/drivers/video/cg3.c
index f927a7b..c5e7612 100644
--- a/drivers/video/cg3.c
+++ b/drivers/video/cg3.c
@@ -398,7 +398,8 @@ static int __devinit cg3_probe(struct platform_device *op)
 			goto out_unmap_screen;
 	}
 
-	if (fb_alloc_cmap(&info->cmap, 256, 0))
+	err = fb_alloc_cmap(&info->cmap, 256, 0);
+	if (err)
 		goto out_unmap_screen;
 
 	fb_set_cmap(&info->cmap, info);
-- 
1.7.11.4


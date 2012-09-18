Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab2IRMJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:09:50 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33307 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509Ab2IRMIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:08:14 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: kernel@pengutronix.de
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 06/10] drivers/video/imxfb.c: fix error return code
Date: Tue, 18 Sep 2012 14:07:56 +0200
Message-Id: <1347970080-25175-6-git-send-email-peter.senna@gmail.com>
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
 drivers/video/imxfb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
index caad368..469b07c 100644
--- a/drivers/video/imxfb.c
+++ b/drivers/video/imxfb.c
@@ -803,6 +803,7 @@ static int __init imxfb_probe(struct platform_device *pdev)
 	fbi->regs = ioremap(res->start, resource_size(res));
 	if (fbi->regs == NULL) {
 		dev_err(&pdev->dev, "Cannot map frame buffer registers\n");
+		ret = -ENOMEM;
 		goto failed_ioremap;
 	}
 
-- 
1.7.11.4


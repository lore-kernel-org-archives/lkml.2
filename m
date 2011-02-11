Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab1BKItI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 03:49:08 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61372 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab1BKItG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 03:49:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=K5rbY7iKaBgV/Rifo5wvaFkzshXB95XYD8IvpIJQ8tHb6A7rCyoaMLA0wxy8H8kFHZ
         Z2oucguJ9oET4zQiVy4s8deuqFcQnrsFidY6wtgiwg9WVmCcbBmhtrxxloGJII7cCK+b
         rCnACN8tckIBdA2YQwgxFndeN1HpYcmr4aEAM=
Subject: [PATCH] video: s3c-fb: return proper error if clk_get fails
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org
Content-Type: text/plain
Date: Fri, 11 Feb 2011 16:51:10 +0800
Message-Id: <1297414270.14046.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return PTR_ERR(sfb->bus_clk) instead of 0 if clk_get fails.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/s3c-fb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index 83ce9a0..6817d18 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -1340,6 +1340,7 @@ static int __devinit s3c_fb_probe(struct platform_device *pdev)
 	sfb->bus_clk = clk_get(dev, "lcd");
 	if (IS_ERR(sfb->bus_clk)) {
 		dev_err(dev, "failed to get bus clock\n");
+		ret = PTR_ERR(sfb->bus_clk);
 		goto err_sfb;
 	}
 
-- 
1.7.2




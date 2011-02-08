Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab1BHO7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 09:59:03 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42761 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab1BHO7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 09:59:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=n7r7iUDJ1q2dH4CR58FrnBRrWokBQu8A0SVSuBPOKpfsxTy95JMDEJgJsomNoHVJiC
         Q8T9+6oCsv0GcIIKZNEKS4F/xRBvbH7MgBYxFT/PhNkW3+16nT29AdeXcX/4EoXqp1AY
         9JzBu2o6nzay32PUCk6FgqRiNyvieJZgOLQbw=
Subject: [PATCH] video: ffb: fix ffb_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
        linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 22:58:45 +0800
Message-ID: <1297177125.2343.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation calls of_iounmap for par->fbc twice in error path.
In the case of goto out_unmap_dac, we should call of_iounmap for par->dac.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/ffb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/ffb.c b/drivers/video/ffb.c
index 6739b2a..b5d6a46 100644
--- a/drivers/video/ffb.c
+++ b/drivers/video/ffb.c
@@ -1011,7 +1011,7 @@ out_dealloc_cmap:
 	fb_dealloc_cmap(&info->cmap);
 
 out_unmap_dac:
-	of_iounmap(&op->resource[2], par->fbc, sizeof(struct ffb_fbc));
+	of_iounmap(&op->resource[1], par->dac, sizeof(struct ffb_dac));
 
 out_unmap_fbc:
 	of_iounmap(&op->resource[2], par->fbc, sizeof(struct ffb_fbc));
-- 
1.7.1




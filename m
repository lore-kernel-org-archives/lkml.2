Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab0HYDRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 23:17:16 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34194 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab0HYDRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 23:17:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=gxpCoauFemGhaZpoj67S/mOgN+bPRrXO1Um3IXKfGzTF03BrMyBh3Augrn3Y6lAdKj
         ZfgZtSJZl+oRinnp05gdpN/9UFmMfV11zUiH8s59oc7LIBise7Lsew/UQc2gRfWeL/Fr
         368DTorjoPLauGMwpTWCwVPCvvdVSRTgCjeJI=
Subject: [PATCH] mfd: htc-pasic3 - remove redundant code to get irq
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Philipp Zabel <philipp.zabel@gmail.com>
Content-Type: text/plain
Date: Wed, 25 Aug 2010 11:20:25 +0800
Message-Id: <1282706425.12559.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to get irq twice.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/htc-pasic3.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
index f04300e..7bc7522 100644
--- a/drivers/mfd/htc-pasic3.c
+++ b/drivers/mfd/htc-pasic3.c
@@ -138,13 +138,6 @@ static int __init pasic3_probe(struct platform_device *pdev)
 		irq = r->start;
 	}
 
-	r = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (r) {
-		ds1wm_resources[1].flags = IORESOURCE_IRQ | (r->flags &
-			(IORESOURCE_IRQ_HIGHEDGE | IORESOURCE_IRQ_LOWEDGE));
-		irq = r->start;
-	}
-
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r)
 		return -ENXIO;
-- 
1.7.2




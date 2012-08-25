Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab2HYT5Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 15:57:24 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:45964
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754644Ab2HYT5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 15:57:15 -0400
X-IronPort-AV: E=Sophos;i="4.80,311,1344204000"; 
   d="scan'208";a="153817993"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] drivers/media/platform/mx2_emmaprp.c: adjust inconsistent IS_ERR and PTR_ERR
Date: Sat, 25 Aug 2012 21:57:05 +0200
Message-Id: <1345924629-16584-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345924629-16584-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345924629-16584-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Change the call to IS_ERR to test the value that was just initialized and
is returned using PTR_ERR.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,e1;
@@

(
if (IS_ERR(e)) { ... PTR_ERR(e) ... }
|
if (IS_ERR(e=e1)) { ... PTR_ERR(e) ... }
|
*if (IS_ERR(e))
 { ...
*  PTR_ERR(e1)
   ... }
)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/platform/mx2_emmaprp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index dab380a..2be1bb1 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -908,9 +908,8 @@ static int emmaprp_probe(struct platform_device *pdev)
 	}
 
 	pcdev->clk_emma_ahb = devm_clk_get(&pdev->dev, "ahb");
-	if (IS_ERR(pcdev->clk_emma_ipg)) {
+	if (IS_ERR(pcdev->clk_emma_ahb))
 		return PTR_ERR(pcdev->clk_emma_ahb);
-	}
 
 	irq_emma = platform_get_irq(pdev, 0);
 	res_emma = platform_get_resource(pdev, IORESOURCE_MEM, 0);


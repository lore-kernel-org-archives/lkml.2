Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab2HYT50 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 15:57:26 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:1594 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757533Ab2HYT5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 15:57:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,311,1344204000"; 
   d="scan'208";a="153817995"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] drivers/usb/host/ohci-nxp.c: adjust inconsistent IS_ERR and PTR_ERR
Date: Sat, 25 Aug 2012 21:57:07 +0200
Message-Id: <1345924629-16584-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345924629-16584-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345924629-16584-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Change the call to PTR_ERR to access the value just tested by IS_ERR.

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
 drivers/usb/host/ohci-nxp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
index a446386..c60066a 100644
--- a/drivers/usb/host/ohci-nxp.c
+++ b/drivers/usb/host/ohci-nxp.c
@@ -355,7 +355,7 @@ static int __devinit usb_hcd_nxp_probe(struct platform_device *pdev)
 	usb_otg_clk = clk_get(&pdev->dev, "ck_usb_otg");
 	if (IS_ERR(usb_otg_clk)) {
 		dev_err(&pdev->dev, "failed to acquire USB DEV Clock\n");
-		ret = PTR_ERR(usb_dev_clk);
+		ret = PTR_ERR(usb_otg_clk);
 		goto out6;
 	}
 


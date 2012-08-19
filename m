Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab2HSIox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 04:44:53 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:52549 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751938Ab2HSIop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 04:44:45 -0400
X-IronPort-AV: E=Sophos;i="4.77,792,1336341600"; 
   d="scan'208";a="170216894"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Anton Vorontsov <cbou@mail.ru>
Cc: kernel-janitors@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/14] drivers/power/ab8500_charger.c: fix error return code
Date: Sun, 19 Aug 2012 10:44:19 +0200
Message-Id: <1345365870-29831-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Initialize return variable before exiting on an error path.

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

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/power/ab8500_charger.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index d4f0c98..c2ef947 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -2614,6 +2614,7 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 		create_singlethread_workqueue("ab8500_charger_wq");
 	if (di->charger_wq == NULL) {
 		dev_err(di->dev, "failed to create work queue\n");
+		ret = -ENOMEM;
 		goto free_device_info;
 	}
 


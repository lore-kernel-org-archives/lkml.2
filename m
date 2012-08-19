Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab2HSIo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 04:44:59 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:40050 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752877Ab2HSIoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 04:44:46 -0400
X-IronPort-AV: E=Sophos;i="4.77,792,1336341600"; 
   d="scan'208";a="170216896"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Anton Vorontsov <cbou@mail.ru>
Cc: kernel-janitors@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/14] drivers/power/ab8500_fg.c: fix error return code
Date: Sun, 19 Aug 2012 10:44:21 +0200
Message-Id: <1345365870-29831-6-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/power/ab8500_fg.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index bf02225..11633e3 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2506,6 +2506,7 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 	di->fg_wq = create_singlethread_workqueue("ab8500_fg_wq");
 	if (di->fg_wq == NULL) {
 		dev_err(di->dev, "failed to create work queue\n");
+		ret = -ENOMEM;
 		goto free_device_info;
 	}
 


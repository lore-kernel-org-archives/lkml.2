Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166Ab2JCQVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:21:38 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58499 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965052Ab2JCQSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:18:33 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: davem@davemloft.net
Cc: kernel-janitors@vger.kernel.org, jdmason@kudzu.us, gerard.lledo@gmail.com,
        dhowells@redhat.com, joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/20] drivers/net/ethernet/sun/sungem.c: fix error return code
Date: Wed,  3 Oct 2012 18:18:03 +0200
Message-Id: <1349281090-10013-13-git-send-email-peter.senna@gmail.com>
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
 drivers/net/ethernet/sun/sungem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 9ae12d0..6c8695e 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -2963,7 +2963,8 @@ static int __devinit gem_init_one(struct pci_dev *pdev,
 		goto err_out_iounmap;
 	}
 
-	if (gem_get_device_address(gp))
+	err = gem_get_device_address(gp);
+	if (err)
 		goto err_out_free_consistent;
 
 	dev->netdev_ops = &gem_netdev_ops;


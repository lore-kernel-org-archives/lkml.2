Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965139Ab2JCQSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:18:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48406 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965057Ab2JCQSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:18:33 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: davem@davemloft.net
Cc: kernel-janitors@vger.kernel.org, mcarlson@broadcom.com,
        eric.dumazet@gmail.com, mchan@broadcom.com, shuah.khan@hp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 17/20] drivers/net/ethernet/sun/niu.c: fix error return code
Date: Wed,  3 Oct 2012 18:18:04 +0200
Message-Id: <1349281090-10013-14-git-send-email-peter.senna@gmail.com>
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
 drivers/net/ethernet/sun/niu.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 8419bf3..275b430 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9788,6 +9788,7 @@ static int __devinit niu_pci_init_one(struct pci_dev *pdev,
 
 	if (!pci_is_pcie(pdev)) {
 		dev_err(&pdev->dev, "Cannot find PCI Express capability, aborting\n");
+		err = -ENODEV;
 		goto err_out_free_res;
 	}
 


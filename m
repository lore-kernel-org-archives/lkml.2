Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab2JCQUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:20:37 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40104 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965082Ab2JCQSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:18:36 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: davem@davemloft.net
Cc: kernel-janitors@vger.kernel.org, joe@perches.com, dhowells@redhat.com,
        rick.jones2@hp.com, netdev@pradeepdalvi.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/20] drivers/net/ethernet/amd/amd8111e.c: fix error return code
Date: Wed,  3 Oct 2012 18:18:08 +0200
Message-Id: <1349281090-10013-18-git-send-email-peter.senna@gmail.com>
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
 drivers/net/ethernet/amd/amd8111e.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 64d0d9c..3491d43 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -1845,6 +1845,7 @@ static int __devinit amd8111e_probe_one(struct pci_dev *pdev,
 	if((pm_cap = pci_find_capability(pdev, PCI_CAP_ID_PM))==0){
 		printk(KERN_ERR "amd8111e: No Power Management capability, "
 		       "exiting.\n");
+		err = -ENODEV;
 		goto err_free_reg;
 	}
 
@@ -1852,6 +1853,7 @@ static int __devinit amd8111e_probe_one(struct pci_dev *pdev,
 	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) < 0) {
 		printk(KERN_ERR "amd8111e: DMA not supported,"
 			"exiting.\n");
+		err = -ENODEV;
 		goto err_free_reg;
 	}
 


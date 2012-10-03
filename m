Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964909Ab2JCQWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:22:00 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39029 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965047Ab2JCQSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:18:31 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: jitendra.kalsaria@qlogic.com
Cc: kernel-janitors@vger.kernel.org, sony.chacko@qlogic.com,
        linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/20] drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c: fix error return code
Date: Wed,  3 Oct 2012 18:18:02 +0200
Message-Id: <1349281090-10013-12-git-send-email-peter.senna@gmail.com>
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
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 473ce13..24ad17e 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -1601,7 +1601,8 @@ qlcnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->netdev  = netdev;
 	adapter->pdev    = pdev;
 
-	if (qlcnic_alloc_adapter_resources(adapter))
+	err = qlcnic_alloc_adapter_resources(adapter);
+	if (err)
 		goto err_out_free_netdev;
 
 	adapter->dev_rst_time = jiffies;


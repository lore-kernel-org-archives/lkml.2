Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab2GHLiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 07:38:25 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:49825 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936Ab2GHLhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 07:37:55 -0400
X-IronPort-AV: E=Sophos;i="4.77,546,1336341600"; 
   d="scan'208";a="166023141"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] drivers/net/ethernet/broadcom/cnic.c: remove invalid reference to list iterator variable
Date: Sun,  8 Jul 2012 13:37:43 +0200
Message-Id: <1341747464-1772-7-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1341747464-1772-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1341747464-1772-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

If list_for_each_entry, etc complete a traversal of the list, the iterator
variable ends up pointing to an address at an offset from the list head,
and not a meaningful structure.  Thus this value should not be used after
the end of the iterator.  There does not seem to be a meaningful value to
provide to netdev_warn.  Replace with pr_warn, since pr_err is used
elsewhere.

This problem was found using Coccinelle (http://coccinelle.lip6.fr/).

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/ethernet/broadcom/cnic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index 22ad7b6..6eaca60 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -542,7 +542,8 @@ int cnic_unregister_driver(int ulp_type)
 	}
 
 	if (atomic_read(&ulp_ops->ref_count) != 0)
-		netdev_warn(dev->netdev, "Failed waiting for ref count to go to zero\n");
+		pr_warn("%s: Failed waiting for ref count to go to zero\n",
+			__func__);
 	return 0;
 
 out_unlock:


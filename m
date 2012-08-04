Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab2HDMBj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 08:01:39 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:18545 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751806Ab2HDMAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 08:00:43 -0400
X-IronPort-AV: E=Sophos;i="4.77,711,1336341600"; 
   d="scan'208";a="169070475"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] drivers/mfd/palmas.c: drop kfree of devm_kzalloc's data
Date: Sat,  4 Aug 2012 14:00:31 +0200
Message-Id: <1344081632-4729-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Using kfree to free data allocated with devm_kzalloc causes double frees.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x;
@@

x = devm_kzalloc(...)
...
?-kfree(x);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/mfd/palmas.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index c4a69f1..92c6fc7 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -463,7 +463,6 @@ static int __devinit palmas_i2c_probe(struct i2c_client *i2c,
 
 err:
 	mfd_remove_devices(palmas->dev);
-	kfree(palmas);
 	return ret;
 }
 


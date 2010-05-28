Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab0E1U6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 16:58:53 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:35878 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758709Ab0E1U6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 16:58:51 -0400
Date: Fri, 28 May 2010 22:58:46 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/mfd: kzalloc doesn't return ERR_PTR
Message-ID: <Pine.LNX.4.64.1005282258050.27908@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use !x rather than IS_ERR(x) to test the result of kzalloc.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,E;
@@

x = \(kmalloc\|kzalloc\|kcalloc\)(...)
... when != x = E
- IS_ERR(x)
+ !x
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mfd/abx500-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/mfd/abx500-core.c b/drivers/mfd/abx500-core.c
--- a/drivers/mfd/abx500-core.c
+++ b/drivers/mfd/abx500-core.c
@@ -36,7 +36,7 @@ int abx500_register_ops(struct device *d
 	struct abx500_device_entry *dev_entry;
 
 	dev_entry = kzalloc(sizeof(struct abx500_device_entry), GFP_KERNEL);
-	if (IS_ERR(dev_entry)) {
+	if (!dev_entry) {
 		dev_err(dev, "register_ops kzalloc failed");
 		return -ENOMEM;
 	}

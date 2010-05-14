Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab0ENT3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:29:14 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51380 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab0ENT3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:29:09 -0400
Date: Fri, 14 May 2010 21:29:03 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/10] drivers/acpi: Use kstrdup
Message-ID: <Pine.LNX.4.64.1005142128370.28935@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kstrdup when the goal of an allocation is copy a string into the
allocated region.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to;
expression flag,E1,E2;
statement S;
@@

-  to = kmalloc(strlen(from) + 1,flag);
+  to = kstrdup(from, flag);
   ... when != \(from = E1 \| to = E1 \)
   if (to==NULL || ...) S
   ... when != \(from = E2 \| to = E2 \)
-  strcpy(to, from);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/acpi/scan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/acpi/scan.c b/drivers/acpi/scan.c
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1024,13 +1024,12 @@ static void acpi_add_id(struct acpi_devi
 	if (!id)
 		return;
 
-	id->id = kmalloc(strlen(dev_id) + 1, GFP_KERNEL);
+	id->id = kstrdup(dev_id, GFP_KERNEL);
 	if (!id->id) {
 		kfree(id);
 		return;
 	}
 
-	strcpy(id->id, dev_id);
 	list_add_tail(&id->list, &device->pnp.ids);
 }
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1HFJd2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 05:33:28 -0400
Received: from www17.your-server.de ([213.133.104.17]:41191 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab1HFJd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 05:33:27 -0400
Subject: [PATCH] ACPI: use kstrdup()
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 06 Aug 2011 11:32:56 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312623179.5589.69.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use kstrdup rather than duplicating its implementation

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/kstrdup.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/acpi/scan.c b/drivers/acpi/scan.c
--- a/drivers/acpi/scan.c 2011-05-04 19:24:51.386504770 +0200
+++ b/drivers/acpi/scan.c 2011-08-01 21:02:46.489387939 +0200
@@ -1062,13 +1062,12 @@ static void acpi_add_id(struct acpi_devi
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
 



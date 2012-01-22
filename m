Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab2AVTDA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 14:03:00 -0500
Received: from www17.your-server.de ([213.133.104.17]:46623 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2AVTCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 14:02:47 -0500
Message-ID: <1327253698.1434.70.camel@localhost.localdomain>
Subject: [PATCH] Staging: android: ram_console: Use resource_size function
From: Thomas Meyer <thomas@m3y3r.de>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Jan 2012 18:34:58 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/resource_size.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/android/ram_console.c b/drivers/staging/android/ram_console.c
--- a/drivers/staging/android/ram_console.c 2012-01-10 08:19:54.746321665 +0100
+++ b/drivers/staging/android/ram_console.c 2012-01-22 12:45:22.929170341 +0100
@@ -351,7 +351,7 @@ static int ram_console_driver_probe(stru
 		       "%lx\n", res, pdev->num_resources, res ? res->flags : 0);
 		return -ENXIO;
 	}
-	buffer_size = res->end - res->start + 1;
+	buffer_size = resource_size(res);
 	start = res->start;
 	printk(KERN_INFO "ram_console: got buffer at %zx, size %zx\n",
 	       start, buffer_size);



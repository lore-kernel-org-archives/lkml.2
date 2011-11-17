Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab1KVLml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:42:41 -0500
Received: from www17.your-server.de ([213.133.104.17]:40341 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758478Ab1KVLmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:42:39 -0500
Subject: [PATCH] ACPI: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.278.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/acpi/bus.c b/drivers/acpi/bus.c
--- a/drivers/acpi/bus.c 2011-11-08 08:49:58.136858513 +0100
+++ b/drivers/acpi/bus.c 2011-11-08 10:40:30.311111025 +0100
@@ -503,13 +503,12 @@ acpi_status acpi_run_osc(acpi_handle han
 	}
 out_success:
 	context->ret.length = out_obj->buffer.length;
-	context->ret.pointer = kmalloc(context->ret.length, GFP_KERNEL);
+	context->ret.pointer = kmemdup(out_obj->buffer.pointer,
+				       context->ret.length, GFP_KERNEL);
 	if (!context->ret.pointer) {
 		status =  AE_NO_MEMORY;
 		goto out_kfree;
 	}
-	memcpy(context->ret.pointer, out_obj->buffer.pointer,
-		context->ret.length);
 	status =  AE_OK;
 
 out_kfree:

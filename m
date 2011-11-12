Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab1KLJOv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 04:14:51 -0500
Received: from www17.your-server.de ([213.133.104.17]:51459 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab1KLJOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 04:14:49 -0500
Message-ID: <1321089280.20155.126.camel@localhost.localdomain>
Subject: [PATCH] usb: OHCI/EHCI-XLS: Use resource_size v3
From: Thomas Meyer <thomas@m3y3r.de>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 12 Nov 2011 10:14:40 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size function on resource object
instead of explicit computation.

The semantic patch that makes this change is available
in scripts/coccinelle/api/resource_size.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/usb/host/ohci-xls.c b/drivers/usb/host/ohci-xls.c
--- a/drivers/usb/host/ohci-xls.c 2011-11-07 19:38:15.467036480 +0100
+++ b/drivers/usb/host/ohci-xls.c 2011-11-08 12:13:16.922398086 +0100
@@ -40,7 +40,7 @@ static int ohci_xls_probe_internal(const
 		goto err1;
 	}
 	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = res->end - res->start + 1;
+	hcd->rsrc_len = resource_size(res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
 			driver->description)) {
diff -u -p a/drivers/usb/host/ehci-xls.c b/drivers/usb/host/ehci-xls.c
--- a/drivers/usb/host/ehci-xls.c 2011-11-07 19:38:15.387035265 +0100
+++ b/drivers/usb/host/ehci-xls.c 2011-11-08 12:13:30.675915786 +0100
@@ -69,7 +69,7 @@ int ehci_xls_probe_internal(const struct
 	}
 
 	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = res->end - res->start + 1;
+	hcd->rsrc_len = resource_size(res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
 				driver->description)) {



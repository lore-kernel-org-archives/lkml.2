Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078Ab1KHTBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:01:30 -0500
Received: from www17.your-server.de ([213.133.104.17]:32907 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab1KHTB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:01:28 -0500
Subject: [PATCH] usb: OHCI/EHCI Use resource_size function
From: Thomas Meyer <thomas@m3y3r.de>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 19:49:09 +0100
Message-ID: <1320778149.8062.133.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use resource_size function on resource object
 instead of explicit computation.

 The semantic patch that makes this change is available
 in scripts/coccinelle/api/resource_size.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

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



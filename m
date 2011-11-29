Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab1LERbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:31:01 -0500
Received: from www17.your-server.de ([213.133.104.17]:38047 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932692Ab1LERa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:30:57 -0500
Subject: [PATCH] xHCI: Use kcalloc instead of kzalloc to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.337.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
--- a/drivers/usb/host/xhci-mem.c 2011-11-28 19:36:48.020115250 +0100
+++ b/drivers/usb/host/xhci-mem.c 2011-11-28 20:06:14.528280517 +0100
@@ -2037,11 +2037,12 @@ static int xhci_setup_port_arrays(struct
 	}
 
 	num_ports = HCS_MAX_PORTS(xhci->hcs_params1);
-	xhci->port_array = kzalloc(sizeof(*xhci->port_array)*num_ports, flags);
+	xhci->port_array = kcalloc(num_ports, sizeof(*xhci->port_array),
+				   flags);
 	if (!xhci->port_array)
 		return -ENOMEM;
 
-	xhci->rh_bw = kzalloc(sizeof(*xhci->rh_bw)*num_ports, flags);
+	xhci->rh_bw = kcalloc(num_ports, sizeof(*xhci->rh_bw), flags);
 	if (!xhci->rh_bw)
 		return -ENOMEM;
 	for (i = 0; i < num_ports; i++) {

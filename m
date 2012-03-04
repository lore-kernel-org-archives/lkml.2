Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab2CDNXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 08:23:18 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43656 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2CDNXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 08:23:17 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Mar 2012 14:23:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: sbp2: replace a GFP_ATOMIC allocation
Message-ID: <20120304142300.560717a1@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sbp2_send_management_orb() is called by sbp2_login, sbp2_reconnect, and
sbp2_remove, all which are able to sleep during memory allocations.
Actually, sbp2_send_management_orb() itself is a sleeping function.

Login and remove could allocate with GFP_KERNEL but reconnect needs
GFP_NOIO to ensure progress in low memory situations.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/sbp2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -569,7 +569,7 @@ static int sbp2_send_management_orb(stru
 	if (function == SBP2_LOGOUT_REQUEST && fw_device_is_shutdown(device))
 		return 0;
 
-	orb = kzalloc(sizeof(*orb), GFP_ATOMIC);
+	orb = kzalloc(sizeof(*orb), GFP_NOIO);
 	if (orb == NULL)
 		return -ENOMEM;
 


-- 
Stefan Richter
-=====-===-- --== --=--
http://arcgraph.de/sr/

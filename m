Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab1BPBqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:46:33 -0500
Received: from kroah.org ([198.145.64.141]:38788 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756696Ab1BPATJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:29 2011
Message-Id: <20110216001429.458513718@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [044/272] staging: hv: Enable sending GARP packet after live migration
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Haiyang Zhang <haiyangz@microsoft.com>

commit 7c161d0b900ea9bd9fc5ea5d3fa9916e9eb0dd88 upstream.

The hv_netvsc gets RNDIS_STATUS_MEDIA_CONNECT event after the VM
is live migrated. Adding call to netif_notify_peers() for this event
to send GARP (Gratuitous ARP) to notify network peers. Otherwise,
the VM's network connection may stop after a live migration.

This patch should also be applied to stable kernel 2.6.32 and later.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/netvsc_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -233,6 +233,7 @@ static void netvsc_linkstatus_callback(s
 	if (status == 1) {
 		netif_carrier_on(net);
 		netif_wake_queue(net);
+		netif_notify_peers(net);
 	} else {
 		netif_carrier_off(net);
 		netif_stop_queue(net);



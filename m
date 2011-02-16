Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab1BPBq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:46:58 -0500
Received: from kroah.org ([198.145.64.141]:38782 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795Ab1BPATH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:29 2011
Message-Id: <20110216001429.371193991@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [043/272] staging: hv: Removed unneeded call to netif_stop_queue() in hv_netvsc
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hank Janssen <hjanssen@microsoft.com>

commit a786f915274ba446865a996515c7790a930f04dd upstream.

Removed the call to netif_stop_queue() in netvsc_probe() as
the queue is not initialized at that point and further call
to it after queue initialization is really not necessary.

This change was prompted after an upstream change went into
2.6.37 (netif_tx_stop_queue) that now checks if netif_stop_queue
is called before register with netdev is done.

This will eliminate the warning message to the log when hv_netvsc
driver starts up.

Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/netvsc_drv.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -355,7 +355,6 @@ static int netvsc_probe(struct device *d
 
 	/* Set initial state */
 	netif_carrier_off(net);
-	netif_stop_queue(net);
 
 	net_device_ctx = netdev_priv(net);
 	net_device_ctx->device_ctx = device_ctx;



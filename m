Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583Ab1C3WJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:09:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:53540 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933180Ab1C3VGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447170"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [34/275] staging: hv: Enable sending GARP packet after live migration
Message-Id: <20110330210429.7CA053E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/staging/hv/netvsc_drv.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/staging/hv/netvsc_drv.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/hv/netvsc_drv.c	2011-03-29 22:51:55.255309324 -0700
+++ linux-2.6.35.y/drivers/staging/hv/netvsc_drv.c	2011-03-29 23:02:58.898328360 -0700
@@ -249,6 +249,7 @@
 	if (status == 1) {
 		netif_carrier_on(net);
 		netif_wake_queue(net);
+		netif_notify_peers(net);
 	} else {
 		netif_carrier_off(net);
 		netif_stop_queue(net);

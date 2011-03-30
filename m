Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965054Ab1C3VRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:17:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:24598 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965250Ab1C3VJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673448722"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: sgruszka@redhat.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [246/275] myri10ge: fix rmmod crash
Message-Id: <20110330210812.B2EED3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Stanislaw Gruszka <sgruszka@redhat.com>

commit cda6587c21a887254c8ed4b58da8fcc4040ab557 upstream.

Rmmod myri10ge crash at free_netdev() -> netif_napi_del(), because napi
structures are already deallocated. To fix call netif_napi_del() before
kfree() at myri10ge_free_slices().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/myri10ge/myri10ge.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/net/myri10ge/myri10ge.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/myri10ge/myri10ge.c	2011-03-29 22:50:13.908902524 -0700
+++ linux-2.6.35.y/drivers/net/myri10ge/myri10ge.c	2011-03-29 23:03:03.419212681 -0700
@@ -3600,6 +3600,7 @@
 			dma_free_coherent(&pdev->dev, bytes,
 					  ss->fw_stats, ss->fw_stats_bus);
 			ss->fw_stats = NULL;
+			netif_napi_del(&ss->napi);
 		}
 	}
 	kfree(mgp->ss);

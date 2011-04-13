Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab1DMQaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:30:21 -0400
Received: from kroah.org ([198.145.64.141]:52668 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932691Ab1DMQMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:12:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:43 2011
Message-Id: <20110413161042.970380372@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:09:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [05/71] myri10ge: fix rmmod crash
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit cda6587c21a887254c8ed4b58da8fcc4040ab557 upstream.

Rmmod myri10ge crash at free_netdev() -> netif_napi_del(), because napi
structures are already deallocated. To fix call netif_napi_del() before
kfree() at myri10ge_free_slices().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/myri10ge/myri10ge.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -3643,6 +3643,7 @@ static void myri10ge_free_slices(struct
 			dma_free_coherent(&pdev->dev, bytes,
 					  ss->fw_stats, ss->fw_stats_bus);
 			ss->fw_stats = NULL;
+			netif_napi_del(&ss->napi);
 		}
 	}
 	kfree(mgp->ss);



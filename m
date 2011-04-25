Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab1DYUoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:44:07 -0400
Received: from 1wt.eu ([62.212.114.60]:34329 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272Ab1DYUYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:49 -0400
Message-Id: <20110425200237.944385199@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:26 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 114/173] myri10ge: fix rmmod crash
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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
@@ -3640,6 +3640,7 @@ static void myri10ge_free_slices(struct
 			dma_free_coherent(&pdev->dev, bytes,
 					  ss->fw_stats, ss->fw_stats_bus);
 			ss->fw_stats = NULL;
+			netif_napi_del(&ss->napi);
 		}
 	}
 	kfree(mgp->ss);



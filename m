Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab0HPQ1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:27:35 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50786 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974Ab0HPQ1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:27:33 -0400
Date: Mon, 16 Aug 2010 18:27:30 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Luciano Coelho <luciano.coelho@nokia.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 10/16] drivers/net/wireless/wl12xx: Use available error codes
Message-ID: <Pine.LNX.4.64.1008161827140.19313@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error codes are stored in ret, but the return value is always 0.  Return
ret instead.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
local idexpression x;
constant C;
@@

if (...) { ...
  x = -C
  ... when != x
(
  return <+...x...+>;
|
  return NULL;
|
  return;
|
* return ...;
)
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This changes the semantics and has not been tested.

 drivers/net/wireless/wl12xx/wl1271_acx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index bb245f0..f03ad08 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -269,7 +269,7 @@ int wl1271_acx_pd_threshold(struct wl1271 *wl)
 
 out:
 	kfree(pd);
-	return 0;
+	return ret;
 }
 
 int wl1271_acx_slot(struct wl1271 *wl, enum acx_slot_type slot_time)

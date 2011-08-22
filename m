Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab1HVOQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:16:22 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35811 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab1HVOQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:16:20 -0400
Date: Mon, 22 Aug 2011 16:16:14 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Pierre Louis Aublin <pierre-louis.aublin@inria.fr>
Cc: Bing Zhao <bzhao@marvell.com>, kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] drivers/net/wireless/mwifiex/scan.c: test the just-initialized
 value
In-Reply-To: <4E52638C.8080407@inria.fr>
Message-ID: <Pine.LNX.4.64.1108221615450.10948@ask.diku.dk>
References: <1314021636-11528-4-git-send-email-julia@diku.dk>
 <4E52638C.8080407@inria.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Test the just-initialized value rather than some other one.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier x,y,f!={PTR_ERR,ERR_PTR,ERR_CAST};
statement S;
@@

x = f(...);
(
if (\(x == NULL\|IS_ERR(x)\)) S
|
*if (\(y == NULL\|IS_ERR(y)\))
 { ... when != x
   return ...; }
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/wireless/mwifiex/scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index b28241c..37ca2f9 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1480,8 +1480,8 @@ mwifiex_update_curr_bss_params(struct mwifiex_private *priv,
 		return -ENOMEM;
 	}
 	beacon_ie = kzalloc(ie_len, GFP_KERNEL);
-	if (!bss_desc) {
-		dev_err(priv->adapter->dev, " failed to alloc bss_desc\n");
+	if (!beacon_ie) {
+		dev_err(priv->adapter->dev, " failed to alloc beacon_ie\n");
 		return -ENOMEM;
 	}
 	memcpy(beacon_ie, ie_buf, ie_len);

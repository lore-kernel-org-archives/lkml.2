Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100Ab0G3RXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:23:52 -0400
Received: from kroah.org ([198.145.64.141]:52298 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758908Ab0G3RUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:20:23 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:13 2010
Message-Id: <20100730171513.483499600@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:16:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
        Divy Le Ray <divy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [153/165] cxgb3: fix linkup issue
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

commit 9441cad99b4b09d6b627351c2d282833868c116c upstream.

I encountered an issue that not to link up on cxgb3 fabric.
I bisected and found that this regression was introduced by
0f07c4ee8c800923ae7918c231532a9256233eed.

Correct to pass phy_addr to cphy_init() at t3_xaui_direct_phy_prep().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Acked-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/cxgb3/ael1002.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/cxgb3/ael1002.c
+++ b/drivers/net/cxgb3/ael1002.c
@@ -934,7 +934,7 @@ static struct cphy_ops xaui_direct_ops =
 int t3_xaui_direct_phy_prep(struct cphy *phy, struct adapter *adapter,
 			    int phy_addr, const struct mdio_ops *mdio_ops)
 {
-	cphy_init(phy, adapter, MDIO_PRTAD_NONE, &xaui_direct_ops, mdio_ops,
+	cphy_init(phy, adapter, phy_addr, &xaui_direct_ops, mdio_ops,
 		  SUPPORTED_10000baseT_Full | SUPPORTED_AUI | SUPPORTED_TP,
 		  "10GBASE-CX4");
 	return 0;



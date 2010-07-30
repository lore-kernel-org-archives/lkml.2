Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950Ab0G3RUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:20:43 -0400
Received: from kroah.org ([198.145.64.141]:52264 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758892Ab0G3RUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:20:17 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:13 2010
Message-Id: <20100730171513.147652669@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:16:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ayaz Abdulla <aabdulla@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [149/165] forcedeth: fix tx limit2 flag check
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ayaz Abdulla <aabdulla@nvidia.com>

commit 5c659322a904a7cc0265e7b183372b9bdebec6db upstream.

This is a fix for bug 572201 @ bugs.debian.org

This patch fixes the TX_LIMIT feature flag. The previous logic check
for TX_LIMIT2 also took into account a device that only had TX_LIMIT
set.

Reported-by: Stephen Mulcahu <stephen.mulcahy@deri.org>
Reported-by: Ben Huchings <ben@decadent.org.uk>
Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/forcedeth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -5900,7 +5900,7 @@ static int __devinit nv_probe(struct pci
 	/* Limit the number of tx's outstanding for hw bug */
 	if (id->driver_data & DEV_NEED_TX_LIMIT) {
 		np->tx_limit = 1;
-		if ((id->driver_data & DEV_NEED_TX_LIMIT2) &&
+		if (((id->driver_data & DEV_NEED_TX_LIMIT2) == DEV_NEED_TX_LIMIT2) &&
 		    pci_dev->revision >= 0xA2)
 			np->tx_limit = 0;
 	}



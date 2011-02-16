Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab1BPAby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:31:54 -0500
Received: from kroah.org ([198.145.64.141]:49789 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932439Ab1BPAYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:53 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:49 2011
Message-Id: <20110216001449.189460555@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shawn Guo <shawn.guo@freescale.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [241/272] net/fec: fix MMFR_OP type in fec_enet_mdio_write
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shawn Guo <shawn.guo@freescale.com>

commit 862f0982eadcea0e114576c57ea426d3d51a69a6 upstream.

FEC_MMFR_OP_WRITE should be used than FEC_MMFR_OP_READ in
a mdio write operation.

It's probably a typo introduced by commit:

e6b043d512fa8d9a3801bf5d72bfa3b8fc3b3cc8
netdev/fec.c: add phylib supporting to enable carrier detection (v2)

Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/fec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/fec.c
+++ b/drivers/net/fec.c
@@ -651,8 +651,8 @@ static int fec_enet_mdio_write(struct mi
 	fep->mii_timeout = 0;
 	init_completion(&fep->mdio_done);
 
-	/* start a read op */
-	writel(FEC_MMFR_ST | FEC_MMFR_OP_READ |
+	/* start a write op */
+	writel(FEC_MMFR_ST | FEC_MMFR_OP_WRITE |
 		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
 		FEC_MMFR_TA | FEC_MMFR_DATA(value),
 		fep->hwp + FEC_MII_DATA);



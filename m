Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2GWCJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:09:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53985 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752878Ab2GWBmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:15 -0400
Message-Id: <20120723010652.135504641@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:06:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matt Carlson <mcarlson@broadcom.com>,
        Christian Kujau <lists@nerdbynature.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 004/108] tg3: Apply short DMA frag workaround to 5906
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Carlson <mcarlson@broadcom.com>

commit b7abee6ef888117f92db370620ebf116a38e3f4d upstream.

5906 devices also need the short DMA fragment workaround.  This patch
makes the necessary change.

Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
Tested-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/broadcom/tg3.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index edeeb51..e47ff8b 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -14275,7 +14275,8 @@ static int __devinit tg3_get_invariants(struct tg3 *tp)
 		}
 	}
 
-	if (tg3_flag(tp, 5755_PLUS))
+	if (tg3_flag(tp, 5755_PLUS) ||
+	    GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5906)
 		tg3_flag_set(tp, SHORT_DMA_BUG);
 
 	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5719)



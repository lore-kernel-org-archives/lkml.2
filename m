Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab2KNFuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:50:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54996 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874Ab2KNFuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:08 -0500
Message-Id: <20121114053945.118561949@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:55 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mirko Lindner <mlindner@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 82/82] sky2: Fix for interrupt handler
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mirko Lindner <mlindner@marvell.com>

commit d663d181b9e92d80c2455e460e932d34e7a2a7ae upstream.

Re-enable interrupts if it is not our interrupt

Signed-off-by: Mirko Lindner <mlindner@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/marvell/sky2.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index f1163b2..2b0748d 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -3080,8 +3080,10 @@ static irqreturn_t sky2_intr(int irq, void *dev_id)
 
 	/* Reading this mask interrupts as side effect */
 	status = sky2_read32(hw, B0_Y2_SP_ISRC2);
-	if (status == 0 || status == ~0)
+	if (status == 0 || status == ~0) {
+		sky2_write32(hw, B0_Y2_SP_ICR, 2);
 		return IRQ_NONE;
+	}
 
 	prefetch(&hw->st_le[hw->st_idx]);
 



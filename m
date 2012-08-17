Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030734Ab2HQD3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:29:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46840 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030680Ab2HQD1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:27:08 -0400
Message-Id: <20120817030247.839326945@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:03:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tushar Dave <tushar.n.dave@intel.com>,
        Fabio Futigami <ffutigam@redhat.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: [ 26/37] e1000e: NIC goes up and immediately goes down
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tushar Dave <tushar.n.dave@intel.com>

commit b7ec70be01a87f2c85df3ae11046e74f9b67e323 upstream.

Found that commit d478eb44 was a bad commit.
If the link partner is transmitting codeword (even if NULL codeword),
then the RXCW.C bit will be set so check for RXCW.CW is unnecessary.
Ref: RH BZ 840642

Reported-by: Fabio Futigami <ffutigam@redhat.com>
Signed-off-by: Tushar Dave <tushar.n.dave@intel.com>
CC: Marcelo Ricardo Leitner <mleitner@redhat.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/intel/e1000e/82571.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/82571.c b/drivers/net/ethernet/intel/e1000e/82571.c
index 0b3bade..2a4ded2 100644
--- a/drivers/net/ethernet/intel/e1000e/82571.c
+++ b/drivers/net/ethernet/intel/e1000e/82571.c
@@ -1601,10 +1601,8 @@ static s32 e1000_check_for_serdes_link_82571(struct e1000_hw *hw)
 			 * auto-negotiation in the TXCW register and disable
 			 * forced link in the Device Control register in an
 			 * attempt to auto-negotiate with our link partner.
-			 * If the partner code word is null, stop forcing
-			 * and restart auto negotiation.
 			 */
-			if ((rxcw & E1000_RXCW_C) || !(rxcw & E1000_RXCW_CW))  {
+			if (rxcw & E1000_RXCW_C) {
 				/* Enable autoneg, and unforce link up */
 				ew32(TXCW, mac->txcw);
 				ew32(CTRL, (ctrl & ~E1000_CTRL_SLU));



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab2HMWTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:19:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61337 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab2HMWTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:19:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Fabio Futigami <ffutigam@redhat.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: [ 62/65] e1000e: NIC goes up and immediately goes down
Date: Mon, 13 Aug 2012 15:14:46 -0700
Message-Id: <20120813221420.464716780@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813221414.965154048@linuxfoundation.org>
References: <20120813221414.965154048@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000e/82571.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/82571.c
+++ b/drivers/net/ethernet/intel/e1000e/82571.c
@@ -1582,10 +1582,8 @@ static s32 e1000_check_for_serdes_link_8
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



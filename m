Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761489Ab2DKXV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:21:28 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51108 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761431Ab2DKXV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:21:26 -0400
Message-Id: <20120411231035.890328958@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 02/59] tg3: Fix 5717 serdes powerdown problem
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Matt Carlson <mcarlson@broadcom.com>

[ Upstream commit 085f1afc56619bda424941412fdeaff1e32c21dc ]

If port 0 of a 5717 serdes device powers down, it hides the phy from
port 1.  This patch works around the problem by keeping port 0's phy
powered up.

Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/tg3.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -2794,7 +2794,9 @@ static void tg3_power_down_phy(struct tg
 	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5700 ||
 	    GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5704 ||
 	    (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5780 &&
-	     (tp->phy_flags & TG3_PHYFLG_MII_SERDES)))
+	     (tp->phy_flags & TG3_PHYFLG_MII_SERDES)) ||
+	    (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5717 &&
+	     !tp->pci_fn))
 		return;
 
 	if (GET_CHIP_REV(tp->pci_chip_rev_id) == CHIPREV_5784_AX ||



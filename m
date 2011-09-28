Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab1I1Wrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:47:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933121Ab1I1Wrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:47:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:42 2011
Message-Id: <20110928220142.484527819@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matt Carlson <mcarlson@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [163/244] tg3: Add 5719 and 5720 to EEE_CAP list
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt Carlson <mcarlson@broadcom.com>

commit 5baa5e9aa28baccd2a1227095c25bb3e999f250d upstream.

This patch adds the 5719 and the 5720 to the list of devices that are
EEE capable.

Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
Reviewed-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/tg3.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -12941,7 +12941,9 @@ static int __devinit tg3_phy_probe(struc
 	}
 
 	if (!(tp->phy_flags & TG3_PHYFLG_ANY_SERDES) &&
-	    ((tp->pdev->device == TG3PCI_DEVICE_TIGON3_5718 &&
+	    (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5719 ||
+	     GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5720 ||
+	     (tp->pdev->device == TG3PCI_DEVICE_TIGON3_5718 &&
 	      tp->pci_chip_rev_id != CHIPREV_ID_5717_A0) ||
 	     (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_57765 &&
 	      tp->pci_chip_rev_id != CHIPREV_ID_57765_A0)))



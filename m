Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab0G3RE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:04:56 -0400
Received: from kroah.org ([198.145.64.141]:35559 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530Ab0G3RDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:03:41 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 09:59:55 2010
Message-Id: <20100730165954.966258870@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 09:57:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Darrick J. Wong" <djwong@us.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [13/17] x86, Calgary: Limit the max PHB number to 256
In-Reply-To: <20100730170054.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Darrick J. Wong <djwong@us.ibm.com>

commit d596043d71ff0d7b3d0bead19b1d68c55f003093 upstream.

The x3950 family can have as many as 256 PCI buses in a single system, so
change the limits to the maximum.  Since there can only be 256 PCI buses in one
domain, we no longer need the BUG_ON check.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
LKML-Reference: <20100701004519.GQ15515@tux1.beaverton.ibm.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/pci-calgary_64.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -109,7 +109,7 @@ int use_calgary __read_mostly = 0;
  * x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
  * x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
  */
-#define MAX_PHB_BUS_NUM		384
+#define MAX_PHB_BUS_NUM		256
 
 #define PHBS_PER_CALGARY	  4
 
@@ -1097,8 +1097,6 @@ static int __init calgary_init_one(struc
 	struct iommu_table *tbl;
 	int ret;
 
-	BUG_ON(dev->bus->number >= MAX_PHB_BUS_NUM);
-
 	bbar = busno_to_bbar(dev->bus->number);
 	ret = calgary_setup_tar(dev, bbar);
 	if (ret)



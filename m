Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab0GAApZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 20:45:25 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46862 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab0GAApX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 20:45:23 -0400
Date: Wed, 30 Jun 2010 17:45:19 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, muli@il.ibm.com,
       cschultz@linux.vnet.ibm.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: [PATCH] x86, Calgary: Increase max PHB number
Message-ID: <20100701004519.GQ15515@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20100624212647.GI15515@tux1.beaverton.ibm.com> <tip-499a00e92dd9a75395081f595e681629eb1eebad@git.kernel.org> <20100629155151.7caaff4b.akpm@linux-foundation.org> <4C2BB7C0.9040000@zytor.com> <20100630214923.GP15515@tux1.beaverton.ibm.com> <4C2BCDC6.1010004@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2BCDC6.1010004@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x3950 family can have as many as 256 PCI buses in a single system, so
change the limits to the maximum.  Since there can only be 256 PCI buses in one
domain, we no longer need the BUG_ON check.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 arch/x86/kernel/pci-calgary_64.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)


diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 0b96b55..078d4ec 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -110,7 +110,7 @@ int use_calgary __read_mostly = 0;
  * x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
  * x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
  */
-#define MAX_PHB_BUS_NUM		384
+#define MAX_PHB_BUS_NUM		256
 
 #define PHBS_PER_CALGARY	  4
 
@@ -1056,8 +1056,6 @@ static int __init calgary_init_one(struct pci_dev *dev)
 	struct iommu_table *tbl;
 	int ret;
 
-	BUG_ON(dev->bus->number >= MAX_PHB_BUS_NUM);
-
 	bbar = busno_to_bbar(dev->bus->number);
 	ret = calgary_setup_tar(dev, bbar);
 	if (ret)

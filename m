Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab0GAFqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 01:46:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:44758 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab0GAFqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 01:46:35 -0400
Date: Thu, 1 Jul 2010 05:45:53 GMT
From: "tip-bot for Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       djwong@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       djwong@us.ibm.com, tglx@linutronix.de
In-Reply-To: <20100701004519.GQ15515@tux1.beaverton.ibm.com>
References: <20100701004519.GQ15515@tux1.beaverton.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, Calgary: Limit the max PHB number to 256
Message-ID: <tip-d596043d71ff0d7b3d0bead19b1d68c55f003093@git.kernel.org>
Git-Commit-ID: d596043d71ff0d7b3d0bead19b1d68c55f003093
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 01 Jul 2010 05:46:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d596043d71ff0d7b3d0bead19b1d68c55f003093
Gitweb:     http://git.kernel.org/tip/d596043d71ff0d7b3d0bead19b1d68c55f003093
Author:     Darrick J. Wong <djwong@us.ibm.com>
AuthorDate: Wed, 30 Jun 2010 17:45:19 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 30 Jun 2010 22:41:42 -0700

x86, Calgary: Limit the max PHB number to 256

The x3950 family can have as many as 256 PCI buses in a single system, so
change the limits to the maximum.  Since there can only be 256 PCI buses in one
domain, we no longer need the BUG_ON check.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
LKML-Reference: <20100701004519.GQ15515@tux1.beaverton.ibm.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab0FYPaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 11:30:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:51324 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab0FYPaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 11:30:23 -0400
Date: Fri, 25 Jun 2010 15:29:50 GMT
From: "tip-bot for Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       djwong@us.ibm.com, muli@il.ibm.com, cschultz@linux.vnet.ibm.com,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       djwong@us.ibm.com, muli@il.ibm.com, cschultz@linux.vnet.ibm.com,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100624212647.GI15515@tux1.beaverton.ibm.com>
References: <20100624212647.GI15515@tux1.beaverton.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, Calgary: Increase max PHB number
Message-ID: <tip-499a00e92dd9a75395081f595e681629eb1eebad@git.kernel.org>
Git-Commit-ID: 499a00e92dd9a75395081f595e681629eb1eebad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 25 Jun 2010 15:29:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  499a00e92dd9a75395081f595e681629eb1eebad
Gitweb:     http://git.kernel.org/tip/499a00e92dd9a75395081f595e681629eb1eebad
Author:     Darrick J. Wong <djwong@us.ibm.com>
AuthorDate: Thu, 24 Jun 2010 14:26:47 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 25 Jun 2010 16:14:58 +0200

x86, Calgary: Increase max PHB number

Newer systems (x3950M2) can have 48 PHBs per chassis and 8
chassis, so bump the limits up and provide an explanation
of the requirements for each class.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Corinna Schultz <cschultz@linux.vnet.ibm.com>
Cc: <stable@kernel.org>
LKML-Reference: <20100624212647.GI15515@tux1.beaverton.ibm.com>
[ v2: Fixed build bug, added back PHBS_PER_CALGARY == 4 ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/pci-calgary_64.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index fb99f7e..0b96b55 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -103,11 +103,16 @@ int use_calgary __read_mostly = 0;
 #define PMR_SOFTSTOPFAULT	0x40000000
 #define PMR_HARDSTOP		0x20000000
 
-#define MAX_NUM_OF_PHBS		8 /* how many PHBs in total? */
-#define MAX_NUM_CHASSIS		8 /* max number of chassis */
-/* MAX_PHB_BUS_NUM is the maximal possible dev->bus->number */
-#define MAX_PHB_BUS_NUM		(MAX_NUM_OF_PHBS * MAX_NUM_CHASSIS * 2)
-#define PHBS_PER_CALGARY	4
+/*
+ * The maximum PHB bus number.
+ * x3950M2 (rare): 8 chassis, 48 PHBs per chassis = 384
+ * x3950M2: 4 chassis, 48 PHBs per chassis        = 192
+ * x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
+ * x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
+ */
+#define MAX_PHB_BUS_NUM		384
+
+#define PHBS_PER_CALGARY	  4
 
 /* register offsets in Calgary's internal register space */
 static const unsigned long tar_offsets[] = {

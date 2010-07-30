Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350Ab0G3SoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:44:24 -0400
Received: from kroah.org ([198.145.64.141]:35863 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309Ab0G3RfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:35:02 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:09 2010
Message-Id: <20100730173109.219062948@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Darrick J. Wong" <djwong@us.ibm.com>,
        Muli Ben-Yehuda <muli@il.ibm.com>,
        Corinna Schultz <cschultz@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [072/140] x86, Calgary: Increase max PHB number
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Darrick J. Wong <djwong@us.ibm.com>

commit 499a00e92dd9a75395081f595e681629eb1eebad upstream.

Newer systems (x3950M2) can have 48 PHBs per chassis and 8
chassis, so bump the limits up and provide an explanation
of the requirements for each class.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Corinna Schultz <cschultz@linux.vnet.ibm.com>
LKML-Reference: <20100624212647.GI15515@tux1.beaverton.ibm.com>
[ v2: Fixed build bug, added back PHBS_PER_CALGARY == 4 ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/pci-calgary_64.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

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



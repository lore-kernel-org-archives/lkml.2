Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab0FOUQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 16:16:18 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59894 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab0FOUQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 16:16:16 -0400
Message-ID: <20100615161528.wqx1w1y3ok08w88w@imap.linux.ibm.com>
Date: Tue, 15 Jun 2010 16:15:28 -0400
From: Corinna Schultz <cschultz@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: coschult@us.ibm.com, akpm@linux-foundation.org,
       djwong <djwong@linux.vnet.ibm.com>, mingo <mingo@elte.hu>
Subject: [PATCH RESEND] Calgary: increase max PHB number
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer systems (x3950M2) can have 48 PHBs per chassis and 8 chassis, so  
bump the
limits up and provide an explanation of the requirements for each class.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
---

  arch/x86/kernel/pci-calgary_64.c |   13 +++++++++----
  1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c  
b/arch/x86/kernel/pci-calgary_64.c
index e6ec8a2..4b7eb90 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -102,10 +102,15 @@ int use_calgary __read_mostly = 0;
  #define PMR_SOFTSTOPFAULT		 0x40000000
  #define PMR_HARDSTOP		 		 0x20000000

-#define MAX_NUM_OF_PHBS		 		 8 /* how many PHBs in total? */
-#define MAX_NUM_CHASSIS		 		 8 /* max number of chassis */
-/* MAX_PHB_BUS_NUM is the maximal possible dev->bus->number */
-#define MAX_PHB_BUS_NUM		 		 (MAX_NUM_OF_PHBS * MAX_NUM_CHASSIS * 2)
+/*
+ * The maximum PHB bus number.
+ * x3950M2 (rare): 8 chassis, 48 PHBs per chassis = 384
+ * x3950M2: 4 chassis, 48 PHBs per chassis        = 192
+ * x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
+ * x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
+ */
+#define MAX_PHB_BUS_NUM		 		 384
+
  #define PHBS_PER_CALGARY		 4

  /* register offsets in Calgary's internal register space */


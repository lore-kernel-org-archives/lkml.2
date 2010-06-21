Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab0FUSl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 14:41:59 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41456 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab0FUSlz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 14:41:55 -0400
Message-ID: <20100621144150.2j0xuwksg4cwg84c@imap.linux.ibm.com>
Date: Mon, 21 Jun 2010 14:41:50 -0400
From: Corinna Schultz <cschultz@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, djwong@us.ibm.com,
       coschult@us.ibm.com
Subject: [PATCH RESEND] (revised) Calgary: increase max PHB number
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a small difference in 35-rc3 that prevented this patch from  
applying, so I regenerated it.

===============================

Newer systems (x3950M2) can have 48 PHBs per chassis and 8 chassis, so  
bump the
limits up and provide an explanation of the requirements for each class.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

--- a/arch/x86/kernel/pci_calgary_64.c     2010-06-21 10:57:15.000000000 -0700
+++ b/arch/x86/kernel/pci_calgary_64.c    2010-06-21 11:01:56.000000000 -0700
@@ -103,10 +103,15 @@
  #define PMR_SOFTSTOPFAULT      0x40000000
  #define PMR_HARDSTOP           0x20000000

-#define MAX_NUM_OF_PHBS                8 /* how many PHBs in total? */
-#define MAX_NUM_CHASSIS                8 /* max number of chassis */
-/* MAX_PHB_BUS_NUM is the maximal possible dev->bus->number */
-#define MAX_PHB_BUS_NUM                (MAX_NUM_OF_PHBS *  
MAX_NUM_CHASSIS * 2)
+/*
+ * The maximum PHB bus number.
+ * x3950M2 (rare): 8 chassis, 48 PHBs per chassis = 384
+ * x3950M2: 4 chassis, 48 PHBs per chassis        = 192
+ * x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
+ * x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
+ */
+#define MAX_PHB_BUS_NUM       384
+
  #define PHBS_PER_CALGARY       4

  /* register offsets in Calgary's internal register space */






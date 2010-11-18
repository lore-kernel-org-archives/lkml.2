Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718Ab0KRVuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:50:13 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51910 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760708Ab0KRVuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:50:11 -0500
Date: Thu, 18 Nov 2010 15:50:02 -0600
From: Sonny Rao <sonnyrao@us.ibm.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: Milton Miller <miltonm@bga.com>, Linux Driver <Linux-Driver@qlogic.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ron Mercer <ron.mercer@qlogic.com>, sonnyrao@linux.vnet.ibm.com
Subject: [PATCH] qlge: Fix incorrect usage of module parameters and netdev
 msg level
Message-ID: <20101118215002.GS32203@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver appears to be mistaking the permission field with default value
in the case of debug and qlge_irq_type.

Driver is also passing debug as a bitmask into netif_msg_init()
which wants a number of bits.  Ron Mercer suggests we should
change this to pass in -1 so the defaults get used instead,
which makes the default much less verbose.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
---

v2: Changed debug to be -1 and updated changelog

 drivers/net/qlge/qlge_main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/qlge/qlge_main.c b/drivers/net/qlge/qlge_main.c
index d9a7626..66878bb 100644
--- a/drivers/net/qlge/qlge_main.c
+++ b/drivers/net/qlge/qlge_main.c
@@ -62,15 +62,15 @@ static const u32 default_msg =
 /* NETIF_MSG_PKTDATA | */
     NETIF_MSG_HW | NETIF_MSG_WOL | 0;
 
-static int debug = 0x00007fff;	/* defaults above */
-module_param(debug, int, 0);
+static int debug = -1;	/* defaults above */
+module_param(debug, int, 0664);
 MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 
 #define MSIX_IRQ 0
 #define MSI_IRQ 1
 #define LEG_IRQ 2
 static int qlge_irq_type = MSIX_IRQ;
-module_param(qlge_irq_type, int, MSIX_IRQ);
+module_param(qlge_irq_type, int, 0664);
 MODULE_PARM_DESC(qlge_irq_type, "0 = MSI-X, 1 = MSI, 2 = Legacy.");
 
 static int qlge_mpi_coredump;

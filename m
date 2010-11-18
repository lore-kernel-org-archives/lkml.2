Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0KRTVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:21:53 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35968 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab0KRTVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:21:50 -0500
X-Sieve: CMU Sieve 2.3
X-Spam-TestScore: ALL_TRUSTED=-1.44,DNS_FROM_RFC_ABUSE=0.479,TW_QL=0.077
X-Spam-TokenSummary: Bayes not run.
X-Spam-Relay-Country: 
From: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
To: netdev@vger.kernel.org
Cc: Sonny Rao <sonnyrao@linux.vnet.ibm.com>, Milton Miller <miltonm@bga.com>,
        Ron Mercer <ron.mercer@qlogic.com>, linux-driver@qlogic.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] qlge: Fix incorrect usage of module parameters and netdev msg
 level
Date: Thu, 18 Nov 2010 04:25:03 -0600
Message-Id: <1290075903-3038-1-git-send-email-sonnyrao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.5
X-Xagent-From: sonnyrao@linux.vnet.ibm.com
X-Xagent-To: sonnyrao@linux.vnet.ibm.com
X-Xagent-Gateway: vmsdvm6.vnet.ibm.com (XAGENTU at VMSDVM6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver appears to be mistaking the permission field with default value
in the case of debug and qlge_irq_type.

Driver is also passing debug as a bitmask into netif_msg_init()
which really wants a number of bits, so fix that.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
---
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
+static int debug = 15;	/* defaults above */
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
-- 
1.5.6.5


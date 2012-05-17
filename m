Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030378Ab2EQTKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 15:10:36 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:31726
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967636Ab2EQTKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 15:10:35 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Timur Tabi <timur@freescale.com>
To: <linuxppc-dev@linux.freescale.net>, Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Anatolij Gustschin <agust@denx.de>, <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] [for 3.4] drivers/virt: the Freescale hypervisor driver doesn't need to check MSR[GS]
Date: Thu, 17 May 2012 14:10:27 -0500
Message-ID: <1337281828-31120-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSR[GS] bit indicates whether the kernel is running in processor guest
state mode, but such a check is unnecessary.  The driver already checks
for the /hypervisor node and the fsl,hv-version property, so it already
knows that it's running under the Freescale hypervisor.

There is nothing in the driver that inherently requires guest state,
anyway.

This fixes a break that can occur in some randconfig builds.

Signed-off-by: Timur Tabi <timur@freescale.com>
---
 drivers/virt/fsl_hypervisor.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/virt/fsl_hypervisor.c b/drivers/virt/fsl_hypervisor.c
index 4939e0c..d294f67 100644
--- a/drivers/virt/fsl_hypervisor.c
+++ b/drivers/virt/fsl_hypervisor.c
@@ -796,9 +796,6 @@ static int has_fsl_hypervisor(void)
 	struct device_node *node;
 	int ret;
 
-	if (!(mfmsr() & MSR_GS))
-		return 0;
-
 	node = of_find_node_by_path("/hypervisor");
 	if (!node)
 		return 0;
-- 
1.7.3.4



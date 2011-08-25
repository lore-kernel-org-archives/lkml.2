Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1HYQUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:20:50 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:26452 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab1HYQUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:20:49 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Timur Tabi <timur@freescale.com>
To: <greg@kroah.com>, <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
Subject: [PATCH] tty/powerpc: fix build break with ehv_bytechan.c on allyesconfig
Date: Thu, 25 Aug 2011 11:20:45 -0500
Message-ID: <1314289245-14946-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig for the ePAPR hypervisor byte channel driver has a "depends on PPC",
which means it would compile on all PowerPC platforms, even though it's
only been tested on Freescale platforms.  Change the Kconfig to depend on
FSL_SOC instead.

Signed-off-by: Timur Tabi <timur@freescale.com>
---
 drivers/tty/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index f1ea59b..535af0a 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -353,7 +353,7 @@ config TRACE_SINK
 
 config PPC_EPAPR_HV_BYTECHAN
 	tristate "ePAPR hypervisor byte channel driver"
-	depends on PPC
+	depends on FSL_SOC
 	help
 	  This driver creates /dev entries for each ePAPR hypervisor byte
 	  channel, thereby allowing applications to communicate with byte
-- 
1.7.3.4



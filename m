Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab1ISSBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:01:48 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45642 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab1ISSBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:01:47 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6474"; a="119838395"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] ARM: debug: Move DEBUG_ICEDCC into the DEBUG_LL choice
Date: Mon, 19 Sep 2011 11:01:40 -0700
Message-Id: <1316455300-5752-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.7.rc0.70.g82660
In-Reply-To: <1316455300-5752-1-git-send-email-sboyd@codeaurora.org>
References: <20110916114140.GA31334@e102144-lin.cambridge.arm.com>
 <1316455300-5752-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEBUG_ICEDCC support is just another DEBUG_LL choice and
selecting it along with other DEBUG_LL options doesn't make
much sense. Put it into the DEBUG_LL choice to avoid confusion.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig.debug |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index a37e646..9661c51 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -81,6 +81,18 @@ choice
 	prompt "Kernel low-level debugging port"
 	depends on DEBUG_LL
 
+	config DEBUG_ICEDCC
+		bool "Kernel low-level debugging via EmbeddedICE DCC channel"
+		depends on DEBUG_LL
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to the EmbeddedICE macrocell's DCC channel using
+		  co-processor 14. This is known to work on the ARM9 style ICE
+		  channel and on the XScale with the PEEDI.
+
+		  It does include a timeout to ensure that the system does not
+		  totally freeze when there is nothing connected to read.
+
 	config DEBUG_DC21285_PORT
 		bool "Kernel low-level debugging messages via footbridge serial port"
 		depends on FOOTBRIDGE
@@ -114,18 +126,6 @@ config EARLY_PRINTK
 	  kernel low-level debugging functions. Add earlyprintk to your
 	  kernel parameters to enable this console.
 
-config DEBUG_ICEDCC
-	bool "Kernel low-level debugging via EmbeddedICE DCC channel"
-	depends on DEBUG_LL
-	help
-	  Say Y here if you want the debug print routines to direct their
-	  output to the EmbeddedICE macrocell's DCC channel using
-	  co-processor 14. This is known to work on the ARM9 style ICE
-	  channel and on the XScale with the PEEDI.
-
-	  It does include a timeout to ensure that the system does not
-	  totally freeze when there is nothing connected to read.
-
 config OC_ETM
 	bool "On-chip ETM and ETB"
 	select ARM_AMBA
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


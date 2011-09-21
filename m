Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab1IUBYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 21:24:04 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42126 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1IUBYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 21:24:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6475"; a="120090945"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
Subject: [PATCHv2 2/2] ARM: debug: Move DEBUG_ICEDCC into the DEBUG_LL choice
Date: Tue, 20 Sep 2011 18:23:28 -0700
Message-Id: <1316568208-4518-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.7.rc0.70.g82660
In-Reply-To: <1316568208-4518-1-git-send-email-sboyd@codeaurora.org>
References: <1316568208-4518-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEBUG_ICEDCC support is just another DEBUG_LL choice and
selecting it along with other DEBUG_LL options doesn't make
much sense. Put it into the DEBUG_LL choice to avoid confusion.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/Kconfig.debug |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 6dbcb00..31896f4 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -81,6 +81,17 @@ choice
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
 
 	config DEBUG_FOOTBRIDGE_COM1
 		bool "Kernel low-level debugging messages via footbridge 8250 at PCI COM1"
@@ -120,18 +131,6 @@ config EARLY_PRINTK
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


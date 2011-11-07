Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891Ab1KGQRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:17:51 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50299 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932837Ab1KGQR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:17:29 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 16/16] ARM: LPAE: Add the Kconfig entries
Date: Mon,  7 Nov 2011 16:16:58 +0000
Message-Id: <1320682618-1182-17-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Nov 2011 16:17:14.0654 (UTC) FILETIME=[B63D6BE0:01CC9D68]
X-MC-Unique: 111110716172610001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pA7GIPKv015284

This patch adds the ARM_LPAE and ARCH_PHYS_ADDR_T_64BIT Kconfig entries
allowing LPAE support to be compiled into the kernel.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/Kconfig    |    2 +-
 arch/arm/mm/Kconfig |   17 +++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 44789ef..885c04e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1959,7 +1959,7 @@ endchoice
 
 config XIP_KERNEL
 	bool "Kernel Execute-In-Place from ROM"
-	depends on !ZBOOT_ROM
+	depends on !ZBOOT_ROM && !ARM_LPAE
 	help
 	  Execute-In-Place allows the kernel to run from non-volatile storage
 	  directly addressable by the CPU, such as NOR flash. This saves RAM
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 67f75a0..d289cdb 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -629,6 +629,23 @@ config IO_36
 
 comment "Processor Features"
 
+config ARM_LPAE
+	bool "Support for the Large Physical Address Extension"
+	depends on MMU && CPU_V7
+	help
+	  Say Y if you have an ARMv7 processor supporting the LPAE page
+	  table format and you would like to access memory beyond the
+	  4GB limit. The resulting kernel image will not run on
+	  processors without the LPA extension.
+
+	  If unsure, say N.
+
+config ARCH_PHYS_ADDR_T_64BIT
+	def_bool ARM_LPAE
+
+config ARCH_DMA_ADDR_T_64BIT
+	def_bool ARM_LPAE
+
 config ARM_THUMB
 	bool "Support Thumb user binaries"
 	depends on CPU_ARM720T || CPU_ARM740T || CPU_ARM920T || CPU_ARM922T || CPU_ARM925T || CPU_ARM926T || CPU_ARM940T || CPU_ARM946E || CPU_ARM1020 || CPU_ARM1020E || CPU_ARM1022 || CPU_ARM1026 || CPU_XSCALE || CPU_XSC3 || CPU_MOHAWK || CPU_V6 || CPU_V6K || CPU_V7 || CPU_FEROCEON


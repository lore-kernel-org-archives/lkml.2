Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586Ab1EXVkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:40:07 -0400
Received: from service87.mimecast.com ([94.185.240.25]:34911 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933544Ab1EXVjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:39:51 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v6 18/18] ARM: LPAE: Add the Kconfig entries
Date: Tue, 24 May 2011 22:39:24 +0100
Message-Id: <1306273164-18217-19-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 24 May 2011 21:39:50.0693 (UTC) FILETIME=[1C5A5550:01CC1A5B]
X-MC-Unique: 111052422394900701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p4OLeVjD005038

This patch adds the ARM_LPAE and ARCH_PHYS_ADDR_T_64BIT Kconfig entries
allowing LPAE support to be compiled into the kernel.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/Kconfig    |    2 +-
 arch/arm/mm/Kconfig |   13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e18c2c2..c7b01b0 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1774,7 +1774,7 @@ config CMDLINE_FORCE
 
 config XIP_KERNEL
 	bool "Kernel Execute-In-Place from ROM"
-	depends on !ZBOOT_ROM
+	depends on !ZBOOT_ROM && !ARM_LPAE
 	help
 	  Execute-In-Place allows the kernel to run from non-volatile storage
 	  directly addressable by the CPU, such as NOR flash. This saves RAM
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 490c231..afb5231 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -629,6 +629,19 @@ config IO_36
 
 comment "Processor Features"
 
+config ARM_LPAE
+	bool "Support for the Large Physical Address Extension"
+	depends on MMU && CPU_V7
+	help
+	  Say Y if you have an ARMv7 processor supporting the LPAE page table
+	  format and you would like to access memory beyond the 4GB limit.
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


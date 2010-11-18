Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab0KRIFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:05:44 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35814 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab0KRIFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:05:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=eOOXa9anJHTWSXZz/mILrhPMd6Tbf5X7Nt8fZWiuuwJYc0gktdQWNlXUchIAdoBpPr
         SCWgMuiRy3M3Y5i4HsyqJZM4fZX64Qi//zUtR9fnnu87VPCJPLb3k1SxxAKMqGcs41fp
         fS4T89nmB2MlGvVpaQ5/LLPkCTio1KKAcr6Tg=
Subject: [PATCH] Select R4K timer lib for all MSP platforms
From: Anoop P A <anoop.pa@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 13:42:28 +0530
Message-ID: <1290067948.9091.14.camel@paanoop1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c872cbbe5f475d3bb3cb7f821270cb466eead1f7 Mon Sep 17 00:00:00 2001
From: Anoop P A <anoop.pa@gmail.com>
Signed-off-by: Anoop P A <anoop.pa@gmail.com>
Date: Thu, 18 Nov 2010 01:33:36 +0530
Subject: [PATCH] Select R4K timer lib for all MSP platforms

---
 arch/mips/Kconfig                       |    2 ++
 arch/mips/pmc-sierra/Kconfig            |    4 ----
 arch/mips/pmc-sierra/msp71xx/msp_time.c |    2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 7fc6bd1..168cdbe 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -316,6 +316,8 @@ config PNX8550_STB810
 config PMC_MSP
 	bool "PMC-Sierra MSP chipsets"
 	depends on EXPERIMENTAL
+	select CEVT_R4K
+	select CSRC_R4K
 	select DMA_NONCOHERENT
 	select SWAP_IO_SPACE
 	select NO_EXCEPT_FILL
diff --git a/arch/mips/pmc-sierra/Kconfig b/arch/mips/pmc-sierra/Kconfig
index c139988..8d79849 100644
--- a/arch/mips/pmc-sierra/Kconfig
+++ b/arch/mips/pmc-sierra/Kconfig
@@ -4,15 +4,11 @@ choice
 
 config PMC_MSP4200_EVAL
 	bool "PMC-Sierra MSP4200 Eval Board"
-	select CEVT_R4K
-	select CSRC_R4K
 	select IRQ_MSP_SLP
 	select HW_HAS_PCI
 
 config PMC_MSP4200_GW
 	bool "PMC-Sierra MSP4200 VoIP Gateway"
-	select CEVT_R4K
-	select CSRC_R4K
 	select IRQ_MSP_SLP
 	select HW_HAS_PCI
 
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_time.c
b/arch/mips/pmc-sierra/msp71xx/msp_time.c
index cca64e1..01df84c 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_time.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_time.c
@@ -81,7 +81,7 @@ void __init plat_time_init(void)
 	mips_hpt_frequency = cpu_rate/2;
 }
 
-unsigned int __init get_c0_compare_int(void)
+unsigned int __cpuinit get_c0_compare_int(void)
 {
 	return MSP_INT_VPE0_TIMER;
 }
-- 
1.7.0.4




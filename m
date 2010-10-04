Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0JDMQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 08:16:21 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:33721 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755567Ab0JDMQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 08:16:18 -0400
Date: Mon, 4 Oct 2010 14:10:45 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] staging/spectra: remove duplicated includes
Message-ID: <20101004141045.0454ad66@absol.kitzblitz>
In-Reply-To: <20101004140610.2c8fb91a@absol.kitzblitz>
References: <20101004140610.2c8fb91a@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated includes.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/staging/spectra/lld_emu.c |   10 ++++------
 drivers/staging/spectra/lld_mtd.c |    8 ++------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/spectra/lld_emu.c b/drivers/staging/spectra/lld_emu.c
index 60eb0f6..6733bbf 100644
--- a/drivers/staging/spectra/lld_emu.c
+++ b/drivers/staging/spectra/lld_emu.c
@@ -25,6 +25,10 @@
 #include "lld.h"
 #if CMD_DMA
 #include "lld_cdma.h"
+#if FLASH_EMU
+u32 totalUsedBanks;
+u32 valid_banks[MAX_CHANS];
+#endif
 #endif
 
 #define GLOB_LLD_PAGES           64
@@ -32,12 +36,6 @@
 #define GLOB_LLD_PAGE_DATA_SIZE  512
 #define GLOB_LLD_BLOCKS          2048
 
-#if (CMD_DMA  && FLASH_EMU)
-#include "lld_cdma.h"
-u32 totalUsedBanks;
-u32 valid_banks[MAX_CHANS];
-#endif
-
 #if FLASH_EMU			/* This is for entire module */
 
 static u8 *flash_memory[GLOB_LLD_BLOCKS * GLOB_LLD_PAGES];
diff --git a/drivers/staging/spectra/lld_mtd.c b/drivers/staging/spectra/lld_mtd.c
index 0de05b1..2bd3466 100644
--- a/drivers/staging/spectra/lld_mtd.c
+++ b/drivers/staging/spectra/lld_mtd.c
@@ -26,6 +26,8 @@
 #include "lld.h"
 #if CMD_DMA
 #include "lld_cdma.h"
+u32 totalUsedBanks;
+u32 valid_banks[MAX_CHANS];
 #endif
 
 #define GLOB_LLD_PAGES           64
@@ -33,12 +35,6 @@
 #define GLOB_LLD_PAGE_DATA_SIZE  512
 #define GLOB_LLD_BLOCKS          2048
 
-#if CMD_DMA
-#include "lld_cdma.h"
-u32 totalUsedBanks;
-u32 valid_banks[MAX_CHANS];
-#endif
-
 static struct mtd_info *spectra_mtd;
 static int mtddev = -1;
 module_param(mtddev, int, 0);
-- 
1.7.2.2

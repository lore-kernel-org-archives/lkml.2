Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623Ab1FATra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:47:30 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59093 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759597Ab1FATr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:47:27 -0400
Message-Id: <20110601180610.295501825@duck.linux-mips.net>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 19:05:00 +0100
From: ralf@linux-mips.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-mips@linux-mips.org
Subject: [patch 04/14] i8253: Make MIPS use the shared i8253_lock.
References: <20110601180456.801265664@duck.linux-mips.net>
Content-Disposition: inline; filename=i8253-move-mips-to-shared-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org

 arch/mips/Kconfig        |    1 +
 arch/mips/kernel/i8253.c |    3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

Index: linux-mips/arch/mips/Kconfig
===================================================================
--- linux-mips.orig/arch/mips/Kconfig
+++ linux-mips/arch/mips/Kconfig
@@ -2388,6 +2388,7 @@ config MMU
 config I8253
 	bool
 	select CLKSRC_I8253
+	select I8253_LOCK
 	select MIPS_EXTERNAL_TIMER
 
 config ZONE_DMA32
Index: linux-mips/arch/mips/kernel/i8253.c
===================================================================
--- linux-mips.orig/arch/mips/kernel/i8253.c
+++ linux-mips/arch/mips/kernel/i8253.c
@@ -16,9 +16,6 @@
 #include <asm/io.h>
 #include <asm/time.h>
 
-DEFINE_RAW_SPINLOCK(i8253_lock);
-EXPORT_SYMBOL(i8253_lock);
-
 /*
  * Initialize the PIT timer.
  *



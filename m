Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab1HBPdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 11:33:53 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:29447 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab1HBPdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 11:33:49 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: grant.likely@secretlab.ca, niklas.hernaeus@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] fix for: Build a uImage with dtb already appended
Date: Tue,  2 Aug 2011 16:33:27 +0100
Message-Id: <1312299207-12735-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110802143148.21599.22870.stgit@ponder>
References: <20110802143148.21599.22870.stgit@ponder>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 arch/arm/boot/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/Makefile b/arch/arm/boot/Makefile
index a64493b..68d6f23 100644
--- a/arch/arm/boot/Makefile
+++ b/arch/arm/boot/Makefile
@@ -75,8 +75,10 @@ quiet_cmd_uimage = UIMAGE  $@
 
 ifeq ($(CONFIG_ZBOOT_ROM),y)
 $(obj)/uImage: LOADADDR=$(CONFIG_ZBOOT_ROM_TEXT)
+$(obj)/uImage-dtb.%: LOADADDR=$(CONFIG_ZBOOT_ROM_TEXT)
 else
 $(obj)/uImage: LOADADDR=$(ZRELADDR)
+$(obj)/uImage-dtb.%: LOADADDR=$(ZRELADDR)
 endif
 
 $(obj)/uImage: STARTADDR=$(LOADADDR)
-- 
1.7.4.1


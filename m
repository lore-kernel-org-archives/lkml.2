Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab1LBUZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 15:25:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51677 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab1LBUZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 15:25:42 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Nicolas Pitre <nicolas.pitre@linaro.org>
Date: Fri,  2 Dec 2011 21:23:35 +0100
Message-Id: <1322857415-26753-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <alpine.LFD.2.02.1112021426420.2357@xanadu.home>
References: <alpine.LFD.2.02.1112021426420.2357@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] ARM: determine PHYS_OFFSET automatically for no-mmu configs
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Pitre <nicolas.pitre@linaro.org>

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 44789ef..763de24 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -220,8 +220,9 @@ config NEED_MACH_MEMORY_H
 	  be avoided when possible.
 
 config PHYS_OFFSET
-	hex "Physical address of main memory"
+	hex "Physical address of main memory" if MMU
 	depends on !ARM_PATCH_PHYS_VIRT && !NEED_MACH_MEMORY_H
+	default DRAM_BASE if !MMU
 	help
 	  Please provide the physical address corresponding to the
 	  location of main memory in your system.
-- 
1.7.7.3


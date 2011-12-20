Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab1LTAnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:43:37 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36867 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753682Ab1LTAnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:43:33 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT 
	,commit_signer:1/2=50%),
        Will Deacon <will.deacon@arm.com> (commit_signer:1/2=50%),
        linux-arm-kernel@lists.infradead.org (open list:ARM PORT)
Subject: [PATCH 02/10] arm: vexpress: fix kconfig warning
Date: Tue, 20 Dec 2011 02:42:19 +0200
Message-Id: <1324341747-5922-3-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
In-Reply-To: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
References: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: (ARCH_OMAP4 && ARCH_VEXPRESS_CA9X4) selects ARM_ERRATA_720789 which has unmet direct dependencies (CPU_V7 && SMP)
warning: (ARCH_VEXPRESS_CA9X4) selects ARM_ERRATA_751472 which has unmet direct dependencies (CPU_V7 && SMP)

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 arch/arm/mach-vexpress/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-vexpress/Kconfig b/arch/arm/mach-vexpress/Kconfig
index 9311484..3fbcb8c 100644
--- a/arch/arm/mach-vexpress/Kconfig
+++ b/arch/arm/mach-vexpress/Kconfig
@@ -5,8 +5,8 @@ config ARCH_VEXPRESS_CA9X4
 	bool "Versatile Express Cortex-A9x4 tile"
 	select CPU_V7
 	select ARM_GIC
-	select ARM_ERRATA_720789
-	select ARM_ERRATA_751472
+	select ARM_ERRATA_720789 if SMP
+	select ARM_ERRATA_751472 if SMP
 	select ARM_ERRATA_753970
 
 endmenu
-- 
1.7.8.rc1.14.g248db


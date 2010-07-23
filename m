Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981Ab0GWT7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 15:59:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43127 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab0GWT7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:59:07 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Lennert Buytenhek <kernel@wantstofly.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Martin Michlmayr <tbm@cyrius.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] ARM: kirkwood: move qnap_tsx1x_register_flash() to .init.text
Date: Fri, 23 Jul 2010 21:58:25 +0200
Message-Id: <1279915120-4373-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qnap_tsx1x_register_flash is only called by qnap_ts219_init and
qnap_ts41x_init which both live in .init.text, too.  So the move is OK.

This fixes the following warning in kirkwood_defconfig:
	WARNING: vmlinux.o(.text+0x9334): Section mismatch in reference from the function qnap_tsx1x_register_flash() to the variable .init.data:qnap_tsx1x_spi_slave_info
	The function qnap_tsx1x_register_flash() references
	the variable __initdata qnap_tsx1x_spi_slave_info.
	This is often because qnap_tsx1x_register_flash lacks a __initdata
	annotation or the annotation of qnap_tsx1x_spi_slave_info is wrong.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/mach-kirkwood/tsx1x-common.c |    2 +-
 arch/arm/mach-kirkwood/tsx1x-common.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-kirkwood/tsx1x-common.c b/arch/arm/mach-kirkwood/tsx1x-common.c
index 7221c20..f781164 100644
--- a/arch/arm/mach-kirkwood/tsx1x-common.c
+++ b/arch/arm/mach-kirkwood/tsx1x-common.c
@@ -77,7 +77,7 @@ struct spi_board_info __initdata qnap_tsx1x_spi_slave_info[] = {
 	},
 };
 
-void qnap_tsx1x_register_flash(void)
+void __init qnap_tsx1x_register_flash(void)
 {
 	spi_register_board_info(qnap_tsx1x_spi_slave_info,
 				ARRAY_SIZE(qnap_tsx1x_spi_slave_info));
diff --git a/arch/arm/mach-kirkwood/tsx1x-common.h b/arch/arm/mach-kirkwood/tsx1x-common.h
index 9a59296..7fa0373 100644
--- a/arch/arm/mach-kirkwood/tsx1x-common.h
+++ b/arch/arm/mach-kirkwood/tsx1x-common.h
@@ -1,7 +1,7 @@
 #ifndef __ARCH_KIRKWOOD_TSX1X_COMMON_H
 #define __ARCH_KIRKWOOD_TSX1X_COMMON_H
 
-extern void qnap_tsx1x_register_flash(void);
+extern void __init qnap_tsx1x_register_flash(void);
 extern void qnap_tsx1x_power_off(void);
 
 #endif
-- 
1.7.1


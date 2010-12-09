Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab0LINru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:47:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42254 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab0LINr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:47:29 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Zhang Lily-R58066 <r58066@freescale.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 7/9] ARM i.MX5: Allow to increase max zone order
Date: Thu,  9 Dec 2010 14:47:19 +0100
Message-Id: <1291902441-24712-8-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

default setting of 11 allows us to allocate at maximum
2MB chunks of contiguous memory. For resolutions up to
1920x1080 32bpp we need much more memory, so make zone
order configurable

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index db524e7..b3e070e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1410,8 +1410,8 @@ config SPARSE_IRQ
 source "mm/Kconfig"
 
 config FORCE_MAX_ZONEORDER
-	int "Maximum zone order" if ARCH_SHMOBILE
-	range 11 64 if ARCH_SHMOBILE
+	int "Maximum zone order" if ARCH_SHMOBILE || ARCH_MX5
+	range 11 64 if ARCH_SHMOBILE || ARCH_MX5
 	default "9" if SA1111
 	default "11"
 	help
-- 
1.7.2.3


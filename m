Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178Ab2CWROL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:14:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40425 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759127Ab2CWROH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:14:07 -0400
From: mathieu.poirier@linaro.org
To: tony@atomide.com
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: [PATCH 2/9] omap: fix visibility of omap2_mbox_iva_priv
Date: Fri, 23 Mar 2012 11:13:49 -0600
Message-Id: <1332522836-29517-3-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
References: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

map2_mbox_iva_priv is used on multiple omap2 socs but is hidden
in an outdated #ifdef that is specific to a single soc.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/mach-omap2/mailbox.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
index 415a6f1..ef01f6c 100644
--- a/arch/arm/mach-omap2/mailbox.c
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -258,7 +258,7 @@ struct omap_mbox mbox_dsp_info = {
 struct omap_mbox *omap3_mboxes[] = { &mbox_dsp_info, NULL };
 #endif
 
-#if defined(CONFIG_SOC_OMAP2420)
+#if defined(CONFIG_ARCH_OMAP2)
 /* IVA */
 static struct omap_mbox2_priv omap2_mbox_iva_priv = {
 	.tx_fifo = {
-- 
1.7.5.4


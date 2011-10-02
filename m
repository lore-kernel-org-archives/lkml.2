Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab1JBOrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:47:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58770 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1JBOqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:46:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 07/30] ARM: omap: fix visibility of omap2_mbox_iva_priv
Date: Sun,  2 Oct 2011 16:45:37 +0200
Message-Id: <1317566760-25681-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:AipQJntyyHpNcT1fLCXk8odbziPWn0FP2wv1D2JfkZT
 vQ+qo1H8Vzi/fwIPJC9URbtT74zO5UbjsZZjyaUKq3XrGtgtXb
 aKezz9KuMRdTjDm+SoeWYMvjW0+6JLkPFZ0sPr8jjXQD2rebgp
 e9n/sr/K820faLHpOWaGo4UDpf7Qrr7O88rJbJGcpGxZR8JmAx
 h8GaGvm+dbw6IMyo5gvy9V32/lVnrI4MGT8Y5yLVlsrdcOThyi
 aoRqu9GViKH0qp1UZPQeOpJaYBB2WFduqEghJhXiPqpa+CzSJg
 nZp/KEMG5aAkiQ+HoLPRG40KIiunCYL4qgsmPXBLKScX/Ylgiu
 EbTql5LgGaqXlDxuX+/dgBYp+OnWb8dIuxaI6jRMLBH8dRCEJs
 Yhseb/C0V3Acg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

map2_mbox_iva_priv is used on multiple omap2 socs but is hidden
in an outdated #ifdef that is specific to a single soc.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-omap2/mailbox.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
index 86d564a..5a2a0e4 100644
--- a/arch/arm/mach-omap2/mailbox.c
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -257,7 +257,7 @@ struct omap_mbox mbox_dsp_info = {
 struct omap_mbox *omap3_mboxes[] = { &mbox_dsp_info, NULL };
 #endif
 
-#if defined(CONFIG_SOC_OMAP2420)
+#if defined(CONFIG_ARCH_OMAP2)
 /* IVA */
 static struct omap_mbox2_priv omap2_mbox_iva_priv = {
 	.tx_fifo = {
-- 
1.7.5.4


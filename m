Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab2K2Upz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:45:55 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:63515 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab2K2Upu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:45:50 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de
Cc: backports@vger.kernel.org, alexander.stein@systec-electronic.com,
        brudley@broadcom.com, rvossen@broadcom.com, arend@broadcom.com,
        frankyl@broadcom.com, kanyan@broadcom.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, srinidhi.kasagar@stericsson.com,
        linus.walleij@linaro.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 6/6] ie6xx_wdt: convert struct spinlock to spinlock_t
Date: Thu, 29 Nov 2012 12:45:10 -0800
Message-Id: <1354221910-22493-7-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354221910-22493-1-git-send-email-mcgrof@do-not-panic.com>
References: <1354221910-22493-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

spinlock_t should always be used.

  CHECK   drivers/watchdog/ie6xx_wdt.c
  CC [M]  drivers/watchdog/ie6xx_wdt.o
  Building modules, stage 2.
  MODPOST 43 modules
  LD [M]  drivers/watchdog/ie6xx_wdt.ko

Cc: Alexander Stein <alexander.stein@systec-electronic.com>
Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/watchdog/ie6xx_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/ie6xx_wdt.c b/drivers/watchdog/ie6xx_wdt.c
index e24ef6a..f2d6573 100644
--- a/drivers/watchdog/ie6xx_wdt.c
+++ b/drivers/watchdog/ie6xx_wdt.c
@@ -82,7 +82,7 @@ MODULE_PARM_DESC(resetmode,
 
 static struct {
 	unsigned short sch_wdtba;
-	struct spinlock unlock_sequence;
+	spinlock_t unlock_sequence;
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debugfs;
 #endif
-- 
1.7.10.4


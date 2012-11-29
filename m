Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab2K2Up0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:45:26 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2K2UpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:45:23 -0500
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
Subject: [PATCH 1/6] ux500: convert struct spinlock to spinlock_t
Date: Thu, 29 Nov 2012 12:45:05 -0800
Message-Id: <1354221910-22493-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354221910-22493-1-git-send-email-mcgrof@do-not-panic.com>
References: <1354221910-22493-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

spinlock_t should always be used.

I was unable to build test with allmodconfig:

mcgrof@frijol ~/linux-next (git::(no branch))$ make C=1 M=drivers/crypto/ux500/

  WARNING: Symbol version dump /home/mcgrof/linux-next/Module.symvers
           is missing; modules will have no dependencies and modversions.

  LD      drivers/crypto/ux500/built-in.o
  Building modules, stage 2.
  MODPOST 0 modules

Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/crypto/ux500/cryp/cryp.h     |    4 ++--
 drivers/crypto/ux500/hash/hash_alg.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp.h b/drivers/crypto/ux500/cryp/cryp.h
index 14cfd05..ba324b2 100644
--- a/drivers/crypto/ux500/cryp/cryp.h
+++ b/drivers/crypto/ux500/cryp/cryp.h
@@ -236,12 +236,12 @@ struct cryp_device_data {
 	struct clk *clk;
 	struct regulator *pwr_regulator;
 	int power_status;
-	struct spinlock ctx_lock;
+	spinlock_t ctx_lock;
 	struct cryp_ctx *current_ctx;
 	struct klist_node list_node;
 	struct cryp_dma dma;
 	bool power_state;
-	struct spinlock power_state_spinlock;
+	spinlock_t power_state_spinlock;
 	bool restore_dev_ctx;
 };
 
diff --git a/drivers/crypto/ux500/hash/hash_alg.h b/drivers/crypto/ux500/hash/hash_alg.h
index cd9351c..0183f5e 100644
--- a/drivers/crypto/ux500/hash/hash_alg.h
+++ b/drivers/crypto/ux500/hash/hash_alg.h
@@ -363,10 +363,10 @@ struct hash_device_data {
 	struct hash_register __iomem	*base;
 	struct klist_node	list_node;
 	struct device		*dev;
-	struct spinlock		ctx_lock;
+	spinlock_t		ctx_lock;
 	struct hash_ctx		*current_ctx;
 	bool			power_state;
-	struct spinlock		power_state_lock;
+	spinlock_t		power_state_lock;
 	struct regulator	*regulator;
 	struct clk		*clk;
 	bool			restore_dev_state;
-- 
1.7.10.4


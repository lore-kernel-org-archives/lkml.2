Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab1BXBge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 20:36:34 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55091 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab1BXBgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 20:36:32 -0500
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-omap@vger.kernel.org,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Alexander Shishkin <virtuoso@slind.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 9/9 (originally 8)] ARM: etm: Power down etm(s) when tracing is not enabled
Date: Wed, 23 Feb 2011 17:36:09 -0800
Message-Id: <1298511369-20257-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1296701663-12168-1-git-send-email-arve@android.com>
References: <1296701663-12168-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this change a saw an 18% increase in idle power consumption
on one deivce when trace support is compiled into the kernel. Now
I see the same increase only when tracing.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 arch/arm/kernel/etm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 48de5a4..f2bc95e 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -199,7 +199,7 @@ static int trace_stop_etm(struct tracectx *t, int id)
 
 	etm_unlock(t, id);
 
-	etm_writel(t, id, 0x440, ETMR_CTRL);
+	etm_writel(t, id, 0x441, ETMR_CTRL);
 	while (!(etm_readl(t, id, ETMR_CTRL) & ETMCTRL_PROGRAM) && --timeout)
 		;
 	if (!timeout) {
@@ -738,7 +738,7 @@ static int __init etm_probe(struct amba_device *dev, struct amba_id *id)
 	(void)etm_readl(&tracer, t->etm_regs_count, ETMMR_OSSRR);
 
 	t->ncmppairs = etm_readl(t, t->etm_regs_count, ETMR_CONFCODE) & 0xf;
-	etm_writel(t, t->etm_regs_count, 0x440, ETMR_CTRL);
+	etm_writel(t, t->etm_regs_count, 0x441, ETMR_CTRL);
 	etm_writel(t, t->etm_regs_count, new_count, ETMR_TRACEIDR);
 	etm_lock(t, t->etm_regs_count);
 
-- 
1.7.3.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab0GYRLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 13:11:37 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:40778 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab0GYRLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 13:11:10 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] etm: do a dummy read from OSSRR during initialization
Date: Sun, 25 Jul 2010 20:05:17 +0300
Message-Id: <1280077520-7538-5-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
References: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first read from ETM OS save and restore register after the power
down bit deassertion returns garbage.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/kernel/etm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index d08062b..73b824a 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -558,7 +558,9 @@ static int __init etm_probe(struct amba_device *dev, struct amba_id *id)
 	t->etm_portsz = 1;
 
 	etm_unlock(t);
-	ret = etm_readl(t, ETMMR_PDSR);
+	(void)etm_readl(t, ETMMR_PDSR);
+	/* dummy first read */
+	(void)etm_readl(&tracer, ETMMR_OSSRR);
 
 	t->ncmppairs = etm_readl(t, ETMR_CONFCODE) & 0xf;
 	etm_writel(t, 0x440, ETMR_CTRL);
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab2ANUKo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 15:10:44 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:43950 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab2ANUKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 15:10:43 -0500
From: jhbird.choi@samsung.com
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH] mfd: variable dereferenced before check
Date: Fri, 13 Jan 2012 10:40:52 +0900
Message-Id: <1326418852-19378-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

Remove "wm8350->irq_base = pdata->irq_base" to avoid
null pointer exception and wm8350->irq_base got from
irq_alloc_descs().

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/mfd/wm8350-irq.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8350-irq.c b/drivers/mfd/wm8350-irq.c
index 8a1fafd..9fd01bf 100644
--- a/drivers/mfd/wm8350-irq.c
+++ b/drivers/mfd/wm8350-irq.c
@@ -496,7 +496,6 @@ int wm8350_irq_init(struct wm8350 *wm8350, int irq,
 
 	mutex_init(&wm8350->irq_lock);
 	wm8350->chip_irq = irq;
-	wm8350->irq_base = pdata->irq_base;
 
 	if (pdata && pdata->irq_base > 0)
 		irq_base = pdata->irq_base;
-- 
1.7.1

